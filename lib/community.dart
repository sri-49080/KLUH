import 'package:flutter/material.dart';
import 'package:barter_system/communities.dart';
import 'package:barter_system/history.dart';
import 'package:barter_system/login.dart';
import 'package:barter_system/profile.dart';
import 'package:barter_system/chats.dart';
import 'package:barter_system/reviews.dart';
import 'package:barter_system/skillpopup.dart';
import 'package:barter_system/studyroom.dart';
import 'package:barter_system/home.dart';
import 'package:barter_system/notification.dart';
import 'package:image_picker/image_picker.dart'; // For image selection
import 'package:share_plus/share_plus.dart'; // For share functionality
import 'dart:io'; // For File operations (though we'll simulate URL for Post model)

class _CommunityState extends State<Community> {
  final TextEditingController _searchController = TextEditingController();
  List<Post> allPosts = [];
  List<Post> filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _initializePosts();
    filteredPosts = allPosts;
    _searchController.addListener(() {
      _filterPosts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _selectedIndex = 3;
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

  void _initializePosts() {
    allPosts = [
      Post(
        id: '1',
        username: 'john_dev',
        content:
            'Just finished learning Java collections! The HashMap implementation is fascinating. Working on a new project using Spring Boot.',
        imageUrl:
            'https://via.placeholder.com/600x400/4CAF50/FFFFFF?text=Java+Code',
        tags: ['java', 'programming', 'collections'],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 15,
        shares: 3,
        comments: [
          Comment(
            username: 'sarah_coder',
            content: 'Great post! HashMap is really powerful.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          Comment(
            username: 'mike_dev',
            content: 'Have you tried LinkedHashMap?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ],
      ),
      Post(
        id: '2',
        username: 'flutter_fan',
        content:
            'Building my first Flutter app! The widget system is amazing and so intuitive.',
        imageUrl:
            'https://via.placeholder.com/600x400/2196F3/FFFFFF?text=Flutter+App',
        tags: ['flutter', 'mobile', 'development'],
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        likes: 28,
        shares: 7,
        comments: [
          Comment(
            username: 'dart_master',
            content: 'Flutter is the future of mobile development!',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
      ),
      Post(
        id: '3',
        username: 'python_guru',
        content:
            'Data science with Python is incredible. Just completed my machine learning project using TensorFlow!',
        imageUrl:
            'https://via.placeholder.com/600x400/FF9800/FFFFFF?text=Python+ML',
        tags: ['python', 'datascience', 'machinelearning'],
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        likes: 42,
        shares: 12,
        comments: [
          Comment(
            username: 'data_analyst',
            content: 'Which libraries did you use?',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          Comment(
            username: 'ai_enthusiast',
            content: 'Pandas and NumPy are game changers!',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
        ],
      ),
      Post(
        id: '4',
        username: 'react_developer',
        content:
            'Learning React hooks has been a game changer. The useState and useEffect hooks make state management so much easier.',
        imageUrl:
            'https://via.placeholder.com/600x400/61DAFB/000000?text=React+JS',
        tags: ['react', 'javascript', 'frontend'],
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        likes: 35,
        shares: 8,
        comments: [
          Comment(
            username: 'js_ninja',
            content: 'React hooks are amazing for functional components!',
            timestamp: DateTime.now().subtract(const Duration(hours: 7)),
          ),
        ],
      ),
    ];
  }

  void _filterPosts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPosts = allPosts;
      } else {
        filteredPosts = allPosts.where((post) {
          return post.content.toLowerCase().contains(query.toLowerCase()) ||
              post.tags.any(
                  (tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
              post.username.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _navigateToCreatePost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostPage()),
    ).then((newPost) {
      if (newPost != null && newPost is Post) {
        setState(() {
          allPosts.insert(0, newPost);
          _filterPosts(_searchController.text);
        });
      }
    });
  }

  // Modified to open PhotoViewerPage with `initialShowComments` flag
  void _openPostViewer(Post post, {bool initialShowComments = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewerPage(
          post: post,
          initialShowComments: initialShowComments,
        ),
      ),
    ).then((_) {
      // Refresh the community feed when returning from PhotoViewerPage
      // to reflect any changes like new comments or likes/unlikes
      setState(() {
        _filterPosts(_searchController.text); // Re-filter to update counts
      });
    });
  }

  void _navigateToCreateCommunity() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCommunityPage()),
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
              title: Text(
                'History',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => History()));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Communities()));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Reviews()));
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }),
            Divider(color: Colors.white, thickness: 1),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'COMMUNITY',
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
      body: Column(
        children: [
          // Write a post / Create post trigger
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFECC9EE),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                onTap: _navigateToCreatePost,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'write a post',
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFF56195B),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          // Search Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller:
                  _searchController, // Linked to controller for filtering
              onChanged:
                  _filterPosts, // This TextField handles the actual filtering
              decoration: InputDecoration(
                hintText: 'Search posts... (e.g., "java", "flutter", "python")',
                prefixIcon: Icon(Icons.search,
                    color: const Color.fromARGB(255, 133, 56, 125)),
                filled: true,
                fillColor: Color(0xFFECC9EE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          // Posts List
          Expanded(
            child: filteredPosts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No posts found',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        Text(
                          'Try searching for "java", "flutter", or "python"',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1BEE7),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Account details header
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF56195B),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.person,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.username,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        _formatTimestamp(post.timestamp),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Post content text
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                post.content,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Post image (if available) - positioned below text
                            if (post.imageUrl != null)
                              GestureDetector(
                                onTap: () => _openPostViewer(post,
                                    initialShowComments:
                                        false), // Open viewer on image tap
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      post.imageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: Icon(Icons.broken_image,
                                                color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            // Action buttons
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.grey[300]!)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Like Button
                                  _buildActionButton(
                                    post.isLiked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_outlined,
                                    '${post.likes}',
                                    post.isLiked
                                        ? const Color(0xFF56195B)
                                        : Colors.grey[700]!,
                                    () {
                                      setState(() {
                                        if (post.isLiked) {
                                          post.likes--;
                                        } else {
                                          post.likes++;
                                        }
                                        post.isLiked = !post.isLiked;
                                      });
                                    },
                                  ),
                                  // Comment Button
                                  _buildActionButton(
                                    Icons.comment_outlined,
                                    '${post.comments.length}',
                                    Colors.grey[700]!,
                                    () {
                                      // Open viewer to show comments, with comments panel initially open
                                      _openPostViewer(post,
                                          initialShowComments: true);
                                    },
                                  ),
                                  // Share Button
                                  _buildActionButton(
                                    Icons.share_outlined,
                                    '${post.shares}', // Still show count, but do not increment
                                    Colors.grey[700]!,
                                    () {
                                      // Trigger native share sheet using share_plus package
                                      Share.share(
                                          'Check out this post: ${post.content}\n\n'
                                          '${post.imageUrl != null ? 'Image: ${post.imageUrl}\n' : ''}'
                                          '#${post.tags.join(' #')}');
                                      // Note: Share count is NOT incremented as per your request
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: _navigateToCreateCommunity, // New functionality
          elevation: 0,
          child: const Icon(
            Icons.add,
            size: 28,
          ),
        ),
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

  Widget _buildActionButton(
      IconData icon, String label, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: iconColor),
            if (label.isNotEmpty)
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: iconColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class Post {
  final String id;
  final String username;
  final String content;
  final String? imageUrl; // Can be null if no image is selected
  final List<String> tags;
  final DateTime timestamp;
  int likes;
  int shares;
  bool isLiked;
  List<Comment> comments; // This list needs to be mutable

  Post({
    required this.id,
    required this.username,
    required this.content,
    this.imageUrl,
    required this.tags,
    required this.timestamp,
    this.likes = 0,
    this.shares = 0,
    this.isLiked = false,
    required this.comments, // Ensure comments list is passed
  });
}

class Comment {
  final String username;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.username,
    required this.content,
    required this.timestamp,
  });
}

class PhotoViewerPage extends StatefulWidget {
  final Post post;
  final bool
      initialShowComments; // New: to control initial comments panel visibility

  const PhotoViewerPage({
    Key? key,
    required this.post,
    this.initialShowComments = false, // Default to false
  }) : super(key: key);

  @override
  _PhotoViewerPageState createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late bool showComments; // Changed to late to initialize in initState
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showComments =
        widget.initialShowComments; // Initialize with the passed flag
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        // Add new comment to the post's comments list
        widget.post.comments.add(
          Comment(
            username: 'You', // Assuming the current user is 'You'
            content: _commentController.text.trim(),
            timestamp: DateTime.now(),
          ),
        );
        _commentController.clear(); // Clear the input field
      });
      // In a real app, you might also send this comment to a backend server.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Swipe right to close comments, swipe left to open
          if (details.primaryVelocity! > 0) {
            // Swiped right
            if (showComments) {
              // Only change state if comments are currently open
              setState(() {
                showComments = false;
              });
            }
          } else if (details.primaryVelocity! < 0) {
            // Swiped left
            // Only show comments if there are existing comments OR if it's a new comment input.
            // Also, only change state if comments are currently closed.
            if (!showComments) {
              setState(() {
                showComments = true;
              });
            }
          }
        },
        child: Stack(
          children: [
            // Main post content (image or text)
            Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            widget.post.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: widget.post.imageUrl != null
                        ? Image.network(
                            widget.post.imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[900],
                                child: const Center(
                                  child: Icon(Icons.broken_image,
                                      color: Colors.grey, size: 64),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.post.content,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Only show text content if an image is present,
                      // otherwise the content is already displayed prominently above.
                      if (widget.post.imageUrl != null)
                        Text(
                          widget.post.content,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            // Comments panel (slides in from right)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut, // Added curve for smoother animation
              right: showComments ? 0 : -MediaQuery.of(context).size.width,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SafeArea(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!)),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                setState(() {
                                  showComments = false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'Comments',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.post.comments.length,
                        itemBuilder: (context, index) {
                          final comment = widget.post.comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF56195B),
                              child: Text(
                                comment.username[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              comment.username,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.content),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTimestamp(comment.timestamp),
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Add Comment Section
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border:
                            Border(top: BorderSide(color: Colors.grey[300]!)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              minLines: 1,
                              maxLines: 4,
                            ),
                          ),
                          const SizedBox(width: 8),
                          FloatingActionButton(
                            onPressed: _addComment,
                            mini: true,
                            backgroundColor: const Color(0xFF56195B),
                            child: const Icon(Icons.send,
                                color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  XFile? _selectedImage; // To hold the selected image file
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  void _createPost() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter some content for your post')),
      );
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim().toLowerCase())
        .where((tag) => tag.isNotEmpty)
        .toList();

    // For demonstration, if an image is selected, we'll use a generic placeholder URL.
    // In a real application, you would upload _selectedImage to a server
    // and get a real URL back to store in the Post object.
    final String? imageUrlForPost = _selectedImage != null
        ? 'https://via.placeholder.com/600x400/CCCCCC/FFFFFF?text=User+Selected+Image' // Placeholder URL
        : null;

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: 'You',
      content: _contentController.text.trim(),
      imageUrl: imageUrlForPost, // Use the simulated URL or null
      tags: tags,
      timestamp: DateTime.now(),
      comments: [],
    );

    Navigator.pop(context, newPost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: const Color(0xFF56195B),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _createPost,
            child: const Text(
              'POST',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s on your mind?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText:
                    'Share your thoughts, code snippets, or ask questions...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add an image (optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            // Image selection button
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Select Image from Gallery'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF56195B), // Text and icon color
                minimumSize:
                    const Size(double.infinity, 50), // Make button wider
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Image preview
            if (_selectedImage != null)
              Expanded(
                // Use Expanded to give the preview image flexible space
                child: Container(
                  height: 150, // This height will be a maximum, not strict
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_selectedImage!.path), // Use File for local image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Tags (optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                hintText: 'e.g., java, flutter, programming (comma separated)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                prefixIcon: const Icon(Icons.tag),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Placeholder for CreateCommunityPage

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({super.key});

  @override
  State<CreateCommunityPage> createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final tagsController = TextEditingController();

  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Community'),
        backgroundColor: const Color(0xFF56195B),
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Label for Icon
                      const Text(
                        'Add Icon of the Community',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Community Icon Picker
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : null,
                          child: _selectedImage == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.grey.shade700,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildGradientTextField(
                        controller: nameController,
                        hintText: 'Community Name',
                      ),
                      const SizedBox(height: 24),

                      _buildGradientTextField(
                        controller: bioController,
                        hintText: 'Community Bio',
                        maxLines: 6, // Increased size
                      ),
                      const SizedBox(height: 24),

                      _buildGradientTextField(
                        controller: tagsController,
                        hintText: 'Tags (comma separated)',
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Save Button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const Community(), // Your real page
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF56195B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Community',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Reusable styled text field widget
  Widget _buildGradientTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 209, 123, 213), Color(0xFF56195B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(0, 24, 3, 3),
        ),
      ),
    );
  }
}
