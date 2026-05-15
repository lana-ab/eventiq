import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/profile/profileController.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController controller = Get.find();

  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = controller.profile.value;
    _phoneController.text = profile?.phone ?? '';
    _birthDateController.text = profile?.birthDate ?? '';
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  ImageProvider<Object>? _buildImageProvider(String? path) {
    if (_imageFile != null) return FileImage(_imageFile!);
    if (path == null || path.isEmpty) return null;
    final uri = Uri.parse(path);
    if (uri.isAbsolute) return NetworkImage(path);
    if (path.startsWith('/')) return FileImage(File(path));
    return null;
  }

  void _saveProfile() async {
    controller.isLoading.value = true;

    final success = await controller.updateInfo(
      phone: _phoneController.text,
      birthDate: _birthDateController.text,
      imageFile: _imageFile,
    );

    controller.isLoading.value = false;

    if (success) {
      Get.back();
    } else {
      Get.snackbar('خطأ', 'حدث خطأ أثناء حفظ البيانات');
    }
  }
  @override
  Widget build(BuildContext context) {
    final currentImg = controller.profile.value?.img;
    return Scaffold(
        body: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
        colors: [Color(0xFFEDEBFA), Color(0xFFBCAEF3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
    ),
    child: SafeArea(
    child: SingleChildScrollView(
    child: ConstrainedBox(
    constraints: BoxConstraints(
    minHeight: MediaQuery.of(context).size.height,
    ),
    child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => Get.back(),
    ),
    const Text(
    'Edit Information',
    style: TextStyle(
    fontSize: 18,
    color: Color(0xFF4A3C9A),
    fontWeight:FontWeight.bold,
    ),
    ),
    const SizedBox(width: 48),
    ],
    ),

    const SizedBox(height: 16),
    Stack(
    alignment: Alignment.center,
    children: [
    CircleAvatar(
    radius: 70,
    backgroundColor: Colors.grey[300],
    backgroundImage: _buildImageProvider(currentImg),
    child: (_imageFile == null &&
    (currentImg == null || currentImg.isEmpty))
    ? const Icon(Icons.person, size: 60, color: Colors.white)
        : null,
    ),
    Positioned(
    bottom: 0,
    left: 0,
    child: GestureDetector(
    onTap: _pickImage,
    child: Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
    color: Color(0xFF4A3C9A),
    shape: BoxShape.circle,
    ),
    child: const Icon(Icons.camera_alt,
    size: 20, color: Colors.white),
    ),
    ),
    ),
    ],
    ),

    const SizedBox(height: 24),

    Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
    BoxShadow(
    color: Colors.black12,
    blurRadius: 8,
    offset: Offset(0, 2),
    )
    ],
    ),
    child: Column(
    children: [
    TextField(
    controller: _phoneController,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
    prefixIcon: const Icon(Icons.phone),
    labelText: 'phone number',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    ),
    ),
    ),
      const SizedBox(height: 16),
      TextField(
        controller: _birthDateController,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.cake),
          labelText: 'birth date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            // هنا نحفظ التاريخ مباشرة بدون وقت
            // مثال: controller.setDate(pickedDate);
          }
        },

      ),
      const SizedBox(height: 32),
      Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          backgroundColor: Color(0xFF4A3C9A),
        ),
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Save', style: TextStyle(fontSize: 18,color:Colors.white)),
      )
      ),
    ],
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ),
        ),
    );

  }
}