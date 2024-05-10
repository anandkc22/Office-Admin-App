import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/tile%20items/employee%20attendance/employee_attendance_screen.dart';

class AttendanceDetails extends StatefulWidget {
  final String uid;
  const AttendanceDetails({super.key, required this.uid});

  @override
  State<AttendanceDetails> createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  
  String currentTime = DateFormat('yMMMMd').format(DateTime.now());
  String timeStamp = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var collection = FirebaseFirestore.instance.collection("attendance");
  TimeOfDay _entryTime = TimeOfDay(hour: 9, minute: 00);
  TimeOfDay _exitTime = TimeOfDay(hour: 18, minute: 00);
  late List date = [];
  late List time = [];
  bool isMarked = false;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  _incrementCounter() async {

  List tempDate = [];
  List tempTime = [];

  try {
    var data = await collection.doc(widget.uid).get();
    
    if (data.exists && data.data() != null) {
      data.data()?.forEach((key, value) {
        tempDate.add(key);
        tempTime.add(value);
      });
    }
    setState(() {

      date = tempDate;
      time = tempTime;
      
      if (date.contains(timeStamp)) {
        isMarked = true;    
      }
      isLoaded = true;
    });
      
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong. Please try again..')),
    );
  }
}

  Future<void> _selectTime(String type) async {

    if (type == 'entry') {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _entryTime,
      );
      if (picked != null) {
        setState(() {
          _entryTime = picked;
        });
      }
    } else if (type == 'exit') {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _exitTime,
      );
      if (picked != null) {
        setState(() {
          _exitTime = picked;
        });
      }
    }
  }

  _isPresent() async {

    try {
      if (date.contains(timeStamp) == false) {
        
        var uid = widget.uid;
        var salary = await FirebaseFirestore.instance.collection('attendance').doc(uid);
        var path = await FirebaseFirestore.instance.collection('attendance').doc(uid).get();
      
        if (path.exists && path.data() != null) {
          salary.update({
            timeStamp : _entryTime.format(context) + " - " + _exitTime.format(context)
          });

        }
        else {
          salary.set({
            timeStamp : _entryTime.format(context) + " - " + _exitTime.format(context)
          });
        }
      
        isMarked = true;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AttendanceDetails(uid: widget.uid,)));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance marked.')),
        );
      }
      else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AttendanceDetails(uid: widget.uid,)));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance not marked.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again..')),
      );
    }
  }

  _isLeave() async {

    try {

      if (date.contains(timeStamp) == false) {
      
        var uid = widget.uid;
        var salary = await FirebaseFirestore.instance.collection('attendance').doc(uid);
        var path = await FirebaseFirestore.instance.collection('attendance').doc(uid).get();

        if (path.exists && path.data() != null) {
          salary.update({
          timeStamp : "In leave"
        });
        }
        else {
          salary.set({
          timeStamp : "In leave"
        });
        }

        isMarked = true;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AttendanceDetails(uid: widget.uid,)));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance marked.')),
        );
      }
      else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AttendanceDetails(uid: widget.uid,)));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance not marked.')),
        );
      }
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
          title: Text('Attendance details',
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
              builder: (context) => EmployeeAttendanceScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              isLoaded ? Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Text("Current date $currentTime",
                      style: TextStyle(
                        fontSize: 20,
                      ),),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: isMarked == false ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('Entry', style: TextStyle(
                                  fontSize: 18, color: kPrimaryColor),),
                                GestureDetector(onTap: () {
                                  _selectTime('entry');
                                }, 
                                child: Text(_entryTime.format(context), style: TextStyle(
                                  fontSize: 22, color: Colors.black),)),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Exit', style: TextStyle(
                                  fontSize: 18, color: kPrimaryColor),),
                                GestureDetector(onTap: () {
                                  _selectTime('exit');
                                }, 
                                child: Text(_exitTime.format(context), style: TextStyle(
                                  fontSize: 22, color: Colors.black),)),
                              ],
                            )
                          ],
                        ) : Text("Attendance marked",
                        style: TextStyle(
                          fontSize: 20,
                          color: kPrimaryColor
                        ),
                        ),
                      ),
                      isMarked == false ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: _isLeave,
                                  child: Text('In leave',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white
                                  ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: _isPresent,
                                  child: Text('Present',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white
                                  ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ) : SizedBox(height: 0,)
                    ],
                  ),
                ),
              ) : Text(""),
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
                        trailing: Text(time[index].toString(), style: TextStyle(color: time[index].toString() =="In leave" ? Colors.red :Colors.green, fontSize: 18),),
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