import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  String _selectedGender = '-';
  String _profileImage = '';
  File? _newProfileImageFile;

  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _debugAuth();
    _loadUserData();
  }

  void _debugAuth() {
    final user = _supabase.auth.currentUser;
    print('== Auth Debug ==');
    print('User ID: ${user?.id}');
  }

  Future<void> _loadUserData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        setState(() {
          _nameController.text = response['name'] ?? '';
          _emailController.text = response['email'] ?? '';
          _dobController.text = response['date_of_birth'] ?? '';
          _selectedGender = response['gender'] ?? '-';
          final profileImage = response['profile_image'];
          _profileImage = (profileImage != null && profileImage.toString().trim().isNotEmpty)
              ? profileImage
              : '';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfileImageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final fileExt = imageFile.path.split('.').last;
    final filePath = 'profile_images/${user.id}.$fileExt';

    try {
      await _supabase.storage.from('profile_images').upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(upsert: true),
      );
      return _supabase.storage.from('profile_images').getPublicUrl(filePath);
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveChanges() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    String updatedProfileImage = _profileImage;
    if (_newProfileImageFile != null) {
      final imageUrl = await _uploadProfileImage(_newProfileImageFile!);
      if (imageUrl != null) updatedProfileImage = imageUrl;
    }

    final updates = {
      'name': _nameController.text,
      'email': _emailController.text,
      'gender': _selectedGender,
      'profile_image': updatedProfileImage,
      'date_of_birth': _dobController.text.trim()
    };

    try {
      await _supabase.from('users').update(updates).eq('id', user.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dobController.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = picked.toIso8601String().split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final fieldColor = isDark ? const Color(0xFF1F1F1F) : Colors.grey[200];

    late ImageProvider imageWidget;
    if (_newProfileImageFile != null) {
      imageWidget = FileImage(_newProfileImageFile!);
    } else if (_profileImage.startsWith('http')) {
      imageWidget = NetworkImage(_profileImage);
    } else {
      imageWidget = const AssetImage('assets/profileImage.png');
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text("Edit Profile", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Stack(
              children: [
                CircleAvatar(radius: 50, backgroundImage: imageWidget),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: textColor),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            buildTextField(label: 'Full Name', controller: _nameController, textColor: textColor, fieldColor: fieldColor),
            const SizedBox(height: 20),
            buildTextField(label: 'Email', controller: _emailController, textColor: textColor, fieldColor: fieldColor),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: buildTextField(
                  label: 'Date of Birth',
                  controller: _dobController,
                  suffixIcon: Icons.calendar_today,
                  textColor: textColor,
                  fieldColor: fieldColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildDropdownGender(textColor, fieldColor),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3663FE),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _saveChanges,
                child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? suffixIcon,
    required Color textColor,
    required Color? fieldColor,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
        filled: true,
        fillColor: fieldColor,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: textColor.withOpacity(0.6)) : null,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget buildDropdownGender(Color textColor, Color? fieldColor) {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      dropdownColor: fieldColor,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
        filled: true,
        fillColor: fieldColor,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(Icons.arrow_drop_down, color: textColor),
      style: TextStyle(color: textColor),
      items: ['-', 'Male', 'Female'].map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value == '-' ? 'Select Gender' : value, style: TextStyle(color: textColor)),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedGender = newValue!;
        });
      },
    );
  }
}
