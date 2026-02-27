import 'package:barter_system/communities.dart';
import 'package:barter_system/history.dart';
import 'package:barter_system/home.dart';
import 'package:barter_system/login.dart';
import 'package:barter_system/reviews.dart';
import 'package:flutter/material.dart';
import 'package:barter_system/profile.dart';
import 'package:barter_system/skillpopup.dart';
import 'package:barter_system/studyroom.dart';
import 'package:barter_system/community.dart';
import 'package:barter_system/notification.dart';
import 'package:barter_system/chat.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  int _selectedIndex = 1;
  final List<Map<String, String>> chats = List.generate(10, (index) {
    return {
      'name': 'Name',
      'message': 'last message',
      'time': 'Time',
    };
  });

  final List<Widget> _pages = [
    MyHomePage(title: 'App name',),
    Chats(),
    SkillMatchApp(),
    Community(),
    StudyRoom(),
  ];

  void _onItemTapped(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFF7E4682),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'App Name',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 45),
                    ),
                  ),
                ),
              ],
            )),
            
            ListTile(
              leading: Icon(
                Icons.history,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              title: Text('History',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => History()));
              },
            ),
            Divider(color: Colors.white, thickness: 1),
            ListTile(
              leading: Icon(
                Icons.groups,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              title: Text(
                'Communities',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Communities()));
              },
            ),
            Divider(color: Colors.white, thickness: 1),
            ListTile(
              leading: Icon(
                Icons.reviews,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              title: Text(
                'Reviews',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Reviews()));
              },
            ),
            Divider(color: Colors.white, thickness: 1),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              title: Text(
                'Sign Out',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            ),
            Divider(color: Colors.white, thickness: 1),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chats',
          style: TextStyle(
              fontSize: 32,
              fontStyle: FontStyle.italic,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color(0xFF56195B),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
              icon: Icon(Icons.notifications)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              icon: Icon(Icons.person_rounded)),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Color(0xFF56195B)),
                filled: true,
                fillColor: Color(0xFFECC9EE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 10,
              children: const [
                Chip(label: Text("All")),
                Chip(label: Text("Unread")),
                Chip(label: Text("Groups")),
                Chip(label: Icon(Icons.add)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFECC9EE),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    chat['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chat['message']!),
                  trailing: Text(chat['time']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(name: chat['name']!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF56195B),
        selectedItemColor: const Color(0xFFECC9EE),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded), label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outlined), label: 'ADD'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded), label: 'Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'Study Room'),
        ],
      ),
    );
  }
}
