import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/tile%20items/employee%20attendance/attendance_details.dart';
import 'package:office_administrator_app/screens/tile%20items/mange%20employee/manage_employee_screen.dart';
import 'package:office_administrator_app/screens/tile%20items/salary%20management/salary_details.dart';

class EmployeeTile extends StatefulWidget {
  final String uid;
  const EmployeeTile({super.key, required this.uid});

  @override
  State<EmployeeTile> createState() => _EmployeeTileState();
}

class _EmployeeTileState extends State<EmployeeTile> {
  String? userName, userJob, userEmail, profilePhoto, salary, attendanceMarked;
  String timeStamp = DateFormat('yyyy-MM').format(DateTime.now());
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {

    try {
      var userCollection = FirebaseFirestore.instance.collection('users');
      var userDocument = await userCollection.doc(widget.uid).get();
      var salaryCollection = FirebaseFirestore.instance.collection("salary");
      var attendanceCollection = FirebaseFirestore.instance.collection("attendance");
      
      
      List tempDate = [];
      List tempAmount = [];
      var data = await salaryCollection.doc(widget.uid).get();
      if (data.exists && data.data() != null) {
        data.data()?.forEach((key, value) {
          tempDate.add(key);
          tempAmount.add(value);
        });
      }
      
      setState(() {
        if (tempDate.isNotEmpty) {
          for (var item in tempDate) {
            if (timeStamp == item) {
              salary = "Paid " + tempAmount[tempDate.indexOf(item)];
            }
          }
        }
      });
      
      var present = await attendanceCollection.doc(widget.uid).get();
      if (present.exists && present.data() != null) {
        present.data()?.forEach((key, value) {
          setState(() {
            if (currentDate == key) {
              if (value != "In leave") {
                attendanceMarked = "Present";
              }
              else {
                attendanceMarked = value;
              }
            }
          });
        });
      }
      
      if (userDocument.exists) {
        setState(() {
          userEmail = userDocument.data()?['email'];
          userName = userDocument.data()?['username'];
          userJob = userDocument.data()?['userjob'];
          profilePhoto = userDocument.data()?['image'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again..')),
      );
    }

  }

  Future deleteuser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).delete();
      var salaryDetails =  await FirebaseFirestore.instance.collection('attendance').doc(widget.uid).get();
      var attendanceDetails = await FirebaseFirestore.instance.collection('salary').doc(widget.uid).get();

      if (salaryDetails.exists || attendanceDetails.exists) {
        await FirebaseFirestore.instance.collection('attendance').doc(widget.uid).delete();
        await FirebaseFirestore.instance.collection('salary').doc(widget.uid).delete();
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageEmployeeScreen()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User was remove successfully.')),
      );
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
          title: Text('User details',
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
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15,),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profilePhoto != null ? NetworkImage(profilePhoto!) : NetworkImage('https://pasrc.princeton.edu/sites/g/files/toruqf431/files/styles/freeform_750w/public/2021-03/blank-profile-picture-973460_1280.jpg?itok=QzRqRVu8'),
                ),
              ),
              SizedBox(height: 15,),
              ListTiles('Name', userName ?? '', Icons.person_2_outlined),
              ListTiles('Job', userJob ?? 'Not specified', Icons.work_outline_outlined),
              ListTiles('Email', userEmail ?? '', Icons.mail_outline),
              ListTiles('Salary', salary ?? 'Not paid', Icons.paid_outlined),
              ListTiles('Attendance', attendanceMarked ?? 'Not marked', Icons.history_outlined),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: TextButton.icon(onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => SalaryDetails(
                            uid: widget.uid,
                      )));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    icon: Icon(Icons.currency_rupee,
                    size: 18,
                    ), 
                    label: Text("payment",
                    style: TextStyle(
                      fontSize: 12
                    ),
                    )),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: TextButton.icon(onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceDetails(
                            uid: widget.uid,
                      )));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    icon: Icon(Icons.edit_calendar_outlined,
                    size: 18,
                    ), 
                    label: Text("Attendance",
                    style: TextStyle(
                      fontSize: 12
                    ),
                    )),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: TextButton.icon(onPressed: () {
                      DeleteAlertBox(context, userName!);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.delete,
                    size: 18,
                    ), 
                    label: Text("Delete",
                    style: TextStyle(
                      fontSize: 12
                    ),
                    )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Column ListTiles(String title, String subtitle, IconData icondata) {
    return Column(
      children: [
        Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: Icon(icondata,
                size: 30,),
          ),
        ),
        SizedBox(height: 5,),
      ],
    );
  }

  dynamic DeleteAlertBox(BuildContext context, String name) {
  return showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title: Text("Do you want to delete $name",
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
          child: MaterialButton(onPressed: deleteuser,
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
  }
  );
}
}