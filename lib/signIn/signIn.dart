// ignore_for_file: use_build_context_synchronously

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:ashverse/signInProvider/signInProvider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _signInForm = GlobalKey<FormState>();

  // Define the text editing controllers for the form fields
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submitForm(BuildContext context) async {
    String url =
        'https://us-central1-finalproject-sav.cloudfunctions.net/run_app';
    var request = http.Request('POST', Uri.parse(url));
    final headers = {'Content-Type': 'application/json'};

    final data = {
      'userId': _studentIdController.text,
      'password': _passwordController.text,
    };

    request.body = json.encode(data);
    final encodedData = request.body;

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String responseContent = await response.stream.bytesToString();

    try {
      print(response.statusCode);
      // print(responseContent);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Sign In Success!"),
              content: Text(""),
            );
          },
        );
        final signinResponse = jsonDecode(responseContent);
        Provider.of<signInProvider>(context, listen: false).userId =
            signinResponse['userId'];
        var signinId =
            Provider.of<signInProvider>(context, listen: false).userId;

        Provider.of<signInProvider>(context, listen: false).email =
            signinResponse['email'];
        var signinEmail =
            Provider.of<signInProvider>(context, listen: false).email;

        // print provider variables
        print(signinId);
        print(signinEmail);

        // Redirect to user landing page
        Navigator.pushNamed(context, '/UserLanding');
      } else if (response.statusCode == 500) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Invalid Entry"),
                content: Text("Enter a valid id and password"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Invalid Sign In"),
                content: Text("Id or password incorrect"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ashverse!',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 43, 56, 190),
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(400, 80, 400, 80),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _signInForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person, size: 50),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign into your Ashverse account',
                      style: TextStyle(fontSize: 17, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Flexible(
                          child: TextFormField(
                            controller: _studentIdController,
                            decoration: const InputDecoration(
                              labelText: 'Student Id',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Flexible(
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40, width: 50),
                    ElevatedButton(
                      onPressed: () {
                        _submitForm(
                          context,
                        );
                      },
                      style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(const Size(200, 50)),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 43, 56, 190)),
                      ),
                      child: const Text('Sign in'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an Ashverse account? ",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              InkWell(
                child: const Text(
                  "Sign up now!",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  // Navigate to the sign-up page
                  Navigator.pushNamed(context, '/signUp');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
