import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userCountry;

  const ProfileScreen({
    Key? key,
    required this.userEmail,
    required this.userName,
    required this.userCountry,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();

Future getImage() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: getImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                child: _image != null
                    ? ClipOval(
                        child: Image.file(
                          _image!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text(
                        widget.userName.substring(0, 1), // Display first letter of the name
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${widget.userName}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${widget.userEmail}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Country: ${widget.userCountry}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      userName: widget.userName,
                      userCountry: widget.userCountry,
                    ),
                  ),
                );
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userCountry;

  const EditProfileScreen({
    Key? key,
    required this.userName,
    required this.userCountry,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _editedName;
  late String _editedCountry;

  @override
  void initState() {
    super.initState();
    _editedName = widget.userName;
    _editedCountry = widget.userCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _editedName,
              onChanged: (value) {
                setState(() {
                  _editedName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: _editedCountry,
              onChanged: (value) {
                setState(() {
                  _editedCountry = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Country',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save changes and update profile info in the backend
                // Then navigate back to the profile screen
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
