import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/user/user_edit_profile.dart';
import 'package:office_administrator_app/screens/user/user_main_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  String? userName, userJob, userEmail, profilePhoto;
  bool isLoaded = false;
  
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  _fetch() async {

    try {
      final fireBaseUser = FirebaseAuth.instance.currentUser;
      
      if (mounted) {
        setState(() {
          isLoaded = false;
        });
      }
      
      if (fireBaseUser != null) {
        final profile = await FirebaseFirestore.instance
            .collection("users")
            .doc(fireBaseUser.uid)
            .get();
      
        if (mounted) {
          setState(() {
            userEmail = profile.data()?['email'];
            userJob = profile.data()?['userjob'];
            userName = profile.data()?['username'];
            profilePhoto = profile.data()?['image'];
            isLoaded = true;
          });
        }
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
          title: Text('Profile',
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
              Padding(
                padding:EdgeInsets.all(10),
                child: isLoaded ? Column(
                children: [
                  Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(image: profilePhoto != null ? NetworkImage(profilePhoto!) : NetworkImage('https://pasrc.princeton.edu/sites/g/files/toruqf431/files/styles/freeform_750w/public/2021-03/blank-profile-picture-973460_1280.jpg?itok=QzRqRVu8'),
                    fit: BoxFit.cover
                    ),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 20,),
              ListTiles('Name', userName ?? '', Icons.person_2_outlined),
              SizedBox(height: 15,),
              ListTiles('Job', userJob ?? 'not specified', Icons.work_outline_outlined),
              SizedBox(height: 15,),
              ListTiles('Email', userEmail ?? '', Icons.email_outlined),
              SizedBox(height: 15,),
              ListTiles('Password', '********', Icons.security_outlined),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                  builder: (context) => UserEditProfile()));
                  }, 
                  child: Text('Edit profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                  ),
                ),
              )
                ],
              ) : SizedBox(child: Center(child: CircularProgressIndicator(color: Colors.black,)),height: 600,),
              ),
              ],
            ),
          ),
        ),
    );
  }

  Container ListTiles(String title, String subtitle, IconData icondata) {
    return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 4.0,
                    spreadRadius: .05
                  )
                ], 
              ),
              child: ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                leading: Icon(icondata,
                size: 30,),
                trailing: Icon(Icons.arrow_forward),
              ),
            );
  }
}