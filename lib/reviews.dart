import 'package:flutter/material.dart';

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> posts = [
      {
        "user": "Sara",
        "date": "2 days ago",
        "title": "Best app for daily tasks!",
        "body":
            "I've used it for 2 weeks now, and my productivity has improved a lot.",
        "likes": "320",
        "dislikes": "20",
        "comments": "18",
        "shares": "24",
        "color": Color(0xFFECC9EE),
        "rating": 4,
      },
      {
        "user": "Rahul",
        "date": "4 days ago",
        "title": "Good features and easy UI",
        "body": "I like the clean design. Would love dark mode though!",
        "likes": "290",
        "dislikes": "2",
        "comments": "25",
        "shares": "30",
        "color": Color(0xFFA86D9F),
        "rating": 3,
      },
      {
        "user": "Meera",
        "date": "1 week ago",
        "title": "Decent but needs work",
        "body": "Crashes sometimes. Please fix login issues on Android 13.",
        "likes": "150",
        "dislikes": "21",
        "comments": "12",
        "shares": "10",
        "color": Color(0xFF7E4682),
        "rating": 5,
      },
      {
        "user": "Sara",
        "date": "2 days ago",
        "title": "Best app for daily tasks!",
        "body":
            "I've used it for 2 weeks now, and my productivity has improved a lot.",
        "likes": "320",
        "dislikes": "20",
        "comments": "18",
        "shares": "24",
        "color": Color(0xFFECC9EE),
        "rating": 4,
      },
      {
        "user": "Rahul",
        "date": "4 days ago",
        "title": "Good features and easy UI",
        "body": "I like the clean design. Would love dark mode though!",
        "likes": "290",
        "dislikes": "2",
        "comments": "25",
        "shares": "30",
        "color": Color(0xFFA86D9F),
        "rating": 3,
      },
      {
        "user": "Meera",
        "date": "1 week ago",
        "title": "Decent but needs work",
        "body": "Crashes sometimes. Please fix login issues on Android 13.",
        "likes": "150",
        "dislikes": "21",
        "comments": "12",
        "shares": "10",
        "color": Color(0xFF7E4682),
        "rating": 5,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reviews',
          style: TextStyle(
            fontSize: 32,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF56195B),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: post['color'],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person,
                                  size: 16, color: Colors.black), // logo/icon
                            ),
                            SizedBox(width: 8),
                            Text(
                              post['user'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(width: 4),
                            Row(
                              children: List.generate(
                                post['rating'],
                                (index) => Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.yellow[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        post['date'],
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    post['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    post['body'],
                    style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(221, 255, 255, 255)),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.thumb_up_alt_outlined,
                            size: 18,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        SizedBox(width: 6),
                        Text(post['likes']),
                      ]),
                      Row(children: [
                        Icon(Icons.thumb_down_alt_outlined,
                            size: 18,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        SizedBox(width: 6),
                        Text(post['dislikes']),
                      ]),
                      Row(children: [
                        Icon(Icons.comment_outlined,
                            size: 18,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        SizedBox(width: 6),
                        Text(post['comments']),
                      ]),
                      Row(children: [
                        Icon(Icons.share_outlined,
                            size: 18,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                        SizedBox(width: 6),
                        Text(post['shares']),
                      ]),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
