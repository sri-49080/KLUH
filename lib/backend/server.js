const express = require('express');
const http = require('http');
const socketIo=require('socket.io');
const mongoose = require('mongoose');
const PostRoutes = require('./routes/PostRoutes.js');
const authRoutes = require('./routes/authRoutes.js');
const userUpdateRoutes = require('./routes/profileupdate.js');  
const userLogoUploadRoutes = require('./routes/userLogoUpload.js');
const chat = require('./routes/chatRoutes.js'); // AI chatbot route
const messageRoutes = require('./routes/messageRoutes.js'); // Message routes
const skillMatchRoutes = require('./routes/skillMatch.js'); // Skill matching route
const connectionRoutes = require('./routes/connectionRoutes.js'); // Connection requests
const notificationRoutes = require('./routes/notificationRoutes.js'); // Notification routes
const reviewRoutes = require('./routes/reviewRoutes.js'); // Review routes
const todoRoutes = require('./routes/todoRoutes.js'); // Todo routes
const eventRoutes = require('./routes/eventRoutes.js'); // Event routes
const cors = require('cors');

const Message = require('./models/Message.js'); // Import the Message model
const NotificationService = require('./services/notificationService');
const { JsonWebTokenError } = require('jsonwebtoken');
require('dotenv').config();
const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
    credentials: false
  },
  transports: ['websocket', 'polling'],
  pingTimeout: 60000,
  pingInterval: 25000
});

// Enhanced CORS configuration
app.use(cors({
  origin: [
    'http://localhost:3000',
    'https://skillsocket-backend.onrender.com',
    'https://localhost:*', // Allow any localhost port for development
  ],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

// Enhanced JSON parsing with error handling
app.use(express.json({ 
  limit: '10mb',
  type: 'application/json'
}));

app.use(express.urlencoded({ 
  extended: true, 
  limit: '10mb' 
}));

// Request logging middleware
app.use((req, res, next) => {
  console.log(`📡 ${req.method} ${req.path} - ${new Date().toISOString()}`);
  if (req.body && Object.keys(req.body).length > 0) {
    console.log('📋 Request body keys:', Object.keys(req.body));
  }
  next();
});

// Error handling middleware for JSON parsing
app.use((error, req, res, next) => {
  if (error instanceof SyntaxError && error.status === 400 && 'body' in error) {
    console.error('❌ Bad JSON syntax:', error.message);
    return res.status(400).json({ 
      success: false, 
      message: 'Invalid JSON format in request body' 
    });
  }
  next();
});
app.use('/api/posts', PostRoutes);
// Basic health check route
app.get('/', (req, res) => {
  res.status(200).json({ 
    message: 'SkillSocket Backend is running!', 
    status: 'OK',
    timestamp: new Date().toISOString(),
    port: process.env.PORT || 3000
  });
});

// Simple ping endpoint for Render health checks
app.get('/ping', (req, res) => {
  res.status(200).send('pong');
});

// Health check endpoint for Docker and monitoring
app.get('/api/health', (req, res) => {
  const healthCheck = {
    uptime: process.uptime(),
    message: 'OK',
    timestamp: Date.now(),
    status: 'healthy',
    version: process.env.npm_package_version || '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    memory: {
      usage: process.memoryUsage(),
      free: process.memoryUsage().heapTotal - process.memoryUsage().heapUsed
    }
  };
  
  try {
    // Check database connection
    if (mongoose.connection.readyState === 1) {
      healthCheck.database = {
        status: 'connected',
        name: mongoose.connection.name,
        host: mongoose.connection.host,
        port: mongoose.connection.port
      };
    } else {
      healthCheck.database = {
        status: 'disconnected',
        readyState: mongoose.connection.readyState
      };
      healthCheck.status = 'unhealthy';
      healthCheck.message = 'Database connection failed';
    }
    
    // Check environment variables
    const requiredEnvVars = ['MONGODB_URI', 'JWT_SECRET'];
    const missingEnvVars = requiredEnvVars.filter(envVar => !process.env[envVar]);
    
    if (missingEnvVars.length > 0) {
      healthCheck.status = 'unhealthy';
      healthCheck.message = `Missing environment variables: ${missingEnvVars.join(', ')}`;
      healthCheck.missingEnvVars = missingEnvVars;
    }
    
    const statusCode = healthCheck.status === 'healthy' ? 200 : 503;
    res.status(statusCode).json(healthCheck);
  } catch (error) {
    healthCheck.message = error.message;
    healthCheck.status = 'unhealthy';
    healthCheck.error = error.stack;
    res.status(503).json(healthCheck);
  }
});

// Register user update routes
app.use('/api/user', userUpdateRoutes);

// Register user logo upload routes
app.use('/api/user', userLogoUploadRoutes);

// Register auth routes  
app.use('/api/auth', authRoutes);

// Register chatbot routes
app.use('/api/chat', chat);

// Register message routes
app.use('/api/messages', messageRoutes);

// Register skill matching routes
app.use('/api/users', skillMatchRoutes);

// Register connection routes
app.use('/api/connections', connectionRoutes);

// Register notification routes
app.use('/api/notifications', notificationRoutes);

// Register review routes
app.use('/api/reviews', reviewRoutes);

// Register todo routes
app.use('/api/todos', todoRoutes);

// Register event routes
app.use('/api/events', eventRoutes);

// Export io for use in other modules
module.exports = { io };

const MONGODB_URI = process.env.MONGODB_URI;

console.log('📊 Connecting to MongoDB...');
console.log('🔗 MongoDB URI exists:', !!MONGODB_URI);

if (!MONGODB_URI) {
  console.error('❌ MONGODB_URI environment variable is not set');
  process.exit(1);
}

mongoose.connect(MONGODB_URI, {
  serverSelectionTimeoutMS: 10000, // Increased timeout for deployment
  socketTimeoutMS: 45000,
  maxPoolSize: 10, // Limit connection pool size
  retryWrites: true,
  w: 'majority'
})
  .then(() => {
    console.log("✅ MongoDB connected successfully");
    console.log("📊 Database ready state:", mongoose.connection.readyState);
    console.log("🏷️  Database name:", mongoose.connection.name);
  })
  .catch(err => {
    console.error("❌ MongoDB connection error:", err.message);
    console.error("❌ Full error:", err);
    process.exit(1);
  });

// Handle MongoDB connection events
mongoose.connection.on('error', (err) => {
  console.error('❌ MongoDB connection error:', err);
});

mongoose.connection.on('disconnected', () => {
  console.log('📊 MongoDB disconnected');
});

mongoose.connection.on('reconnected', () => {
  console.log('📊 MongoDB reconnected');
});

const onlineUsers = new Map();

io.on('connection', (socket) => {
  console.log('New client connected:', socket.id);
  
  // User joins room
  socket.on('joinRoom', (userId) => {
    onlineUsers.set(userId, socket.id);
    socket.join(userId);
    console.log(`User ${userId} connected with socket ${socket.id}`);
  });

  // Handle typing indicators
  socket.on('typing', ({ from, to }) => {
    if (onlineUsers.has(to)) {
      io.to(to).emit('typing', { from });
    }
  });

  socket.on('stopTyping', ({ from, to }) => {
    if (onlineUsers.has(to)) {
      io.to(to).emit('stopTyping', { from });
    }
  });

  // Handle sending messages
  socket.on('sendMessage', async ({ from, to, content }) => {
    try {
      const newMsg = await Message.create({
        from,
        to,
        content,
        seen: false
      });
      
      // Populate the message with user details
      const populatedMsg = await Message.findById(newMsg._id)
        .populate('from', 'name email')
        .populate('to', 'name email');

      // Send message to recipient
      io.to(to).emit('receiveMessage', populatedMsg);
      
      // Always send push notification for messages (even if user is online)
      // This matches WhatsApp behavior - push notifications for all messages
      await NotificationService.notifyNewMessage(from, to, content, `${from}_${to}`);
      
      // Don't send back to sender to prevent duplicates
      // Instead, emit delivery confirmation
      if (onlineUsers.has(to)) {
        // User is online, message delivered immediately
        io.to(from).emit('messageDelivered', { messageId: newMsg._id });
        
        // After a short delay, mark as read (simulating user seeing the message)
        setTimeout(() => {
          io.to(from).emit('messageRead', { messageId: newMsg._id });
        }, 2000);
      }
    } catch (err) {
      console.error("Error sending message:", err);
    }
  });

  // Handle marking messages as seen
  socket.on('markAsSeen', async ({ from, to }) => {
    try {
      await Message.updateMany(
        { from, to, seen: false },
        { $set: { seen: true } }
      );
      if (onlineUsers.has(from)) {
        io.to(from).emit('messagesSeen', { by: to });
      }
    } catch (err) {
      console.error("Error marking messages as seen:", err);
    }
  });

  // Handle user disconnection
  socket.on('disconnect', () => {
    onlineUsers.forEach((socketId, userId) => {
      if (socketId === socket.id) {
        onlineUsers.delete(userId);
        console.log(`User ${userId} disconnected`);
      }
    });
  });
});

// Start the server simply
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});