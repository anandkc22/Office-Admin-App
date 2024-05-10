import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/screens/home/main_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool passwordVisibility = true;
  String? profilePhoto;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  _fetch() async {

    try {
      var fireBaseUser = await FirebaseAuth.instance.currentUser;

      if (fireBaseUser != null) {
        DocumentSnapshot<Map<String, dynamic>> profile = await FirebaseFirestore.instance
            .collection("admins")
            .doc(fireBaseUser.uid)
            .get();
      
        if (profile.exists) {
          setState(() {
            profilePhoto = profile.data()?['image'];
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again..')),
      );  
    }
  }

  Future<void> updateUser() async {
    
  final userName = _usernameController.text.trim();
  final password = _passwordController.text.trim();

  if (userName.isNotEmpty || password.isNotEmpty) {

    try {
      final fireBaseUser = FirebaseAuth.instance.currentUser;
      
      if (password.isNotEmpty) {
        await fireBaseUser?.updatePassword(password);
      }

      if (userName.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('admins')
            .doc(fireBaseUser?.uid)
            .update({
          'username': userName,
        });
      }
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(index: 2,)));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User profile updated successfully')),
      );

    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user profile.')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No changes made to user profile')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit profile',
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
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
              SizedBox(height: 15,),
              Padding(
                padding: EdgeInsets.all(10),
                child:  Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [CircleAvatar(
                              backgroundImage: profilePhoto != null ? NetworkImage(profilePhoto!) : NetworkImage('https://pasrc.princeton.edu/sites/g/files/toruqf431/files/styles/freeform_750w/public/2021-03/blank-profile-picture-973460_1280.jpg?itok=QzRqRVu8'),
                              radius: 75,
                            ),
                            Positioned(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.circular(50),
                                  color: kPrimaryColor,
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    ImagePicker picker = ImagePicker();
                                    XFile? file = await picker.pickImage(source: ImageSource.gallery);

                                    var fireBaseUser = await FirebaseAuth.instance.currentUser;

                                    Reference referenceRoot = FirebaseStorage.instance.ref();
                                    Reference referenceDirImages = referenceRoot.child('profiles');

                                    Reference referenceImageToUpload = referenceDirImages.child(fireBaseUser!.uid);

                                    try {
                                      await referenceImageToUpload.putFile(File(file!.path));
                                      
                                      String imageURL = await referenceImageToUpload.getDownloadURL();
                                      
                                      FirebaseFirestore.instance.collection('admins')
                                      .doc(fireBaseUser.uid)
                                      .update({
                                      "image" : imageURL,
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Profile photo updated sccessfully.')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error uploading profile photo.')),
                                      );
                                    }
                                  }, 
                                  icon: Icon(Icons.add_a_photo,
                                  color: Colors.white,)),
                              ),
                                bottom: 0,
                                left: 100,
                                )]
                          ),
                        ),
                        SizedBox(height: 15,),
                        inputField(label: 'Name', controller: _usernameController),
                        inputFieldPassword(label: 'Password', controller: _passwordController),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            cancelButton(),
                            confirmButton(),
                          ],
                        )
                      ],
                    ),
              ),
              ],
            ),
          ),
        ),
    );
}
  Widget cancelButton() {
    return Padding(
                padding: EdgeInsets.only(top: 3, left: 3),
                child: Container(
                  width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black
                  )
                ),
                child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                height: 60,
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text('Cancel',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                color: Colors.black
              ),
            ),
          ),
        ),
    );
  }

Widget confirmButton() {
    return Padding(
              padding: EdgeInsets.only(top: 3, left: 3),
              child: Container(
                width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kPrimaryColor
              ),
              child: MaterialButton(
              onPressed: updateUser,
              height: 60,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text('Save',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

Widget inputField({label, controller})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),
      ),
      SizedBox(height: 5,),
      TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10
          ),
        ),
      ),
      SizedBox(height: 10,),
    ],
  );
}

Widget inputFieldPassword({label, controller})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),
      ),
      SizedBox(height: 5,),
      TextField(
        controller: controller,
        obscureText: passwordVisibility,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10
          ),
          suffixIcon: IconButton(
            color: kPrimaryColor,
            onPressed: _togglePasswordView, 
            icon: Icon(
              passwordVisibility ? Icons.visibility_off : Icons.visibility,
            ))
        ),
      ),
      SizedBox(height: 10,),
    ],
  );
}

void _togglePasswordView() {
    setState(() {
      passwordVisibility = !passwordVisibility;
    });
  }
}
