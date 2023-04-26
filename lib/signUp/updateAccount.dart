import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  // Initialized date selector

  var headers = {'Content-Type': 'application/json'};
  DateTime _selectedDate = DateTime(2002, 5, 10);

  final _signUpForm = GlobalKey<FormState>();

  static get formatter => null;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Define the text editing controllers for the form fields
  final TextEditingController _studentIdController = TextEditingController();
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  final TextEditingController _yearGroupController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _residenceController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _movieController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _confPasswordController = TextEditingController();

  Future<void> _submitForm(BuildContext context) async {
    final url =
        'https://us-central1-finalproject-sav.cloudfunctions.net/run_app' +
            '?userId=' +
            _studentIdController.text;
    print(url);
    final headers = {'Content-Type': 'application/json'};
    final data = {
      'userId': _studentIdController.text,
      // 'username': _nameController.text,
      // 'email': _emailController.text,
      'dob': _dateController.text,
      'yearGroup': _yearGroupController.text,
      'major': _majorController.text,
      'residence': _residenceController.text,
      'favfood': _foodController.text,
      'favmovie': _movieController.text,
      // 'password': _passwordController.text,
      // 'confpassword': _confPasswordController.text,
    };

    final encodedData = json.encode(data);

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: encodedData,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/UserLanding');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Date Formatter
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final TextEditingController _dateController = TextEditingController(
        text: _selectedDate == null ? '' : formatter.format(_selectedDate));

    return MaterialApp(
      title: 'Ashverse!',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 43, 56, 190),
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(350, 80, 350, 80),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _signUpForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person, size: 50),
                      onPressed: () {},
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Update your Ashverse Account!',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Flexible(
                          child: TextFormField(
                            controller: _studentIdController,
                            decoration: const InputDecoration(
                              labelText: 'Student ID Number',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Date of Birth',
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                controller: _dateController,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Flexible(
                          child: TextFormField(
                            controller: _yearGroupController,
                            decoration: const InputDecoration(
                              labelText: 'Year Group',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: TextFormField(
                            controller: _majorController,
                            decoration: const InputDecoration(
                              labelText: 'Major',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: TextFormField(
                            controller: _residenceController,
                            decoration: const InputDecoration(
                              labelText: 'Residence: On/Off Campus',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Flexible(
                          child: TextFormField(
                            controller: _foodController,
                            decoration: const InputDecoration(
                              labelText: 'Best Food',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: TextFormField(
                            controller: _movieController,
                            decoration: const InputDecoration(
                              labelText: 'Favorite Movie',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     const SizedBox(width: 20),
                    //     Flexible(
                    //       child: TextFormField(
                    //         controller: _passwordController,
                    //         obscureText: true,
                    //         decoration: const InputDecoration(
                    //           labelText: 'Password',
                    //           labelStyle: TextStyle(color: Colors.black),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     Flexible(
                    //       child: TextFormField(
                    //         controller: _confPasswordController,
                    //         obscureText: true,
                    //         decoration: const InputDecoration(
                    //           labelText: 'Confirm Password',
                    //           labelStyle: TextStyle(color: Colors.black),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 20),
                    //   ],
                    // ),
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
                      child: const Text('Sign up'),
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
                '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Have an Ashverse account already? ",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              InkWell(
                child: const Text(
                  "Sign in now!",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  // Navigate to the sign-up page
                  Navigator.pushNamed(context, '/signIn');
                },
              ),
              const Text(
                '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
