import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ashverse/landingPage/userLandingPage.dart';
import 'package:ashverse/landingPage/landingPage.dart';

var headers = {
  'Content-Type': 'application/json',
  'Access-Control-Allow-Origin': '*'
};

Future<Map<String, dynamic>> getUserData(String email) async {
  // email = searchBoxControl.text;
  final url = Uri.parse(
      'https://us-central1-finalproject-sav.cloudfunctions.net/run_app?email=' +
          email);
  var request = http.Request('GET', url);

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(await response.stream.bytesToString());
    return jsonResponse;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return {};
  }
}

// ignore: camel_case_types
class viewProfile extends StatefulWidget {
  const viewProfile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _viewProfile createState() => _viewProfile();
}

// ignore: camel_case_types
class _viewProfile extends State<viewProfile> {
  String username = "";
  String email = "";
  String major = "";
  String yearGroup = "";
  String userId = "";

  // Other methods and properties of MyClass

  String dropdownValue = 'Update Profile';
  List<String> options = ['Update Profile', 'Sign Out'];

  @override
  Widget build(BuildContext context) {
    // Future<Map<String, dynamic>> getUser = getUserData(searchBoxControl.text);

    return FutureBuilder<Map<String, dynamic>>(
      future: getUserData(searchBoxControl.text),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print(snapshot.data);
          print(snapshot.error);
          return const Text('Snapshot error occured');
        } else if (snapshot.hasData) {
          print(snapshot.data);
          username = snapshot.data!['username'] ?? '';
          email = snapshot.data!['email'] ?? '';
          major = snapshot.data!['major'] ?? '';
          yearGroup = snapshot.data!['yearGroup'] ?? '';
          userId = snapshot.data!['userId'] ?? '';

          return Scaffold(
            body: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 97, 98, 105),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: AppBar(
                    backgroundColor: Colors.white,
                    title: Row(
                      children: [
                        const Icon(
                          Icons.interests,
                          size: 30,
                          color: Color.fromARGB(255, 43, 56, 190),
                          semanticLabel: 'Ashverse Logo',
                        ),
                        const SizedBox(width: 7),
                        const Text('Ashverse!',
                            style: TextStyle(
                                color: Color.fromARGB(255, 88, 89, 92),
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 180),
                        // search bar
                        Expanded(
                          child: TextField(
                            style: const TextStyle(
                                color: Color.fromARGB(255, 88, 89, 92)),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 43, 56, 190)
                                      .withOpacity(0.5),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              hintText: 'Enter User Email to Search Ashverse',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2.0,
                                  horizontal: 10.0), // reduce vertical padding
                              filled: true,
                              fillColor: const Color.fromARGB(
                                  255, 235, 234, 234), // set background color
                            ),
                          ),
                        ),

                        const SizedBox(width: 170),
                        IconButton(
                          icon: const Icon(Icons.home),
                          tooltip: 'Home',
                          onPressed: () {
                            Navigator.pushNamed(context, '/UserLanding');
                          },
                          color: const Color.fromARGB(255, 202, 202, 202),
                        ),
                        IconButton(
                          icon: const Icon(Icons.view_quilt),
                          tooltip: 'Feed',
                          onPressed: () {
                            // TODO: handle profile icon press
                          },
                          color: const Color.fromARGB(255, 202, 202, 202),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 43, 56, 190),
                                width: 2,
                              ),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.people),
                            tooltip: 'People',
                            onPressed: () {
                              // TODO: handle profile icon press
                            },
                            color: const Color.fromARGB(255, 202, 202, 202),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.manage_accounts),
                          tooltip: 'Manage Profile',
                          color: const Color.fromARGB(255, 202, 202, 202),
                          onPressed: () {
                            // Show dropdown menu
                            showMenu(
                              color: Colors.white,
                              context: context,
                              position: RelativeRect.fromLTRB(
                                MediaQuery.of(context).size.width - 100,
                                kToolbarHeight,
                                0,
                                0,
                              ),
                              items: options.map((String option) {
                                return PopupMenuItem<String>(
                                  value: option,
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 85, 85, 85),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ).then((value) {
                              // Handle selected value from dropdown menu
                              if (value == 'Update Profile') {
                                Navigator.pushNamed(context, '/updateAccount');
                              } else if (value == 'Sign Out') {
                                launch('https://example.com/logout');
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color.fromARGB(254, 255, 255, 255),
                    // color: Colors.black,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            width: 20,
                            height: 400,
                            child: Container(),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(50, 40, 50, 10),
                            child: SizedBox(
                              width: 20,
                              height: 400,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                              255, 202, 200, 200)
                                          .withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.person_rounded,
                                            color: Color.fromARGB(
                                                255, 43, 56, 190),
                                            size: 200,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$username's Profile",
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 8, 22, 65),
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            email,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 88, 89, 92),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            userId,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 88, 89, 92),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            major,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 88, 89, 92),
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            yearGroup,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 88, 89, 92),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                            decoration: const BoxDecoration(),
                            constraints: const BoxConstraints.expand(),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
