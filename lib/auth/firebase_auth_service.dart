import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{

  static FirebaseAuth _auth=FirebaseAuth.instance;

  static User? get currentUser=>_auth.currentUser;

  static Future<User?> loginUser(String email,String password) async{
    final result= await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  static Future<User?> registerUser(String email,String password) async{
    final result= await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user;
  }


  static Future<void> logout() async{
    return _auth.signOut();
  }
}