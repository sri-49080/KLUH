import 'package:flutter/material.dart';

class Communities extends StatefulWidget {
  const Communities({super.key});

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  // Sample data with joined status
  final List<Map<String, dynamic>> joinedCommunities = [
    {
      'name': 'FlutterDev',
      'description': 'Discuss and share Flutter development content.',
      'members': '24.2k',
      'joined': true,
    },
    {
      'name': 'AI',
      'description': 'Talk about AI, ML, and the future of technology.',
      'members': '100k',
      'joined': true,
    },
    {
      'name': 'Design',
      'description': 'All things design — UI, UX, and graphic.',
      'members': '58.4k',
      'joined': true,
    },
  ];

  void toggleJoinStatus(int index) {
    setState(() {
      joinedCommunities[index]['joined'] = !joinedCommunities[index]['joined'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Communities',
          style: TextStyle(
            fontSize: 32,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF56195B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: joinedCommunities.length,
        itemBuilder: (context, index) {
          final community = joinedCommunities[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Community Icon
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF56195B),
                  child: Icon(Icons.people_alt, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 12),
                // Community info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        community['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${community['members']} members',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Join/Unjoin Button
                TextButton(
                  onPressed: () {
                    if (community['joined']) {
                      // Show confirmation dialog before unjoining
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Unjoin'),
                          content: Text(
                              'Are you sure you want to unjoin "${community['name']}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), // Cancel
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                toggleJoinStatus(index); // Unjoin
                                Navigator.pop(context); // Close dialog
                              },
                              child: const Text('Unjoin'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      toggleJoinStatus(index); // Directly join
                    }
                  },
                  child: Text(
                    community['joined'] ? "Joined" : "Join",
                    style: TextStyle(
                      color:
                          community['joined'] ? Color(0xFF56195B) : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
