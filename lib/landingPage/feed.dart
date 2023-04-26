import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feedposts')
          .orderBy('postTime', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error sha");
        }

        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data =
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>;
              String email = data?['email'] ?? '';
              String postBody = data?['postBody'] ?? '';
              String postTime = data?['postTime'] ?? '';
              int likes = data?['likes'] ?? 0;

              int _currentLikedIndex = -1;
              Set<int> _likedEntries = {};
              List<int> _isLikedList =
                  List.generate(data.length, (index) => index + 1);

              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 202, 200, 200)
                          .withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 43, 56, 190),
                            size: 24,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 88, 89, 92),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: Text(
                              postTime,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 88, 89, 92),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        postBody,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 153, 153, 153),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        color: Color.fromARGB(255, 43, 56, 190),
                        onPressed: () {
                          setState(() {
                            if (_likedEntries.contains(index)) {
                              _likedEntries.remove(
                                  index); // remove index if already liked
                            } else {
                              _likedEntries
                                  .add(index); // add index if not already liked
                            }
                          });
                        },
                        icon: Icon(
                          _likedEntries.contains(index)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _likedEntries.contains(index)
                              ? Color.fromARGB(255, 43, 56, 190)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              // color: Colors.white70,
              color: Colors.transparent,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void setState(Null Function() param0) {}
}
