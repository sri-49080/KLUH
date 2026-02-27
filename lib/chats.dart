import 'package:flutter/material.dart';
import 'chat.dart';
import 'new_chat_screen.dart';
import 'package:skillsocket/profile.dart';
import 'package:skillsocket/reviews.dart';
import 'package:skillsocket/notification.dart';
import 'package:skillsocket/history.dart';
import 'package:skillsocket/login.dart';
import 'package:skillsocket/services/chat_service.dart';
import 'package:skillsocket/services/user_service.dart'; // ✅ Added
import 'package:skillsocket/config/app_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'notification_helper.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> chats = [];
  bool _isLoading = true;
  String? currentUserId;
  late IO.Socket socket;

  // ✅ Added for profile image
  String? _profileImageUrl;

  // Animation for unread badge pulse
  late AnimationController _badgeController;
  late Animation<double> _badgeScale;
  late Animation<double> _badgeGlow;

  Map<String, int> _unreadCounts = {};
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    NotificationHelper.initialize();

    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _badgeScale = Tween<double>(begin: 0.85, end: 1.2).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeInOut),
    );
    _badgeGlow = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeInOut),
    );

    _initializeChats();
    _fetchProfileImage(); // ✅ same as MyHomePage
  }

  Future<void> _fetchProfileImage() async {
    try {
      final userData = await UserService.getUserProfile(); // ✅ Adjust if needed
      if (userData != null &&
          userData['profileImage'] != null &&
          userData['profileImage'].toString().isNotEmpty) {
        setState(() {
          _profileImageUrl = userData['profileImage'];
        });
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  Future<void> _initializeChats() async {
    print('🔄 Initializing chats...');
    
    // Test backend connectivity first
    final isConnected = await ChatService.testConnection();
    if (!isConnected) {
      print('❌ Backend connection failed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot connect to server. Please check your internet connection.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _initializeChats,
            ),
          ),
        );
      }
      return;
    }
    
    currentUserId = await ChatService.getCurrentUserId();
    print('👤 Current user ID: $currentUserId');
    
    if (currentUserId == null) {
      print('❌ No user ID found - user may not be logged in');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please log in to view chats'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Login',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        );
      }
      return;
    }
    
    await _loadChats();

    if (currentUserId != null) {
      _connectToSocket();
    }
  }

  void _connectToSocket() {
    try {
      print('🔌 Connecting to socket server: ${AppConfig.socketUrl}');
      socket = IO.io(
        AppConfig.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling']) // Add polling as fallback
            .setReconnectionAttempts(3)
            .setReconnectionDelay(1000)
            .setTimeout(5000)
            .build(),
      );

      socket.onConnect((_) {
        print('✅ Connected to socket server');
        if (currentUserId != null) {
          socket.emit("joinRoom", currentUserId);
          print('📡 Joined room for user: $currentUserId');
        }
      });

      socket.on("receiveMessage", (data) {
        print('📨 Received message: $data');
        if (mounted) {
          _updateChatWithNewMessage(data);
          if (data['from'] != null && data['from']['_id'] != currentUserId) {
            NotificationHelper.showNotification(
              'New Message from ${data['from']['name'] ?? 'Someone'}',
              data['content'] ?? '',
            );
          }
        }
      });

      socket.onError((error) {
        print("❌ Socket error: $error");
        // Don't show error message for every socket error, just log it
      });

      socket.onDisconnect((reason) {
        print("🔌 Disconnected from socket server: $reason");
        // Try to reconnect after a short delay
        if (mounted) {
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              socket.connect();
            }
          });
        }
      });

      socket.onConnectError((error) {
        print("❌ Socket connection error: $error");
        // Real-time messaging will not work, but app continues normally
        print("ℹ️ Continuing without real-time messaging");
      });

      socket.connect();
    } catch (e) {
      print("❌ Failed to initialize socket: $e");
      print("ℹ️ Continuing without real-time messaging");
    }
  }

  void _updateChatWithNewMessage(dynamic messageData) {
    setState(() {
      String partnerId;
      final isFromMe = messageData['from']['_id'] == currentUserId;
      if (isFromMe) {
        partnerId = messageData['to']['_id'];
      } else {
        partnerId = messageData['from']['_id'];
      }

      int chatIndex =
          chats.indexWhere((chat) => chat['participant']['_id'] == partnerId);

      if (chatIndex != -1) {
        chats[chatIndex]['lastMessage'] = {
          'content': messageData['content'],
          'createdAt': messageData['createdAt'],
          'from': messageData['from']['_id'],
          'seen': isFromMe ? true : (messageData['seen'] ?? false)
        };
        if (!isFromMe) {
          final current = _unreadCounts[partnerId] ?? 0;
          _unreadCounts[partnerId] = current + 1;
        }
        var updatedChat = chats.removeAt(chatIndex);
        chats.insert(0, updatedChat);
      } else {
        final partner = isFromMe ? messageData['to'] : messageData['from'];
        chats.insert(0, {
          '_id': '${currentUserId}_$partnerId',
          'participant': partner,
          'lastMessage': {
            'content': messageData['content'],
            'createdAt': messageData['createdAt'],
            'from': messageData['from']['_id'],
            'seen': isFromMe ? true : (messageData['seen'] ?? false)
          }
        });
        if (!isFromMe) {
          final current = _unreadCounts[partnerId] ?? 0;
          _unreadCounts[partnerId] = current + 1;
        }
      }
    });
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);
    try {
      print('🔄 Loading chats and unread counts...');
      final results = await Future.wait([
        ChatService.getUserChats(),
        ChatService.getUnreadCounts(),
      ]);
      final chatData = results[0] as List<Map<String, dynamic>>?;
      final unread = results[1] as Map<String, int>;
      
      print('📋 Chat data received: ${chatData?.length ?? 0} chats');
      print('🔢 Unread counts: $unread');
      
      if (mounted) {
        setState(() {
          chats = chatData ?? [];
          _unreadCounts = unread;
        });
      }
      
      if (chatData?.isEmpty ?? true) {
        print('ℹ️ No chats found - this is normal for new users');
      }
    } catch (e) {
      print('❌ Error loading chats: $e');
      if (mounted) {
        setState(() {
          chats = [];
          _unreadCounts = {};
        });
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load chats. Please check your internet connection.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadChats,
            ),
          ),
        );
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  String _formatLastMessageTime(String timestamp) {
    try {
      final messageTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(messageTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Now';
      }
    } catch (_) {
      return 'Recently';
    }
  }

  @override
  void dispose() {
    _badgeController.dispose();
    if (currentUserId != null) socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = chats.where((chat) {
      final participant = chat['participant'];
      final name = participant['name']?.toLowerCase() ?? '';
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFF123b53),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  'SkillSocket',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.white),
              title: Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const History()));
              },
            ),
            Divider(color: Colors.white),
            ListTile(
              leading: Icon(Icons.reviews, color: Colors.white),
              title: Text('Reviews', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Reviews()));
              },
            ),
            Divider(color: Colors.white),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('Sign Out', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'SkillSocket',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF123b53),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
              icon: const Icon(Icons.notifications)),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            icon: _profileImageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_profileImageUrl!),
                    radius: 14,
                  )
                : const Icon(Icons.person_rounded),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF123b53)),
            )
          : filteredChats.isEmpty
              ? const Center(
                  child: Text('No chats found', style: TextStyle(fontSize: 16)))
              : RefreshIndicator(
                  onRefresh: _loadChats,
                  child: ListView.separated(
                    itemCount: filteredChats.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final chat = filteredChats[index];
                      final participant = chat['participant'];
                      final lastMessage = chat['lastMessage'];
                      final unread = _unreadCounts[participant['_id']] ?? 0;
                      final isUnseen = unread > 0;

                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFB6E1F0),
                              backgroundImage: participant['profileImage'] !=
                                          null &&
                                      participant['profileImage'].isNotEmpty
                                  ? NetworkImage(participant['profileImage'])
                                  : null,
                              child: participant['profileImage'] == null ||
                                      participant['profileImage'].isEmpty
                                  ? Text(
                                      participant['name'][0].toUpperCase(),
                                      style: const TextStyle(
                                          color: Color(0xFF123b53),
                                          fontWeight: FontWeight.bold),
                                    )
                                  : null,
                            ),
                            if (isUnseen)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: ScaleTransition(
                                  scale: _badgeScale,
                                  child: AnimatedBuilder(
                                    animation: _badgeController,
                                    builder: (context, _) {
                                      final glow = _badgeGlow.value;
                                      return Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.green.withOpacity(0.6),
                                              blurRadius: glow,
                                              spreadRadius: glow / 4,
                                            ),
                                          ],
                                        ),
                                        constraints: const BoxConstraints(
                                            minWidth: 18, minHeight: 18),
                                        child: Center(
                                          child: Text(
                                            unread > 99
                                                ? '99+'
                                                : unread.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(participant['name'],
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(
                          lastMessage['content'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isUnseen ? Colors.green : Colors.black,
                            fontWeight:
                                isUnseen ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: Text(
                          _formatLastMessageTime(lastMessage['createdAt']),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        onTap: () async {
                          final partnerId = participant['_id'];
                          setState(() {
                            _unreadCounts[partnerId] = 0;
                          });
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chat(
                                chatId: chat['_id'],
                                recipientId: participant['_id'],
                                name: participant['name'],
                              ),
                            ),
                          );
                          await ChatService.markMessagesAsRead(partnerId);
                          await _loadChats();
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewChatScreen()));
        },
        backgroundColor: const Color(0xFF123b53),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
