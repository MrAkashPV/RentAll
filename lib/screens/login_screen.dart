import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle Google Sign-In
  Future<void> _signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: "827161747707-nkjn7s9efgippsbfvhotjtssnnqubvnb.apps.googleusercontent.com", // 🔹 Add Client ID Here (for Web)
  );

  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  if (googleUser == null) return; // User canceled sign-in

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  if (userCredential.user != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(
                'assets/head.png',
                height: 120,
              ),
              SizedBox(height: 20),

              // Welcome Text
              Text(
                'Welcome to RentAll',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              Text(
                'Rent anything, anytime, anywhere!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),

              // Google Sign-In Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  side: BorderSide(color: Colors.grey),
                  elevation: 0,
                ),
                icon: Image.asset(
                  'assets/google_logo.png',
                  height: 24,
                ),
                label: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                onPressed: _signInWithGoogle,
              ),

              SizedBox(height: 20),

              Text(
                'By continuing, you agree to our Terms of Service & Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
