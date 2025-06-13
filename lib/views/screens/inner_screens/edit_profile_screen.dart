import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uber_shop_app/controllers/auth_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneCotroller = TextEditingController();

  Uint8List? _newImage;
  String? _newImgUrl;
  bool _isLoading = false;

  _selectImageFromGalery() async {
    final Uint8List img =
        await _authController.pickProfileImage(ImageSource.gallery);
    setState(() {
      _newImage = img;
    });
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImageToStorage(Uint8List image) async {
    try {
      final Reference ref =
          _storage.ref().child('profile_images').child(_auth.currentUser!.uid);
      final UploadTask uploadTask = ref.putData(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('Error uploading image: $e.toString()');
      return '';
    }
  }

  Future<void> _populateController() async {
    User? user = _auth.currentUser;
    String? userFullName = '';
    String? userEmail = '';
    String? userPhoneNumber = '';

    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('buyers').doc(user.uid).get();
        userPhoneNumber = userDoc['phoneNumber'];
        userEmail = userDoc['email'];
        userFullName = userDoc['fullName'];
        _newImgUrl = userDoc['profileImage'];
      } catch (e) {
        debugPrint('--- Error by populating --- $e');
      }

      if (userFullName != null) {
        _nameController.text = userFullName;
      }
      if (userEmail != null) {
        _emailController.text = userEmail;
      }
      if (userPhoneNumber != null) {
        _phoneCotroller.text = userPhoneNumber;
      }
    }
  }

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;
    if (_newImage != null) {
      _newImgUrl = await _uploadImageToStorage(_newImage!);
    }

    try {
      if (user != null) {
        // await user.verifyBeforeUpdateEmail(_newEmail);
        // await user.updateDisplayName(_newFullName);
        // await user.updatePhotoURL(newImgUrl);

        await _firestore.collection('buyers').doc(user.uid).update({
          'email': _emailController.text,
          'fullName': _nameController.text,
          'phoneNumber': _phoneCotroller.text,
          'profileImage': _newImgUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')));
      }
    } catch (e) {
      debugPrint('--- Error by updating profile --- $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _populateController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.pink),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Stack(
              children: [
                _newImage != null
                    ? CircleAvatar(
                        radius: 65,
                        backgroundImage: MemoryImage(_newImage!),
                      )
                    : const CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.pink,
                        child:
                            Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.photo, color: Colors.white),
                      onPressed: () {
                        _selectImageFromGalery();
                      },
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a correct email!';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email, color: Colors.pink),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a correct name!';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person, color: Colors.pink),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _phoneCotroller,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number (optional)',
                prefixIcon: Icon(Icons.phone, color: Colors.pink),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _updateProfile();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
