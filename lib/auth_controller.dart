import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthController extends GetxController
{
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  _setInitialScreen(User? user)
  {
    if (user == null)
    {
      Get.offAll(() => LoginScreen());
    } 
    else
    {
      Get.offAll(() => HomeScreen());
    }
  }

  void register(String email, String password) async
  {
    try
    {
      await auth.createUserWithEmailAndPassword(email: email , password: password);
    }
    catch (error)
    {
      Get.snackbar('Error creating account' , error.toString());
    }
  }

  void login(String email, String password) async
  {
    try
    {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } 
    catch (error)
    {
      Get.snackbar('Error logging in' , error.toString());
    }
  }

  void logOut() async
  {
    await auth.signOut();
  }

  @override
  void onReady()
  {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user , _setInitialScreen);
  }
}
