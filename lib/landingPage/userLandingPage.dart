import 'package:provider/provider.dart';
import 'package:ashverse/signIn/signIn.dart';
import 'package:ashverse/signInProvider/signInProvider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ashverse/landingPage/feed.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ashverse/landingPage/feed.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: camel_case_types
class UserLandingPage extends StatefulWidget {
  const UserLandingPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserLandingPageState createState() => _UserLandingPageState();
}

final TextEditingController searchBoxControl = TextEditingController();

// ignore: camel_case_types
class _UserLandingPageState extends State<UserLandingPage> {
  final List<int> colorCodes = <int>[600, 500, 100];
  // final _controller = TextEditingController();

  String dropdownValue = 'Update Profile';
  List<String> options = ['Update Profile', 'Sign Out'];

  int _currentLikedIndex = -1;

  final _makePostForm = GlobalKey<FormState>();
  final TextEditingController _postController = TextEditingController();

  Future<void> makePost(BuildContext context, String email, String postBody,
      String postersId) async {
    String url =
        'https://us-central1-finalproject-sav.cloudfunctions.net/run_app';

    var request = http.Request('PATCH', Uri.parse(url));
    final headers = {'Content-Type': 'application/json'};

    final data = {
      'email': email,
      'postBody': postBody,
      'postersId': postersId,
    };

    request.body = json.encode(data);

    final encodedData = request.body;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String responseContent = await response.stream.bytesToString();

    try {
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("Post Successful");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Post not made"),
              content: Text(""),
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<signInProvider>(context, listen: false).userId;
    var email = Provider.of<signInProvider>(context, listen: false).email;

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
                      controller: searchBoxControl,
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
                        hintText: 'Search Ashverse',
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
                      onFieldSubmitted: (data) => {
                        // searchBoxControl.text = data,
                        Navigator.pushNamed(context, '/viewProfile'),
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
                        Navigator.pushNamed(context, '/UserLanding');
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
                        if (value == 'Update Profile') {
                          Navigator.pushNamed(context, '/updateAccount');
                        } else if (value == 'Sign Out') {
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
              color: Color.fromARGB(255, 255, 253, 253),
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
                          children: [
                            SizedBox(
                              width: 310,
                              height: 90,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(255, 43, 56, 190),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 176, 179, 209)
                                          .withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 5),
                                      // const Icon(
                                      //   Icons.person,
                                      //   color: Colors.white,
                                      //   size: 45,
                                      // ),
                                      // SizedBox(width: 0.5),
                                      Text(
                                        '$email',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Text(
                              "YOUR POSTS",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(197, 139, 139, 139),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: SizedBox(
                                width: 300,
                                // child: ListView.separated(
                                //   padding: const EdgeInsets.all(3),
                                //   scrollDirection: Axis.vertical,
                                //   shrinkWrap: true, // set shrinkWrap to true
                                //   itemCount: Posts(),
                                //   itemBuilder:
                                //       (BuildContext context, int index) {
                                //     return SizedBox(
                                //       width: 20,
                                //       child: Container(
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(10),
                                //           color: Colors.white,
                                //           boxShadow: [
                                //             BoxShadow(
                                //               color: const Color.fromARGB(
                                //                       255, 202, 200, 200)
                                //                   .withOpacity(0.5),
                                //               spreadRadius: 1,
                                //               blurRadius: 3,
                                //               offset: const Offset(0, 1),
                                //             ),
                                //           ],
                                //         ),
                                //         padding: const EdgeInsets.all(20),
                                //         child: const Center(
                                //           child: Posts(),
                                //             // style: const TextStyle(
                                //             //     color: Color.fromARGB(
                                //             //         255, 88, 89, 92)),
                                //         ),
                                //       ),
                                //     );
                                //   },
                                //   separatorBuilder:
                                //       (BuildContext context, int index) =>
                                //           const Divider(
                                //     color: Colors.transparent,
                                //   ),
                                // ),
                              ),
                            ),
                          ],
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "MAKE A POST",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(197, 139, 139, 139),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 202, 200, 200)
                                            .withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 88, 89, 92),
                                ),
                                controller: _postController,
                                maxLines: null, // Allow dynamic height
                                onFieldSubmitted: (text) => {
                                  // searchBoxControl.text = text,
                                  Navigator.pushNamed(context, '/signIn'),
                                },
                                decoration: InputDecoration(
                                  hintText: "What's new today?",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 20.0,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromARGB(255, 43, 56, 190)
                                              .withOpacity(0.5),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.send),
                                    color: Color.fromARGB(255, 43, 56, 190),
                                    onPressed: () {
                                      makePost(context, '$email',
                                          _postController.text, '$userId');
                                    },
                                  ),
                                ),
                              ),
                            ),
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
