import 'package:barter_system/notification.dart';
import 'package:barter_system/popup.dart';
import 'package:barter_system/profile.dart';
import 'package:flutter/material.dart';
import 'notification_service.dart';

class SkillMatchApp extends StatelessWidget {
  const SkillMatchApp({super.key});
  @override
  Widget build(BuildContext context) {
    return HomeScreen(); 
  }
}


class HomeScreen extends StatelessWidget {
  final TextEditingController requireController = TextEditingController();
  final TextEditingController offerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
   appBar: AppBar(
        centerTitle: true,
        title: Text(
          'APP NAME',
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
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB575A1), Color(0xFF5D1A6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: requireController,
                decoration: InputDecoration(
                  hintText: 'Skill you require',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: offerController,
                decoration: InputDecoration(
                  hintText: 'Skill you offer',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5D1A6A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                  ),
                  onPressed: () async {
                    final String requiredSkill = requireController.text.trim();
                    final String offeredSkill = offerController.text.trim();
                    if (requiredSkill.isNotEmpty && offeredSkill.isNotEmpty) {
                      await NotificationService().showHeadsUp(
                        title: 'Skill match possible',
                        body: 'Offer: '+offeredSkill+' • Need: '+requiredSkill,
                      );
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileEditScreen()));
                  },
                  child: Text("NEXT",style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF5D1A6A),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Match"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: "Study Room"),
        ],
        currentIndex: 0,
        onTap: (index) {
          
        },
      ),
    );
  }
}
