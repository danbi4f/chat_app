import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageFile;
  pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      preferredCameraDevice: CameraDevice.front,
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImageFile = File(pickedImage.path);

      widget.onPickImage(pickedImageFile!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          maxRadius: 60,
          backgroundColor: Colors.grey,
          foregroundImage:
              pickedImageFile != null ? FileImage(pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: pickImage,
          icon: const Icon(Icons.image),
          label: const Text('add image'),
        ),
      ],
    );
  }
}
