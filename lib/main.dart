import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/payment_screen.dart'; 
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const NewProjectApp());
  } catch (e) {
    print("Firebase initialization error: $e");
  }
}

// Initialize Google Sign-In
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
);

class NewProjectApp extends StatelessWidget {
  const NewProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rental App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/payment': (context) => PaymentScreen(),
      },
    );
  }
}

// Authentication Wrapper - Handles Firebase & Google Sign-In
class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? _firebaseUser;
  GoogleSignInAccount? _googleUser;

  @override
  void initState() {
    super.initState();
    // Listen for Firebase auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _firebaseUser = user;
      });
    });

    // Try Google Sign-In silently (for Web)
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _googleUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    if (_firebaseUser != null || _googleUser != null) {
      return HomeScreen(); // User is logged in
    }
    return LoginScreen(); // User is not logged in
  }
}
