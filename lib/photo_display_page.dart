import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhotoDisplayPage extends StatelessWidget
{
  const PhotoDisplayPage({super.key , required this.imageUrl , required this.fileName , required this.uploadDate , required this.docId});

  final String imageUrl;
  final String fileName;
  final DateTime uploadDate;
  final String docId;

Future <void> _deletePhoto(BuildContext context) async
{
    try
    {
      // Delete from Firebase Storage
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

      // Delete from Firestore
      await FirebaseFirestore.instance.collection('photos').doc(docId).delete();

      Get.back(); // Navigate back to the list view
      Get.snackbar('Success' , 'Photo deleted successfully!');

    } 
    catch (error)
    {
      Get.snackbar('Error' , 'Failed to delete the photo: $error');
    }
  }

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
          IconButton(onPressed: () => _deletePhoto(context) , icon: const Icon(Icons.delete)),
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
