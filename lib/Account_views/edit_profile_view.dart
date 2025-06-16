import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eeve_app/Custom_Widget_/Custom_button.dart';
import 'package:get/get.dart';
import 'package:eeve_app/controllers/profile_controller.dart'; 
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
  bool _isLoading = false;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    final user = _supabase.auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (response != null && mounted) {
        setState(() {
          _nameController.text = response['name'] ?? '';
          _emailController.text = response['email'] ?? '';
          _dobController.text = response['date_of_birth'] ?? '';
          _selectedGender = response['gender'] ?? '-';
          _profileImage = response['profile_image'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
    });

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _newProfileImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Image Picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في اختيار الصورة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final fileExt = imageFile.path.split('.').last;
    final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = 'profile-images/$fileName';

    try {
      await _supabase.storage
          .from('profile-images')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );

      final url = _supabase.storage
          .from('profile-images')
          .getPublicUrl(filePath);

      return url;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> _saveChanges() async {
    if (_isLoading || _isUploadingImage) return;

    final user = _supabase.auth.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(),
    );

    try {
      String imageUrl = _profileImage;
      if (_newProfileImageFile != null) {
        setState(() {
          _isUploadingImage = true;
        });

        final uploadedUrl = await _uploadProfileImage(_newProfileImageFile!);
        setState(() {
          _isUploadingImage = false;
        });

        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;

          final profileController = Get.find<ProfileController>();
          profileController.updateProfileImage(imageUrl);
        } else {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('فشل رفع الصورة'),
                backgroundColor: Colors.red,
              ),
            );
          }
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

      await _supabase.from('users').update(updates).eq('id', user.id);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ التغييرات بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Get.back(result: true);
      }
    } catch (e) {
      print('Save error: $e');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الحفظ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUploadingImage = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dobController.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _dobController.text = picked.toIso8601String().split('T').first;
      });
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
      final imageUrl = _profileImage.contains('?')
          ? '$_profileImage&t=${DateTime.now().millisecondsSinceEpoch}'
          : '$_profileImage?t=${DateTime.now().millisecondsSinceEpoch}';
      imageWidget = NetworkImage(imageUrl);
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: imageWidget,
                        key: ValueKey(_newProfileImageFile?.path ?? _profileImage),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: GestureDetector(
                          onTap: _isPicking ? null : _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
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
                            child: _isPicking
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.blue,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
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
                      child: buildTextField(
                        'Date of Birth',
                        _dobController,
                        textColor,
                        fieldColor,
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildGenderDropdown(textColor, fieldColor),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: _isUploadingImage
                        ? 'Uploading...'
                        : (_isLoading ? 'Saving...' : 'Save Changes'),
                    onPressed: (_isUploadingImage || _isLoading)
                        ? null
                        : _saveChanges,
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller,
    Color textColor,
    Color? fieldColor, {
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
        filled: true,
        fillColor: fieldColor,
        suffixIcon:
            icon != null ? Icon(icon, color: textColor.withOpacity(0.6)) : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
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
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: textColor),
      style: TextStyle(color: textColor),
      items: ['-', 'Male', 'Female'].map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value == '-' ? 'Select Gender' : value,
            style: TextStyle(color: textColor),
          ),
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
