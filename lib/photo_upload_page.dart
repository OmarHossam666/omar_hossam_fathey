import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PhotoUploadPage extends StatefulWidget
{
  const PhotoUploadPage({super.key});

  @override
  _PhotoUploadPageState createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State <PhotoUploadPage>
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
          Get.snackbar('Success', 'Photo uploaded successfully!\nURL: $downloadUrl');
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
                minimumSize: const Size(double.infinity, 50),
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
                minimumSize: const Size(double.infinity, 50),
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
