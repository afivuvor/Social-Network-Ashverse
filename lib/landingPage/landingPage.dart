import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ashverse/landingPage/feed.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

// final TextEditingController searchBoxControl = TextEditingController();

// ignore: camel_case_types
class _LandingPageState extends State<LandingPage> {
  // late List<String> entries;

  final List<int> colorCodes = <int>[600, 500, 100];
  final _controller = TextEditingController();

  String dropdownValue = 'Sign Up';
  List<String> options = ['Sign Up', 'Sign In'];

  int _currentLikedIndex = -1;
  // Set<int> _likedEntries = {};

  @override
  Widget build(BuildContext context) {
    // List<int> _isLikedList =
    //     List.generate(entries.length, (index) => index + 1);
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
                  const SizedBox(width: 150),
                  // search bar
                  Expanded(
                    child: TextFormField(
                      // controller: searchBoxControl,
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
                        hintText: 'Sign in to Search Ashverse!',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 10.0), // reduce vertical padding
                        filled: true,
                        fillColor: const Color.fromARGB(
                            255, 235, 234, 234), // set background color
                      ),
                      onFieldSubmitted: (text) => {
                        // searchBoxControl.text = text,
                        Navigator.pushNamed(context, '/signIn'),
                      },
                    ),
                  ),

                  const SizedBox(width: 200),
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
                      icon: const Icon(Icons.home),
                      tooltip: 'Home',
                      onPressed: () {
                        // TODO: handle profile icon press
                        Navigator.pushNamed(
                            context, '/UserLanding'); // to be changed
                      },
                      color: const Color.fromARGB(255, 202, 202, 202),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.view_quilt),
                    tooltip: 'Feed',
                    onPressed: () {
                      // TODO: handle profile icon press
                    },
                    color: const Color.fromARGB(255, 202, 202, 202),
                  ),
                  IconButton(
                    icon: const Icon(Icons.groups),
                    tooltip: 'People',
                    onPressed: () {
                      // TODO: handle profile icon press
                    },
                    color: const Color.fromARGB(255, 202, 202, 202),
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
                        if (value == 'Sign Up') {
                          Navigator.pushNamed(context, '/signUp');
                        } else if (value == 'Sign In') {
                          Navigator.pushNamed(context, '/signIn');
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
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.fromLTRB(5, 7, 5, 5),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            // color: Color.fromARGB(255, 43, 56, 190),
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      constraints: const BoxConstraints.expand(),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5, 20, 10, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      color: const Color.fromARGB(254, 255, 255, 255),
                      margin: const EdgeInsets.fromLTRB(50, 40, 50, 10),
                      child: Posts(),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              width: 400,
                              height: 400,
                              decoration: const BoxDecoration(),
                              child: const Icon(
                                Icons.interests,
                                color: Color.fromARGB(255, 43, 56, 190),
                                size: 200,
                              ),
                            ),
                            // const SizedBox(height: 10),
                            const Text(
                              "SEE ALL OF ASHVERSE",
                              // textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 80, 83, 122),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signUp');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 43, 56, 190),
                                    onPrimary: Colors.white,
                                  ),
                                  child: const Text('Sign Up'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signIn');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 43, 56, 190),
                                    onPrimary: Colors.white,
                                  ),
                                  child: const Text('Sign In'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signIn');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 43, 56, 190),
                                    onPrimary: Colors.white,
                                  ),
                                  child: const Text('Find Users'),
                                ),
                              ],
                            )
                          ],
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
  }
}
