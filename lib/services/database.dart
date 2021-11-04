import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserbyUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserbyEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  Future checkUserExists(username) {
    var exist = FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
    return exist;
  }

  // Future<void> createChatRoom(String chatRoomId, chatRoomMap) {
  //   FirebaseFirestore.instance
  //       .collection("ChatRoom")
  //       .doc(chatRoomId)
  //       .set(chatRoomMap)
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }
  Future deleteTweets(idd) async {
    var id;
    await FirebaseFirestore.instance
        .collection("TweetRoom")
        .doc("tweets")
        .collection("tweets")
        .doc("$idd")
        .delete();
  }

  Future addTweets(messageMap) async {
    var id;
    await FirebaseFirestore.instance
        .collection("TweetRoom")
        .doc("tweets")
        .collection("tweets")
        .add(messageMap)
        .then((value) => {id = value.id});
    if (id != null) {
      return id;
    } else {
      print("no id got");
    }
  }

  Future updateTweets(messageMap, idd) async {
    var id;
    await FirebaseFirestore.instance
        .collection("TweetRoom")
        .doc("tweets")
        .collection("tweets")
        .doc("$idd")
        .update({
      "message": "$messageMap",
    }).then((value) => {});
    if (id != null) {
      return id;
    } else {
      print("no id got");
    }
  }

  getTweets() async {
    return await FirebaseFirestore.instance
        .collection("TweetRoom")
        .doc("tweets")
        .collection("tweets")
        .orderBy("time", descending: true)
        .snapshots();
  }

  // getChatRoom(String userName) async {
  //   return await FirebaseFirestore.instance
  //       .collection("ChatRoom")
  //       .where("users", arrayContains: userName)
  //       .snapshots();
  // }

}
