import 'package:barter_system/home.dart';
import 'package:flutter/material.dart';

// Entry widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectCommunitiesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Model class for Community
class Community {
  final String name;
  final int members;

  Community({required this.name, required this.members});
}

// Main page for selecting communities
class SelectCommunitiesPage extends StatefulWidget {
  @override
  _SelectCommunitiesPageState createState() => _SelectCommunitiesPageState();
}

class _SelectCommunitiesPageState extends State<SelectCommunitiesPage> {
  final List<Community> communities = [
    Community(name: "Java", members: 456),
    Community(name: "Python", members: 789),
    Community(name: "App Development", members: 300),
    Community(name: "Devops", members: 600),
    Community(name: "Machine learning", members: 212),
    Community(name: "Full stack", members: 512),
  ];

  final Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select your communities',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 4, 78),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD6A4A4), Color(0xFF5C1A82)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Adjusted SizedBox height to give more vertical space
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Select 2 or more Communities you'd like to join",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10, // Decreased vertical spacing
                crossAxisSpacing: 10, // Decreased horizontal spacing
                padding: const EdgeInsets.all(10), // Adjusted padding
                children: List.generate(communities.length, (index) {
                  final community = communities[index];
                  final isSelected = selectedIndexes.contains(index);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedIndexes.remove(index);
                        } else {
                          selectedIndexes.add(index);
                        }
                      });
                    },
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              // Reduced circle size to fit all items without scrolling
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                border: isSelected
                                    ? Border.all(
                                        color: Colors.green,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Positioned(
                                top: 4,
                                right: 4,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          community.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "${community.members} members",
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("Selected communities: $selectedIndexes");
                      // Navigate to MyHomePage on next
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  title: 'App name',
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 67, 4, 78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child:
                          Text("SKIP", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  title: 'App name',
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 67, 4, 78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child:
                          Text("NEXT", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// New EmptyPage widget (kept for completeness if needed elsewhere, though not navigated to directly now)
class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empty Page', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 67, 4, 78),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 170, 45, 192),
              Color.fromARGB(255, 120, 20, 150),
            ],
          ),
        ),
        child: const Center(
          child: Text(
            'This is an empty page!',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
