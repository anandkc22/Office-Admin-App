import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/tile%20items/manage%20departments/department_tile.dart';

class RemoveEmployeeToDepartment extends StatefulWidget {
  final String departmentID;
  const RemoveEmployeeToDepartment({super.key, required this.departmentID});

  @override
  State<RemoveEmployeeToDepartment> createState() => _RemoveEmployeeToDepartmentState();
}

class _RemoveEmployeeToDepartmentState extends State<RemoveEmployeeToDepartment> {
  var collection = FirebaseFirestore.instance.collection("users");
  late List<Map<String, dynamic>> items;
  String uid = "";
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
        if (element.data()['department'] == widget.departmentID) {
          tempList.add(element.data());
        }
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
  
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Remove employees',
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
              builder: (context) => DepartmentTile(departmentID: widget.departmentID,)));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height - 125,
                  child: isLoaded? ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap:  () {
                        uid = items[index]['uid'];
                         RemoveAlertBox(context, items[index]['username'], widget.departmentID, uid);
                      },
                      leading: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          child: items[index]['image'] != null ? Image.network(items[index]['image']!, fit: BoxFit.cover) : Image.network('https://pasrc.princeton.edu/sites/g/files/toruqf431/files/styles/freeform_750w/public/2021-03/blank-profile-picture-973460_1280.jpg?itok=QzRqRVu8',fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(items[index]['username']),
                      subtitle: items[index]['department'] != null ? Text(items[index]['department']) : Text("No department"),
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
  dynamic RemoveAlertBox(BuildContext context, String username, String department, String userID) {
  return showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title: Text("Remove $username from $department department",
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
          child: MaterialButton(onPressed: () async {
            try {
              if (userID.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userID)
                    .update({
                  'department': null,
                });
              }
              
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Something went wrong. Please try again..')),
              );
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => RemoveEmployeeToDepartment(departmentID: widget.departmentID,)));
          },
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
          ),
          minWidth: 100,
          height: 50,
          color: kPrimaryColor,
          textColor: Colors.white, 
          child: Text('Remove')),
        )
          ],
        )
      ],
    );
  }
  );
}
}