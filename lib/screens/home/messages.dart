import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/home/main_screen.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  TextEditingController _messageController = TextEditingController();
  var collection = FirebaseFirestore.instance.collection("messages");
  final FocusNode _focusNode = FocusNode();
  List _messages =[];

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  _incrementCounter() async {

    try {
    List tempMessages = [];
    var data = await collection.get();
    data.docs.forEach((element) {
      tempMessages.add(element);
    });

    setState(() {
      _messages.clear();
      for (var items in tempMessages) {
        items.data()?.forEach((key, value) {
          _messages.add(value);
        });
      }
    });

  } catch (e) {
    if (mounted) {
        await Future.delayed(const Duration(seconds: 5));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong. Please try again..')),
        );
      }
    }
  }

  _refreshMessages() async {
  try {
    List tempMessages = [];
    var data = await collection.get();
    data.docs.forEach((element) {
      tempMessages.add(element);
    });

    setState(() {
      _messages.clear();
      for (var items in tempMessages) {
        items.data()?.forEach((key, value) {
          _messages.add(value);
        });
      }
    });

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong. Please try again..')),
    );
  }
}

  sendMessege() async {

    try {
      String messages = _messageController.text.trim();
      String timeStamp = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());

      if(messages.isNotEmpty) {
        var fireBaseUser = await FirebaseAuth.instance.currentUser;
        var path = await collection.doc(fireBaseUser?.uid).get();

        if (path.exists) {
          collection.doc(fireBaseUser?.uid)
            .update({
              timeStamp : messages
            });
        } else {
          collection.doc(fireBaseUser?.uid)
            .set({
              timeStamp : messages
            });
        }
      }

      await _refreshMessages();
      _messageController.clear();
      FocusScope.of(context).unfocus();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Messege cannot send. Please try again..')),
      );
    }
  }

  deleteMessage(String message) async {

    try {
      var fireBaseUser = await FirebaseAuth.instance.currentUser;
      var messegeId = "";

      List tempMessages = [];
      var data = await collection.get();
      data.docs.forEach((element) {
        tempMessages.add(element);
      });

      for (var items in tempMessages) {
        items.data()?.forEach((key, value) {
          if (value == message) {
            messegeId = key;
          }
        });
      }

      await collection.doc(fireBaseUser?.uid).update({
        messegeId: FieldValue.delete(),
      });

      Navigator.pop(context);
      await _refreshMessages();
      FocusScope.of(context).unfocus();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Messege cannot delete. Please try again..')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      appBar: AppBar(
        title: Text('Messages',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
            builder: (context) => MainScreen(index: 0,)));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              height: MediaQuery.of(context).size.height / 1.27,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.48,
                    child: _messages.isNotEmpty ? ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        String message = _messages[index].toString();
                        return Align(
                          alignment: Alignment.centerRight,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 45,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  DeleteAlertBox(context, message);
                                });
                              },
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                color: kPrimaryColor,
                                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text(
                                        message,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ) : SizedBox(height: 0,),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: _messageController,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                hintText: 'Type message here',
                                hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: sendMessege,
                          child: Icon(
                            Icons.send,
                            size: 24,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            minimumSize: Size(60, 55),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),),
                ],
              ),
            ),  
            ],
          ),
        ),
      ),
    );
  }

  dynamic DeleteAlertBox(BuildContext context, String message) {
  return showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title: Text("Do you want to delete this messege",
      textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
          child: MaterialButton(onPressed: () {
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
          ),
          minWidth: 100,
          height: 50,
          color: kPrimaryColor,
          textColor: Colors.white, 
          child: Text('Cancel')),
        ),
        Center(
          child: MaterialButton(onPressed: () async {
            deleteMessage(message);
          },
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
          ),
          minWidth: 100,
          height: 50,
          color: Colors.red[700],
          textColor: Colors.white, 
          child: Text('Delete')),
        )
          ],
        )
      ],
    );
  });}
}