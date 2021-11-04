import 'package:flutter/material.dart';
import 'package:lucid_plus_machine_test/helper/contants.dart';
import 'package:lucid_plus_machine_test/helper/login_helper.dart';
import 'package:lucid_plus_machine_test/services/database.dart';

class NewTweet extends StatefulWidget {
  final bool? isUpdateData;
  final String? referenceId;
  const NewTweet({Key? key, this.isUpdateData, this.referenceId})
      : super(key: key);

  @override
  _NewTweetState createState() => _NewTweetState();
}

class _NewTweetState extends State<NewTweet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  sendTweet() {
    if (widget.isUpdateData != true) {
      if (_controller.text.isNotEmpty) {
        Map<String, dynamic> messageMap = {
          "message": _controller.text,
          "time": DateTime.now().millisecondsSinceEpoch,
          "sendBy": Constants.myName,
        };
        DatabaseMethods().addTweets(messageMap);
        Navigator.of(context).pop();
        _controller.text = "";
      }
    } else {
      DatabaseMethods()
          .updateTweets(_controller.text, widget.referenceId.toString());
      Navigator.of(context).pop();
      _controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          GestureDetector(
            onTap: sendTweet,
            child: Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: const Center(
                child: Text(
                  "Tweet",
                  style: TextStyle(color: Colors.blue, fontSize: 30),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: TextField(
          maxLength: 250,
          minLines: 1,
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          key: formKey,
          controller: _controller,
          style: const TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}
