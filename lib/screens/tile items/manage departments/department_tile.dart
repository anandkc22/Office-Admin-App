import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/tile%20items/manage%20departments/add_employees.dart';
import 'package:office_administrator_app/screens/tile%20items/manage%20departments/manage_department_screen.dart';
import 'package:office_administrator_app/screens/tile%20items/manage%20departments/remove_employee.dart';

class DepartmentTile extends StatefulWidget {
  final String departmentID;
  const DepartmentTile({super.key, required this.departmentID});

  @override
  State<DepartmentTile> createState() => _DepartmentTileState();
}

class _DepartmentTileState extends State<DepartmentTile> {

  var userCollection = FirebaseFirestore.instance.collection("users");
  List<Map<String, dynamic>> userItems = [];
  TextEditingController _departmentController = TextEditingController();
  var collection = FirebaseFirestore.instance.collection("departments");
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  _incrementCounter() async {

    try {
      List<Map<String, dynamic>> tempList = [];

      var data = await userCollection.get();
      data.docs.forEach((element) {
        if (element.data()['department'] == widget.departmentID) {
          tempList.add(element.data());
        }
      });
      setState(() {
        userItems = tempList;
        isLoaded = true;
      });

      await FirebaseFirestore.instance
          .collection('departments')
          .doc(widget.departmentID)
          .update({
          'usercount': userItems.length,
        });

    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again..')),
      );
    }
  }

  renameDepartment() async {

    String department = _departmentController.text.trim();

    try {
      if (department.isNotEmpty) {
        await FirebaseFirestore.instance.collection('departments')
        .doc(department)
        .set({
          "name" : department,
        });
      
      userItems.forEach((element) async {
          if (element["uid"].isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(element["uid"])
                    .update({
                  'department': department,
                });
              }
        });
              
        await FirebaseFirestore.instance.collection('departments')
        .doc(widget.departmentID)
        .delete();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DepartmentTile(departmentID: department,)));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Department name changed successfully')),
        );
      }
      else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DepartmentTile(departmentID: department,)));
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

  deleteDepartment() async {

     try {
      await FirebaseFirestore.instance.collection('departments')
      .doc(widget.departmentID)
      .delete();
      
      userItems.forEach((element) async {
        if (element["uid"].isNotEmpty) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(element["uid"])
                  .update({
                'department': null,
              });
            }
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageDepartmentScreen()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Department deleted')),
      );

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
            "Enter new name",
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
                    onPressed: renameDepartment,
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
          title: Text(widget.departmentID,
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
              builder: (context) => ManageDepartmentScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: TextButton.icon(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmployeeToDepartment(departmentID: widget.departmentID,)));
                    }, 
                    icon: Icon(Icons.add,
                    color: Colors.black,
                    size: 13,
                    ),
                    label: Text("Add",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black
                    ),),),
                  ),
                  Container(
                    child: TextButton.icon(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RemoveEmployeeToDepartment(departmentID: widget.departmentID,)));
                    }, 
                    icon: Icon(Icons.remove_circle_outline,
                    color: Colors.black,
                    size: 13,
                    ),
                    label: Text("Remove",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12
                    ),),),
                  ),
                  Container(
                    child: TextButton.icon(onPressed: _showAddDepartmentDialog, 
                    icon: Icon(Icons.edit,
                    color: Colors.black,
                    size: 13,
                    ),
                    label: Text("Rename",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12
                    ),),),
                  ),
                  Container(
                    child: TextButton.icon(onPressed: deleteDepartment, 
                    icon: Icon(Icons.delete,
                    color: Colors.black,
                    size: 13,
                    ),
                    label: Text("Delete",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12
                    ),),),
                  ),
                ],
              ),
              userItems.isNotEmpty ? Text("Members",
              style: TextStyle(
                fontSize: 22,
                color: kPrimaryColor
              ),) : Text(""),
              SizedBox(
                  height: MediaQuery.of(context).size.height - 125,
                  child: isLoaded? ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: userItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap:  () {},
                      leading: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          child: userItems[index]['image'] != null ? Image.network(userItems[index]['image']!, fit: BoxFit.cover) : Image.network('https://pasrc.princeton.edu/sites/g/files/toruqf431/files/styles/freeform_750w/public/2021-03/blank-profile-picture-973460_1280.jpg?itok=QzRqRVu8',fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(userItems[index]['username']),
                      subtitle: userItems[index]['userjob'] != null ? Text(userItems[index]['userjob']) : Text("Job not specified"),
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