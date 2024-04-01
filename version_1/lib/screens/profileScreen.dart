import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'loginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  String? _fullName;
  String? _email;
  String? _country;
  String? _gender;
  DateTime? _dob;
  String? _profileImageUrl;

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('UsersData')
            .doc(currentUser!.email)
            .get();

    setState(() {
      _fullName = userSnapshot.data()!['fullname'];
      _email = currentUser!.email;
      _country = userSnapshot.data()!['country'];
      _gender = userSnapshot.data()!['gender'];
      _dob = userSnapshot.data()!['dob']?.toDate();
      _profileImageUrl = userSnapshot.data()!['profileImageUrl'];

      _fullNameController.text = _fullName ?? '';
      _countryController.text = _country ?? '';
      _genderController.text = _gender ?? '';
      _dobController.text = _dob != null ? _formatDate(_dob!) : '';
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _updateProfile() async {
    await FirebaseFirestore.instance
        .collection('UsersData')
        .doc(currentUser!.email)
        .update({
      'fullname': _fullNameController.text,
      'country': _countryController.text,
      'gender': _genderController.text,
      'dob': _dob,
      'profileImageUrl': _profileImageUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile Updated Successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        backgroundImage:
            _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
        child: _profileImageUrl == null
            ? Icon(Icons.add_photo_alternate, size: 50)
            : null,
      ),
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.single.path;

      if (filePath != null) {
        File imageFile = File(filePath);
        Uint8List bytes = await imageFile.readAsBytes();

        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profile_images/${currentUser!.uid}');
        UploadTask uploadTask = ref.putData(bytes);

        // Listen to the upload state changes
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          if (snapshot.state == TaskState.success) {
            // Once upload is successful, get the download URL
            ref.getDownloadURL().then((url) {
              setState(() {
                // Update the profile image URL
                _profileImageUrl = url;
              });
            }).catchError((error) {
              print('Failed to get download URL: $error');
            });
          }
        });

        // // Handle upload errors
        // uploadTask.catchError((error) {
        //   print('Upload failed: $error');
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              _buildProfileImage(),
              SizedBox(height: 20),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _fullNameController,
              ),
              SizedBox(height: 20),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(_email ?? 'No Email Found'),
              SizedBox(height: 20),
              Text(
                'Country',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _countryController,
              ),
              SizedBox(height: 20),
              Text(
                'Gender',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _genderController,
              ),
              SizedBox(height: 20),
              Text(
                'Date of Birth',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _dobController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dob ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null && pickedDate != _dob) {
                    setState(() {
                      _dob = pickedDate;
                      _dobController.text = _formatDate(_dob!);
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),

              // Logout
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(onTap: null),
                    ),
                  );
                },
                child: Text('Logout'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
