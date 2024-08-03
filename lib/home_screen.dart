import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'theme_controller.dart';
import 'photo_list_page.dart';

class HomeScreen extends StatelessWidget
{
  HomeScreen({super.key});

  final AuthController authController = Get.find();
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: Icon(themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode),
            onPressed: themeController.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome Home!",
              style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()
              {
                Get.toNamed('/upload');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Upload Photo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()
              {
                Get.to(() => const PhotoListPage());
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity , 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('View Uploaded Photos'),
            ),
          ],
        ),
      ),
    );
  }
}
