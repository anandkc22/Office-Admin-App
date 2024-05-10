import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/home/main_screen.dart';
import 'package:office_administrator_app/screens/tile%20items/employee%20attendance/attendance_details.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  const EmployeeAttendanceScreen({super.key});

  @override
  State<EmployeeAttendanceScreen> createState() => _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
 
  var collection = FirebaseFirestore.instance.collection("users");
  var attendance = FirebaseFirestore.instance.collection("attendance");
  String currentTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late List<Map<String, dynamic>> items;
  String uid = "";
  List usersAttendance = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  _incrementCounter() async {

    List<Map<String, dynamic>> tempList = [];

    try {
      var data = await collection.get();
      data.docs.forEach((element) {
        tempList.add(element.data());
      });
      
      for (var val in tempList) {
        var uid = val['uid'];
        var user = await attendance.doc(uid).get();
        if (user.exists && user.data() != null) {
          user.data()?.forEach((key, value) {
            if (key.contains(currentTime)) {
              usersAttendance.add(uid);
            }
          });
        }
      }
      
      setState(() {
        items = tempList;
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
          title: Text('Manage attendance',
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
              SizedBox(
                  height: MediaQuery.of(context).size.height - 125,
                  child: isLoaded
                      ? ListView.separated(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                uid = items[index]['uid'];
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => AttendanceDetails(
                                              uid: uid,
                                            )));
                              },
                              leading: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipRRect(
                                  child: items[index]['image'] != null
                                      ? Image.network(
                                          items[index]['image']!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          'https://pasrc.princeton.edu/sites/g/files/toruqf431/files/styles/freeform_750w/public/2021-03/blank-profile-picture-973460_1280.jpg?itok=QzRqRVu8',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              title: Text(items[index]['username']),
                              subtitle: usersAttendance.contains(items[index]['uid'])
                                  ? Text("Attendance marked", style: TextStyle(color: Colors.blue),)
                                  : Text("Attendance not marked", style: TextStyle(color: Colors.red)),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                        )
                      : Center(
                          child: CircularProgressIndicator(color: Colors.black,),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}