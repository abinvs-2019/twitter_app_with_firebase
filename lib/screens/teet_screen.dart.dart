import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucid_plus_machine_test/helper/contants.dart';
import 'package:lucid_plus_machine_test/helper/login_helper.dart';
import 'package:lucid_plus_machine_test/screens/login_screen.dart';
import 'package:lucid_plus_machine_test/screens/new_tweet.dart';
import 'package:lucid_plus_machine_test/services/database.dart';

import 'singup_page.dart';

class TweetScreen extends StatefulWidget {
  @override
  _TweetScreenState createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  TextEditingController messageController = TextEditingController();

  late Stream? tweetStream;

  bool loading = false;
  ScrollController _controller = ScrollController();

  Widget tweetMessageList() {
    return StreamBuilder(
        stream: tweetStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  controller: _controller,
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  itemBuilder: (context, index) {
                    return tweetTile(
                      referenseId: (snapshot.data! as QuerySnapshot)
                          .docs[index]
                          .reference
                          .id,
                      isSentByMe: (snapshot.data! as QuerySnapshot).docs[index]
                              ['sendBy'] ==
                          Constants.myName,
                      sendBy: (snapshot.data! as QuerySnapshot).docs[index]
                          ['sendBy'],
                      time: (snapshot.data! as QuerySnapshot).docs[index]
                          ['time'],
                      message: (snapshot.data! as QuerySnapshot).docs[index]
                          ['message'],
                    );
                  })
              : Container(
                  child: Center(child: Text("No Chats yet?..Start by typing.")),
                );
        });
  }

  @override
  void initState() {
    DatabaseMethods().getTweets().then((value) {
      setState(() {
        tweetStream = value;
        HelperFunction.getuserNameInSharedPreferrence().then((val) async {
          Constants.myName = value;
        });
        print("chatmessagestream$tweetStream");
      });
    });

    super.initState();
  }

  signout() async {
    await authMethod.signOut();
    HelperFunction.saveuserLoggedInSharedPreferrence(false);
    Constants.userIsLoggedIn = false;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tweeter"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: signout,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: tweetMessageList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewTweet()));
        },
      ),
    );
  }
}

class tweetTile extends StatelessWidget {
  final bool? isSentByMe;
  final String? sendBy, referenseId;
  final int? time;
  final String? message;
  tweetTile({
    this.referenseId,
    this.isSentByMe,
    this.sendBy,
    this.message,
    this.time,
  });
  var _controller;

  var videoUrl;
  @override
  Widget build(BuildContext context) {
    var popUpMentValue;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  foregroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png"),
                  backgroundColor: Colors.blue,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  sendBy!,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topRight,
              child: isSentByMe!
                  ? PopupMenuButton(
                      itemBuilder: (_) => const <PopupMenuItem<String>>[
                            PopupMenuItem<String>(
                                child: Text('Edit'), value: 'Edit'),
                            PopupMenuItem<String>(
                                child: Text('Delete'), value: 'Delete'),
                          ],
                      onSelected: (value) {
                        if (value == "Edit") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewTweet(
                                      isUpdateData: true,
                                      referenceId: referenseId)));
                        } else if (value == "Delete") {
                          DatabaseMethods().deleteTweets(referenseId);
                        }
                      })
                  : Container(),
            ),
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message!,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}
