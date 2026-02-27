import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class UserService {
  static String get baseUrl => AppConfig.baseUrl; // Use baseUrl instead of userUrl

  // Helpers used across the app
  static Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Optionally expose token if needed elsewhere
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Internal headers
  static Future<Map<String, String>> _getHeaders() async {
    final token = await getAuthToken();
    print('🔑 UserService - Retrieved token: ${token != null ? 'Token exists' : 'No token'}');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get current user's profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final headers = await _getHeaders();
      final url = '$baseUrl/user/profile';
      print('🔄 Making GET request to: $url');
      print('📋 With headers: $headers');
      
      final res = await http.get(Uri.parse(url), headers: headers);
      
      print('📡 Get user profile response status: ${res.statusCode}');
      print('📄 Get user profile response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        print('✅ Successfully loaded user profile');
        return data['user'];
      } else if (res.statusCode == 401) {
        print('❌ Unauthorized - token may be expired');
        return null;
      } else {
        print('❌ Get user profile error: ${res.statusCode} - ${res.body}');
        return null;
      }
    } catch (e) {
      print('❌ Get user profile exception: $e');
      return null;
    }
  }

  // Get user profile by ID
  static Future<Map<String, dynamic>?> getUserProfileById(String userId) async {
    try {
      final headers = await _getHeaders();
      final url = '$baseUrl/user/profile/$userId';
      print('🔄 Making GET request to: $url');
      print('📋 With headers: $headers');
      
      final res = await http.get(Uri.parse(url), headers: headers);
      
      print('📡 Get user profile by ID response status: ${res.statusCode}');
      print('📄 Get user profile by ID response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        print('✅ Successfully loaded user profile by ID');
        return data['user'];
      } else if (res.statusCode == 404) {
        print('❌ User not found for ID: $userId');
        return null;
      } else {
        print('❌ Get user profile by ID error: ${res.statusCode} - ${res.body}');
        return null;
      }
    } catch (e) {
      print('❌ Get user profile by ID exception: $e');
      return null;
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>?> updateUserProfile({
    String? name,
    String? phone,
    String? bio,
    String? location,
    String? dateOfBirth,
    List<String>? skills,
    String? profileImage,
    String? education,
    String? profession,
    String? currentlyWorking,
    List<String>? skillsRequired,
    List<String>? skillsOffered,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (bio != null) body['bio'] = bio;
      if (location != null) body['location'] = location;
      if (dateOfBirth != null) body['dateOfBirth'] = dateOfBirth;
      if (skills != null) body['skills'] = skills;
      if (profileImage != null) body['profileImage'] = profileImage;
      if (education != null) body['education'] = education;
      if (profession != null) body['profession'] = profession;
      if (currentlyWorking != null) body['currentlyWorking'] = currentlyWorking;
      if (skillsRequired != null) body['skillsRequired'] = skillsRequired;
      if (skillsOffered != null) body['skillsOffered'] = skillsOffered;

      final url = '$baseUrl/user/profile';
      print('🔄 Making PUT request to: $url');
      print('📋 With body: $body');

      final res = await http.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      
      print('📡 Update user profile response status: ${res.statusCode}');
      print('📄 Update user profile response body: ${res.body}');
      
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        print('✅ Successfully updated user profile');
        return data['user'];
      } else {
        print('❌ Update user profile error: ${res.statusCode} - ${res.body}');
        return null;
      }
    } catch (e) {
      print('❌ Update user profile exception: $e');
      return null;
    }
  }

  // Upload user logo (profile image)
  static Future<String?> uploadUserLogo(File logoFile) async {
    try {
      final headers = await _getHeaders();
      final url = '$baseUrl/user/upload-logo';
      print('🔄 Making POST (multipart) request to: $url');
      
      final request = http.MultipartRequest('POST', Uri.parse(url));
      
      // Attach auth header if present
      if (headers['Authorization'] != null) {
        request.headers['Authorization'] = headers['Authorization']!;
      }
      request.files.add(
        await http.MultipartFile.fromPath('logo', logoFile.path),
      );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      
      print('📡 Upload logo response status: ${response.statusCode}');
      print('📄 Upload logo response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Successfully uploaded logo');
        return data['logoUrl'] as String?;
      } else {
        print('❌ Upload logo error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Upload logo exception: $e');
      return null;
    }
  }

  // Add a review via user service (compat with existing calls)
  static Future<Map<String, dynamic>?> addReview({
    required String userId,
    required double rating,
    required String title,
    required String comment,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'revieweeId': userId,
        'rating': rating,
        'title': title,
        'comment': comment,
      };
      
      final url = '$baseUrl/reviews/add';
      print('🔄 Making POST request to: $url');
      print('📋 With body: $body');
      
      final res = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      
      print('📡 Add review response status: ${res.statusCode}');
      print('📄 Add review response body: ${res.body}');
      
      if (res.statusCode == 201) {
        print('✅ Successfully added review');
        return json.decode(res.body);
      } else {
        print('❌ Add review error: ${res.statusCode} - ${res.body}');
        return null;
      }
    } catch (e) {
      print('❌ Add review exception: $e');
      return null;
    }
  }
}
