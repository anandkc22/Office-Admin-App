import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/constants/size.dart';
import 'package:office_administrator_app/screens/user/user_appbar.dart';
import 'package:office_administrator_app/screens/user/userl%20tiles/user_attendance.dart';
import 'package:office_administrator_app/screens/user/userl%20tiles/user_department.dart';
import 'package:office_administrator_app/screens/user/userl%20tiles/user_salary.dart';
import 'package:office_administrator_app/screens/user/userl%20tiles/user_todo.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              UserAppbar(),
              Body(),
            ],
          ),
        ),
      ), 
      );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: 30,),
          GridView.count(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 20,
            mainAxisSpacing: 26,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8
            ),
            children: <Widget>[
              itemDashboard('Department', "assets/department.png", context, MaterialPageRoute(builder: (context) => UserDepartment())),
              itemDashboard('Attendance', "assets/attendance.png", context, MaterialPageRoute(builder: (context) => UserAttendance())),
              itemDashboard('Salary', "assets/salary.png", context, MaterialPageRoute(builder: (context) => UserSalary())),
              itemDashboard('To do', "assets/todo.png", context, MaterialPageRoute(builder: (context) => UserToDo())),
            ],
          ),
        ],
    );
  }

  itemDashboard(String title, String location, context, MaterialPageRoute page) => GestureDetector(
      onTap: () {
        Navigator.push(context, page);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 4.0,
              spreadRadius: .05
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(location,
                height: kCategoryCardImageSize,
                ),
            ),
            SizedBox(height: 3,),
            Center(
              child: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),),
            ),
          ],
        ),
      ),
    );
}
    