import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_controller.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'theme_controller.dart';
import 'photo_upload_page.dart';
import 'photo_list_page.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AuthController()); // Ensure the AuthController is instantiated
  Get.put(ThemeController()); // Initialize ThemeController

  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    final ThemeController themeController = Get.find();

    return Obx(() => GetMaterialApp(
        title: 'Photo Upload App',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/' , page: () => LoginScreen()),
          GetPage(name: '/home' , page: () => HomeScreen()),
          GetPage(name: '/upload', page: () => const PhotoUploadPage()),
          GetPage(name: '/list', page: () => const PhotoListPage()),
          GetPage(name: '/display' , page: () => PhotoDisplayPage(
            imageUrl: Get.arguments['imageUrl'],
            fileName: Get.arguments['fileName'],
            uploadDate: Get.arguments['uploadDate'],
          ),
        ),
        ],
      ),
    );
  }
}
