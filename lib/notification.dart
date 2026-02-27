import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Map<String, List<Map<String, dynamic>>> notifications = {
    "Today": [
      {
        "type": "match",
        "user": "Aanya",
        "action": "You got a match!",
        "time": "Just now",
        "icon": Icons.favorite_border,
        "accepted": false, // Added accepted flag
      },
      {
        "type": "normal",
        "user": "John",
        "action": "liked your post",
        "time": "2h ago",
        "icon": Icons.thumb_up_alt_outlined,
        "showThumbnail": true
      },
    ],
  };

  void _showOverlayMessage(String message) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        left: MediaQuery.of(context).size.width * 0.2,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _markAccepted(String section, int index) {
    setState(() {
      notifications[section]?[index]["accepted"] = true;
    });
    _showOverlayMessage("You have accepted the request");
  }

  void _removeNotification(String section, int index) {
    setState(() {
      notifications[section]?.removeAt(index);
      if (notifications[section]?.isEmpty ?? false) {
        notifications.remove(section);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 32,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF56195B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: notifications.entries.map((entry) {
          String section = entry.key;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  section,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ...entry.value.asMap().entries.map((notifEntry) {
                int index = notifEntry.key;
                Map<String, dynamic> notif = notifEntry.value;

                if (notif["type"] == "match") {
                  bool isAccepted = notif["accepted"] ?? false;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFF56195B),
                            child: Icon(notif["icon"], color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${notif["action"]} with ${notif["user"]}!",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif["time"],
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                isAccepted
                                    ? Row(
                                        children: const [
                                          Icon(Icons.check_circle, color: Colors.green),
                                          SizedBox(width: 6),
                                          Text(
                                            "Accepted",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              _markAccepted(section, index);
                                            },
                                            icon: const Icon(Icons.check),
                                            label: const Text("Accept"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          OutlinedButton.icon(
                                            onPressed: () {
                                              _removeNotification(section, index);
                                            },
                                            icon: const Icon(Icons.close),
                                            label: const Text("Decline"),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFF56195B),
                          child: Icon(notif["icon"], color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: notif["user"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: ' ${notif["action"]}',
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                softWrap: true,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif["time"] ?? '',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        if (notif["showThumbnail"] == true)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.image, color: Colors.black54),
                            ),
                          ),
                      ],
                    ),
                  );
                }
              }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }
}
