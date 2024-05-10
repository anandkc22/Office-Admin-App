import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/home/main_screen.dart';
import 'package:office_administrator_app/screens/tile%20items/manage%20departments/department_tile.dart';

class ManageDepartmentScreen extends StatefulWidget {
  const ManageDepartmentScreen({super.key});

  @override
  State<ManageDepartmentScreen> createState() => _ManageDepartmentScreenState();
}

class _ManageDepartmentScreenState extends State<ManageDepartmentScreen> {

  TextEditingController _departmentController = TextEditingController();
  var collection = FirebaseFirestore.instance.collection("departments");
  late List<Map<String, dynamic>> items;
  String departmentID = "";
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

  addDepartment() async {

    String department = _departmentController.text.trim();

    try {
      if (department.isNotEmpty) {
        await FirebaseFirestore.instance.collection('departments')
        .doc(department)
        .set({
          "name" : department,
          "usercount" : 0,
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageDepartmentScreen()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Department added successfully.')),
        );
      }
      else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageDepartmentScreen()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong. Please try again..')),
        );
      }
      _departmentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again..')),
      );
    }
  }

  dynamic _showAddDepartmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Enter department name",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextField(
                controller: _departmentController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey
                    )
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey
                    )
                  )
                ),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _departmentController.clear();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minWidth: 100,
                    height: 50,
                    color: kPrimaryColor,
                    textColor: Colors.white,
                    child: Text('Cancel'),
                  ),
                MaterialButton(
                    onPressed: addDepartment,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minWidth: 100,
                    height: 50,
                    color: kPrimaryColor,
                    textColor: Colors.white,
                    child: Text('Add'),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage departments',
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
              Container(
                child: TextButton.icon(onPressed: _showAddDepartmentDialog, 
                icon: Icon(Icons.add,
                size: 25,
                color: Colors.black,
                ),
                label: Text("Add department",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),),),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height - 125,
                  child: isLoaded? ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap:  () {
                        departmentID = items[index]['name'];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DepartmentTile(departmentID: departmentID)));
                      },
                      leading: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          child: Image.asset('assets/icons/building.png', fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(items[index]['name']),
                      subtitle: Text(items[index]['usercount'].toString()+" employees"),
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