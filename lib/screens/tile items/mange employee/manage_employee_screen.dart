import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/home/main_screen.dart';
import 'package:office_administrator_app/screens/tile%20items/mange%20employee/employee_tile.dart';

class ManageEmployeeScreen extends StatefulWidget {
  const ManageEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<ManageEmployeeScreen> createState() => _ManageEmployeeScreenState();
}

class _ManageEmployeeScreenState extends State<ManageEmployeeScreen> {
  
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage employees',
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
                                        builder: (context) => EmployeeTile(
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
                              subtitle: items[index]['userjob'] != null
                                  ? Text(items[index]['userjob'])
                                  : Text("Job not specified"),
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