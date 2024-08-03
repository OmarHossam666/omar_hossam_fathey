import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class PhotoUploadPage extends StatefulWidget
{
  const PhotoUploadPage({super.key});

  @override
  PhotoUploadPageState createState() => PhotoUploadPageState();
}

class PhotoUploadPageState extends State <PhotoUploadPage>
{
  File? _image;
  bool _isUploading = false;

  Future <void> _pickImage() async
  {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null)
    {
      setState(()
      {
        _image = File(result.files.single.path!);
      });
    }
  }

  Future <void> _uploadImage() async
  {
    if (_image == null) return;

    setState(()
    {
      _isUploading = true;
    });

    try
    {
      String fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(_image!);

      await uploadTask.whenComplete(() async
      {
        try
        {
          String downloadUrl = await storageReference.getDownloadURL();

          // Store metadata in Firestore
          await FirebaseFirestore.instance.collection('photos').add
          ({
            'url': downloadUrl,
            'fileName': fileName,
            'uploadDate': DateTime.now(),
          });

          Get.snackbar('Success' , 'Photo uploaded successfully!');
          Get.to(() => PhotoDisplayPage(
            imageUrl: downloadUrl,
            fileName: fileName,
            uploadDate: DateTime.now(),
          ));
        }
        catch (error)
        {
          Get.snackbar('Error', 'Failed to retrieve download URL: $error');
        }
      });
    }
    catch (error)
    {
      Get.snackbar('Error', 'Failed to upload photo: $error');
    }
    finally
    {
      setState(()
      {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              )
            else
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.photo,
                  color: Colors.grey[800],
                  size: 100,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Select Photo'),
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity , 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: _isUploading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(Icons.cloud_upload),
              label: const Text('Upload Photo'),
              onPressed: _isUploading ? null : _uploadImage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity , 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        title: const Text('Uploaded Photo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl),
            const SizedBox(height: 20),
            Text(
              'File Name: $fileName',
              style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Upload Date: ${uploadDate.toLocal()}',
              style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
