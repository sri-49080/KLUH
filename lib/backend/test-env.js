const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config();

console.log('🔍 Environment Variables Check:');
console.log('PORT:', process.env.PORT || 'Not set (will use 3000)');
console.log('MONGODB_URI:', process.env.MONGODB_URI ? 'Set ✅' : 'Not set ❌');
console.log('JWT_SECRET:', process.env.JWT_SECRET ? 'Set ✅' : 'Not set ❌');
console.log('GEMINI_API_KEY:', process.env.GEMINI_API_KEY ? 'Set ✅' : 'Not set ❌');
console.log('FIREBASE_PROJECT_ID:', process.env.FIREBASE_PROJECT_ID ? 'Set ✅' : 'Not set ❌');
console.log('CLOUDINARY_CLOUD_NAME:', process.env.CLOUDINARY_CLOUD_NAME ? 'Set ✅' : 'Not set ❌');

if (!process.env.MONGODB_URI) {
  console.error('❌ MONGODB_URI is required but not set');
  process.exit(1);
}

if (!process.env.JWT_SECRET) {
  console.error('❌ JWT_SECRET is required but not set');
  process.exit(1);
}

// Test MongoDB connection
mongoose.connect(process.env.MONGODB_URI, {
  serverSelectionTimeoutMS: 5000,
})
  .then(() => {
    console.log('✅ MongoDB connection test successful');
    console.log('📊 Database name:', mongoose.connection.name);
    process.exit(0);
  })
  .catch(err => {
    console.error('❌ MongoDB connection test failed:', err.message);
    process.exit(1);
  });