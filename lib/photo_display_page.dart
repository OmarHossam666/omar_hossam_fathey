import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoDisplayPage extends StatelessWidget
{
  const PhotoDisplayPage({super.key , required this.imageUrl , required this.fileName , required this.uploadDate});

  final String imageUrl;
  final String fileName;
  final DateTime uploadDate;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Details'),
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: ()
            {
              Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(imageUrl),
            const SizedBox(height: 20),
            Text('File Name: $fileName',
            style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold)),
            Text('Upload Date: $uploadDate',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
