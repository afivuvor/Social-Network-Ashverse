import 'package:ashverse/viewProfile/viewProfile.dart';
import 'package:flutter/material.dart';
import 'package:ashverse/landingPage/landingPage.dart';
import 'package:ashverse/landingPage/userLandingPage.dart';
import 'package:ashverse/signIn/signIn.dart';
import 'package:ashverse/signUp/signUp.dart';
import 'package:ashverse/signUp/updateAccount.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ashverse/signInProvider/signInProvider.dart';
// import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBeJjLemClmhVQxhrLd8zszwALu39xXeb0",
          appId: "1:1020443970567:web:b39b93d1f06c42b328eea2",
          messagingSenderId: "1020443970567",
          projectId: "finalproject-sav"));
  runApp(const MyApp());
}

// await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const url =
      'https://us-central1-finalproject-sav.cloudfunctions.net/run_app';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<signInProvider>(
      create: (_) => signInProvider(),
      child: MaterialApp(
        title: 'Ashverse!',
        // theme: ThemeData.white(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SignInPage(),
          '/signUp': (context) => const SignUpPage(),
          '/signIn': (context) => const SignInPage(),
          '/viewProfile': (context) => const viewProfile(),
          '/updateAccount': (context) => const UpdatePage(),
          '/UserLanding': (context) => const UserLandingPage(),
        },
      ),
    );
  }
}
