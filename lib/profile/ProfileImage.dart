import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {

  final String baseUrl = 'http://192.168.35.127:8000/storage';

  final String? imageUrl;

  const ProfileImage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person, size: 50, color: Colors.white),
      );
    }

    ImageProvider imageProvider;

    if (imageUrl!.startsWith('/')) {

      imageProvider = FileImage(File(imageUrl!));
    } else if (!imageUrl!.startsWith('http')) {

      imageProvider = NetworkImage(Uri.encodeFull('$baseUrl/$imageUrl'));
    } else {

      imageProvider = NetworkImage(Uri.encodeFull(imageUrl!));
    }

    return CircleAvatar(
      radius: 65,
      backgroundImage: imageProvider,
      backgroundColor: Colors.grey[300],
    );
  }
}