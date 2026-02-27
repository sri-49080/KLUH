import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barter_system/notification.dart'; // Assuming this path is correct for your Notifications widget

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Declare TextEditingControllers for each input field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController =
      TextEditingController(); // For Date of Birth
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _historyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Optional: You can pre-fill some fields here if you have initial data
    // For a non-Firebase version, you might load from shared preferences or similar
    // _usernameController.text = 'john_doe';
    // _nameController.text = 'John Doe';
  }

  // This function will be called when the Save button is clicked.
  // It currently only prints to console, as no backend integration is requested,
  // and the local save indication has been removed.
  void _saveProfileData() {
    print('Save button clicked!');
    print('Username: ${_usernameController.text}');
    print('Name: ${_nameController.text}');
    print('Date of Birth: ${_dobController.text}');
    print('Education: ${_educationController.text}');
    print('Skills: ${_skillsController.text}');
    print('History: ${_historyController.text}');

    // Removed: ScaffoldMessenger.of(context).showSnackBar(...)
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // In a real app, you'd likely save this image to a persistent storage
      // (e.g., local storage, cloud storage) and update a data model.
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _usernameController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _historyController.dispose();
    super.dispose();
  }

  // Helper method to build each profile input field
  Widget _buildProfileInputField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false, // To make Date of Birth field read-only
    VoidCallback? onTap, // For Date of Birth picker
    Color fillColor = const Color(0xFFC0A2C2), // Default light purple
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54, // Label text color
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(
                color: Color.fromARGB(
                    255, 147, 52, 134)), // Text color inside the field
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor, // Background color of the text field
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none, // No border line
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              // You can add a hintText if needed, e.g., hintText: 'Enter your $label',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF56195B), // AppBar background color
        iconTheme: const IconThemeData(color: Colors.white), // Icons on AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Notifications()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(Icons.person,
                            size: 70, color: Colors.white70)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Color(0xFF56195B), // Camera icon color
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Profile Input Fields ---
            _buildProfileInputField(
              label: 'Username',
              controller: _usernameController,
            ),
            _buildProfileInputField(
              label: 'Name',
              controller: _nameController,
            ),

            // Date of Birth field with date picker
            _buildProfileInputField(
              label: 'Date of Birth',
              controller: _dobController,
              readOnly: true, // Make it read-only
              fillColor: const Color.fromARGB(
                  255, 214, 164, 214), // Darker purple for DOB
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(
                              0xFF56195B), // Header background color of date picker
                          onPrimary:
                              Colors.white, // Header text color of date picker
                          onSurface:
                              Colors.black, // Body text color of date picker
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(
                                0xFF56195B), // Button text color in date picker
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  setState(() {
                    // Format the date as DD/MM/YYYY
                    _dobController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),

            // Ratings section (Static as per image, no input field)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ratings',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        color: index < 4
                            ? Colors.green[700]
                            : Colors.grey[400], // 4 filled stars, 1 empty
                        size: 24,
                      );
                    }),
                  ),
                ],
              ),
            ),

            _buildProfileInputField(
              label: 'Education',
              controller: _educationController,
            ),
            _buildProfileInputField(
              label: 'Skills',
              controller: _skillsController,
            ),
            _buildProfileInputField(
              label: 'History',
              controller: _historyController,
            ),

            const SizedBox(height: 40), // Add some space at the bottom

            // Save Button
            Center(
              // Center the button horizontally
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: _saveProfileData, // Call the local save function
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF56195B), // Button background color
                    foregroundColor: Colors.white, // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                    elevation: 5, // Add a little shadow
                    minimumSize: const Size(120, 45), // Make the button smaller
                  ),
                  child: const Text(
                    'Save', // Text is "Save"
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space after the button
          ],
        ),
      ),
    );
  }
}
