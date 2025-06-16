import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eeve_app/Custom_Widget_/Custom_button.dart'; // ✅ استيراد زرنا المخصص

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
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
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
        _profileImage = response['profile_image'] ?? '';
      });
    }
  }

  Future<void> _pickImage() async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _newProfileImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Image Picker error: $e');
    } finally {
      _isPicking = false;
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final fileExt = imageFile.path.split('.').last;
    final filePath = 'profile-images/${user.id}.$fileExt';

    try {
      await _supabase.storage.from('profile-images').upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(upsert: true),
      );
      final url = _supabase.storage.from('profile-images').getPublicUrl(filePath);
      return url;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> _saveChanges() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    String imageUrl = _profileImage;

    if (_newProfileImageFile != null) {
      final uploadedUrl = await _uploadProfileImage(_newProfileImageFile!);
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل رفع الصورة'), backgroundColor: Colors.red),
        );
        return;
      }
    }

    final updates = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'gender': _selectedGender,
      'date_of_birth': _dobController.text.trim(),
      'profile_image': imageUrl,
    };

    try {
      await _supabase.from('users').update(updates).eq('id', user.id);
      await _loadUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التغييرات بنجاح'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في الحفظ: $e'), backgroundColor: Colors.red),
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
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: textColor)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: imageWidget,
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.edit, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            buildTextField('Full Name', _nameController, textColor, fieldColor),
            const SizedBox(height: 20),
            buildTextField('Email', _emailController, textColor, fieldColor),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: buildTextField('Date of Birth', _dobController, textColor, fieldColor, icon: Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 20),
            buildGenderDropdown(textColor, fieldColor),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Save Changes',
              onPressed: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, Color textColor, Color? fieldColor, {IconData? icon}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
        filled: true,
        fillColor: fieldColor,
        suffixIcon: icon != null ? Icon(icon, color: textColor.withOpacity(0.6)) : null,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget buildGenderDropdown(Color textColor, Color? fieldColor) {
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
      onChanged: (value) {
        setState(() {
          _selectedGender = value!;
        });
      },
    );
  }
}
