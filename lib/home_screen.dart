import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'theme_controller.dart';

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
              "Welcome!",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/upload');
              },
              child: const Text('Upload Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
