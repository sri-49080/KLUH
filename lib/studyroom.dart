import 'package:flutter/material.dart';
import 'package:barter_system/notification.dart';
import 'package:barter_system/chatbot.dart';
import 'package:barter_system/profile.dart';
import 'package:barter_system/home.dart';
import 'package:barter_system/chats.dart';
import 'package:barter_system/reviews.dart';
import 'package:barter_system/communities.dart';
import 'package:barter_system/history.dart';
import 'package:barter_system/login.dart';
import 'community.dart';
import 'skillpopup.dart';

class StudyRoom extends StatefulWidget {
  @override
  _StudyRoomState createState() => _StudyRoomState();
}

class _StudyRoomState extends State<StudyRoom> {
  List<String> roomNames = ["Focus Room", "Deep Work", "Pomodoro Group"];
  String searchQuery = "";

  int _selectedIndex = 4;
  final List<Widget> _pages = [
    MyHomePage(
      title: 'App name',
    ),
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
    List<String> filteredRooms = roomNames
        .where((room) => room.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Study Room',
          style: TextStyle(
              fontSize: 32,
              fontStyle: FontStyle.italic,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color(0xFF56195B),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Join a room",
                filled: true,
                fillColor: const Color(0xFFD3A7E0),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: const ListTile(
                leading:
                    Icon(Icons.headphones, size: 40, color: Color(0xFF4B014B)),
                title: Text("StudyBuddy",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Make friends to study with"),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRooms.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3A7E0),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(filteredRooms[index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const Text("No. of participants"),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4B014B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text("Join",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              _showCreateDialog();
            },
            label: const Text("Create",style: TextStyle(color: Colors.white),),
            icon: const Icon(Icons.add,color: Colors.white,),
            backgroundColor: const Color(0xFF4B014B),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatbotPage()));
        },
        child: Icon(Icons.android),)
        ]
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

  void _showCreateDialog() {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Room"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "Enter room name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  setState(() {
                    roomNames.add(_controller.text.trim());
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }
}
