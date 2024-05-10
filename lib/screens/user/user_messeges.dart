import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/user/user_main_screen.dart';

class UserMessages extends StatefulWidget {
  const UserMessages({super.key});

  @override
  State<UserMessages> createState() => _UserMessagesState();
}

class _UserMessagesState extends State<UserMessages> {

  var collection = FirebaseFirestore.instance.collection("messages");
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
      
      if (mounted) {
        setState(() {
          for (var items in tempMessages) {
            items.data()?.forEach((key, value) {
              _messages.add(value);
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        await Future.delayed(const Duration(seconds: 5));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong. Please try again..')),
        );
      }
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
              builder: (context) => UserMainScreen(index: 0,)));
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.27,
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
                        );
                        },
                      ) : SizedBox(height: 0,),
              )
            ],
          ),
        ),
      ),
    );
  }
}