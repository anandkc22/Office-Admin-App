import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/screens/home%20tiles/manage_employees.dart';
import 'package:office_administrator_app/screens/home%20tiles/manage_departments.dart';
import 'package:office_administrator_app/screens/home%20tiles/salary_management.dart';
import 'package:office_administrator_app/screens/home%20tiles/employee_attendance.dart';
import 'package:office_administrator_app/screens/home/appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Appbar(),
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
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Admin Tools',
                style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 40,)
              ],
            ),
          ),
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
              ManageEmployees(),
              ManageDepartments(),
              SalaryManagement(),
              EmployeeAttendance()
            ],
          ),
        ],
    );
  }
}
