import 'package:barter_system/home.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot UI',
      debugShowCheckedModeBanner: false,
      home: ChatbotPage(),
    );
  }
}

// Chatbot Page
class ChatbotPage extends StatefulWidget {
  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void navigateToEmptyPage(String message) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: 'App name')),
    );
  }

  void handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add("You: $text");
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top row with back button and bot icon
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ), // reduced vertical padding
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 30),
                    onPressed: () {
                      navigateToEmptyPage("Back button clicked");
                    },
                  ),
                  SizedBox(width: 16),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF56195B),
                    child: Icon(Icons.android, size: 40, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Scrollable chat area
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bot welcome message
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF7E4682),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Hello! how can I help you?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // User chat messages with purple accent bubble and white text
                    ..._messages.map(
                      (msg) => Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ), // decreased vertical margin
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFA86D9F),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(msg, style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    // Buttons with reduced vertical spacing
                    buildOptionButton(
                      label: "Trending skills",
                      color: Color(0xFFA86D9F),
                      onTap: () {
                        navigateToEmptyPage("Trending skills clicked");
                      },
                    ),
                    buildOptionButton(
                      label: "Suggest me a skill",
                      color: Color(0xFF56195B),
                      onTap: () {
                        navigateToEmptyPage("Suggest me a skill clicked");
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Bottom input bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Color(0xFF7E4682),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      navigateToEmptyPage("+ button clicked");
                    },
                    child: Icon(Icons.add_circle_outline, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      onSubmitted:
                          (_) =>
                              handleSend(), // Send message on enter key press
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      navigateToEmptyPage("Mic clicked");
                    },
                    child: Icon(Icons.mic, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: handleSend,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable button widget with reduced vertical margin
  Widget buildOptionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 30,
        ), // reduced vertical margin
        padding: EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}

// Empty Page widget
class EmptyPage extends StatelessWidget {
  final String message;

  EmptyPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Empty Page"), backgroundColor: Colors.purple),
      body: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
