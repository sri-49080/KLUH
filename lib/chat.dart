import 'package:flutter/material.dart';
import 'notification_service.dart';

class Chat extends StatefulWidget {
  final String name;

  const Chat({super.key, required this.name});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _controller.text.trim(),
        'isMe':
            true, // You can toggle this if you want two-way chat for testing
        'time': TimeOfDay.now().format(context)
      });
      _controller.clear();
    });

    // Simulate incoming reply after a short delay to demonstrate notification
    Future.delayed(const Duration(seconds: 1), () async {
      setState(() {
        _messages.add({
          'text': 'New message from \'${widget.name}\'',
          'isMe': false,
          'time': TimeOfDay.now().format(context)
        });
      });
      await NotificationService().showHeadsUp(
        title: widget.name,
        body: 'New message',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF56195B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFECC9EE),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              widget.name,
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color:
                const Color(0xFF2E1A35), // Dark theme color like in screenshot
            onSelected: (value) {
              // Handle menu option selection
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: $value')),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view_contact',
                child:
                    Text('View contact', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'search',
                child: Text('Search', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'media_links_docs',
                child: Text('Media, links, and docs',
                    style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'mute_notifications',
                child: Text('Mute notifications',
                    style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'more',
                child: Text('More', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: msg['isMe']
                          ? const Color(0xFF7E4682)
                          : const Color(0xFFECC9EE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg['text'],
                          style: TextStyle(
                              color:
                                  msg['isMe'] ? Colors.white : Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(
                              color:
                                  msg['isMe'] ? Colors.white70 : Colors.black54,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: const Color(0xFF56195B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Message",
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.white),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
