import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/home/main_screen.dart';
import 'package:office_administrator_app/screens/opening/login.dart';
import 'package:office_administrator_app/screens/tile%20items/employee%20attendance/employee_attendance_screen.dart';
import 'package:office_administrator_app/screens/tile%20items/manage%20departments/manage_department_screen.dart';
import 'package:office_administrator_app/screens/tile%20items/mange%20employee/manage_employee_screen.dart';
import 'package:office_administrator_app/screens/tile%20items/salary%20management/salary_management_screen.dart';

class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {

  final Map <String, dynamic> listMap = {
    'Manage Employee' : ManageEmployeeScreen(),
    'Manage Department' : ManageDepartmentScreen(),
    'Salary Management' : SalaryManagementScreen(),
    'Employee Attendance' : EmployeeAttendanceScreen(),
    'Messeges' : MainScreen(index: 1,),
    'Profile' : MainScreen(index: 2,),
  };

  TextEditingController _searchController = TextEditingController();
  List <String> _filteredData = [];
  bool _isSearching = false;

  @override
  void initState() {
    listMap.forEach((key, value) {
      _filteredData.add(key);
    });
    super.initState();
  }

  void filterSearchResults(String query) {
    List <String> dummySearchList = [];
    listMap.forEach((key, value) {
      dummySearchList.add(key);
    });
    if (query.isNotEmpty) {
      List <String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filteredData.clear();
        _filteredData.addAll(dummyListData);
        _isSearching = true;
      });
      return;
    } else {
      setState(() {
        _filteredData.clear();
        listMap.forEach((key, value) {
          _filteredData.add(key);
        });
      });
    }
    setState(() {
      if (query == "") {
        _isSearching = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kPrimaryColor 
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin\nHome page',
                  style: Theme.of(context).textTheme.titleLarge,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kPrimaryLight,
                    ),
                    child: IconButton(onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => LoginPage()));
                    }, 
                    icon: Icon(Icons.logout_outlined,
                    color: Colors.white,
                    )),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Container(
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                    color: Colors.grey,
                    size: 26,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Search here',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        _isSearching ? SizedBox(
                height: MediaQuery.of(context).size.height / 1,
                child: Card(
                  elevation: 10,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.separated(
                      itemCount: _filteredData.length,
                      itemBuilder: (context, index) {
                        String item = _filteredData[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                            builder: (context) => listMap[item]));
                          },
                          child: ListTile(
                            title: Text(item),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    ),
                  ),
                ),
              ) : SizedBox(height: 0,),
      ],
    );
  }
}