import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/user/user_main_screen.dart';

class UserDepartment extends StatefulWidget {
  const UserDepartment({super.key});

  @override
  State<UserDepartment> createState() => _UserDepartmentState();
}

class _UserDepartmentState extends State<UserDepartment> {

  var currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> userItems = [];
  var userCollection = FirebaseFirestore.instance.collection("users");
  String departmentName = "No departments yet";
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  _incrementCounter() async {

    try {
      var data = await userCollection.doc(currentUser?.uid).get();
      if (data.data()!['department'] != null) {
        setState(() {
          departmentName = data.data()?["department"];
        });
      }

      if (departmentName != "No departments yet") {
        List<Map<String, dynamic>> tempList = [];
        var data = await userCollection.get();
        data.docs.forEach((element) {
          if (element.data()['department'] == departmentName) {
            tempList.add(element.data());
          }
        });
        setState(() {
          userItems = tempList;
          isLoaded = true;
        });
      }

      else {
        setState(() {
          isLoaded = true;
        });
      }

    } catch (e) {
      print(e);
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
          title: Text(departmentName,
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
              builder: (context) => UserMainScreen(index: 0,)));
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
              SizedBox(height: 15,),
              userItems.isNotEmpty ? Text("Members",
              style: TextStyle(
                fontSize: 22,
                color: kPrimaryColor
              ),) : Text("You are not assigned to any department yet."),
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