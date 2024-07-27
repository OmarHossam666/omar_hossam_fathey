// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'theme_controller.dart';

class HomeScreen extends StatelessWidget
{
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
        child: const Text("Welcome!",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
