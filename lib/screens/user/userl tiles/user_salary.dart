import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/user/user_main_screen.dart';

class UserSalary extends StatefulWidget {
  const UserSalary({super.key});

  @override
  State<UserSalary> createState() => _UserSalaryState();
}

class _UserSalaryState extends State<UserSalary> {

  String currentTime = DateFormat('yMMMM').format(DateTime.now());
  String timeStamp = DateFormat('yyyy-MM').format(DateTime.now());
  var collection = FirebaseFirestore.instance.collection("salary");
  var currentUser = FirebaseAuth.instance.currentUser;
  late List date = [];
  late List amount = [];
  bool isLoaded = false;
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  _incrementCounter() async {
    List tempDate = [];
    List tempAmount = [];

    try {
      var data = await collection.doc(currentUser?.uid).get();
      if (data.exists && data.data() != null) {
        data.data()?.forEach((key, value) {
          tempDate.add(key);
          tempAmount.add(value);
        });
      }
      
      setState(() {
        date = tempDate;
        amount = tempAmount;
        if (date.contains(timeStamp)) {
          isPaid = true;    
        }
        isLoaded = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again..')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Salary details',
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
              SizedBox(height: 15,),
              isLoaded ? Padding(
                padding: const EdgeInsets.all(13),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [ 
                          Text("Current date", style: TextStyle(fontSize: 20),),
                          Text(currentTime, style: TextStyle(fontSize: 20),)
                        ]
                      ),
                      isPaid ? Column(
                        children: [
                          Row(
                            children: [
                              Text("Salary ", style: TextStyle(color: Colors.green, fontSize: 20),),
                              Text("paid", style: TextStyle(color: Colors.green, fontSize: 20),),
                            ],
                          ),
                        ],
                      ) :  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Salary", style: TextStyle(color: Colors.red, fontSize: 20),),
                          Text("not paid", style: TextStyle(color: Colors.red, fontSize: 20),), 
                        ]
                      )
                    ],
                  ),
                ),
              ) : Text(''),
              SizedBox(height: 10,),
              date.isNotEmpty ? Text('History',style: TextStyle(color: kPrimaryColor, fontSize: 25),) : Text(''),
              SizedBox(
                height: MediaQuery.of(context).size.height - 125,
                child: isLoaded ? ListView.separated(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: date.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(date[index].toString()),
                        trailing: Text("- " + amount[index].toString(), style: TextStyle(color: Colors.green, fontSize: 18)),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ) : Center(child: CircularProgressIndicator(color: Colors.black,)),
              ),
              ],
            ),
          ),
        ),
    );
  }
}