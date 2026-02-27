import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool isExpanded = false;
  final _formKey = GlobalKey<FormState>();

  String name = "Alara";
  String skillsOffered = "Flutter, Dart";
  String skillsRequired = "Firebase, Backend";
  String ratings = "⭐⭐⭐⭐☆";
  String education = "B.Tech";
  String location = "India";
  String profession = "Student";

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Widget _buildEditableField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
          TextFormField(
            initialValue: initialValue,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
            validator: isRequired
                ? (val) => val == null || val.trim().isEmpty ? '$label is required' : null
                : null,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
    
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text("Match your skill!!",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            ),
            Column(
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C1A82),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(_image!,
                                  height: 200, width: double.infinity, fit: BoxFit.cover),
                            )
                          : const Text(
                              "Photo",
                              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 190,
              left: 20,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isExpanded ? 530 : 400,
                padding: const EdgeInsets.only(top: 60),
                decoration: BoxDecoration(
                  color: const Color(0xFFB276B2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        _buildEditableField(
                            label: "Name",
                            initialValue: name,
                            isRequired: true,
                            onChanged: (val) => setState(() => name = val)),
                        _buildEditableField(
                            label: "Skills Offered",
                            initialValue: skillsOffered,
                            isRequired: true,
                            onChanged: (val) => setState(() => skillsOffered = val)),
                        _buildEditableField(
                            label: "Skills Required",
                            initialValue: skillsRequired,
                            isRequired: true,
                            onChanged: (val) => setState(() => skillsRequired = val)),
                        _buildEditableField(
                            label: "Ratings",
                            initialValue: ratings,
                            onChanged: (val) => setState(() => ratings = val)),
                        if (isExpanded) ...[
                          _buildEditableField(
                              label: "Education",
                              initialValue: education,
                              onChanged: (val) => setState(() => education = val)),
                          _buildEditableField(
                              label: "Location",
                              initialValue: location,
                              isRequired: true,
                              onChanged: (val) => setState(() => location = val)),
                          _buildEditableField(
                              label: "Profession",
                              initialValue: profession,
                              onChanged: (val) => setState(() => profession = val)),
                        ],
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _saveForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          ),
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 40,
              right: 40,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4CCE5),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/avatar.png') as ImageProvider,
                      radius: 18,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const Text("session", style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    const Spacer(),
                    const Text("Mon–Fri", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: 40,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () => setState(() => isExpanded = !isExpanded),
                child: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: Colors.black),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
