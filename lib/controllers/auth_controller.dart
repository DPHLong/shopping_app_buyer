import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  final FirebaseStorage _storageService = FirebaseStorage.instance;

  // Select image from gallery
  pickProfileImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        return await image.readAsBytes();
      } else {
        debugPrint('No image selected');
        return null;
      }
    } catch (e) {
      debugPrint('Error picking image: $e.toString()');
      return null;
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImageToStorage(Uint8List image) async {
    try {
      final Reference ref = _storageService
          .ref()
          .child('profile_images')
          .child(_authService.currentUser!.uid);
      final UploadTask uploadTask = ref.putData(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('Error uploading image: $e.toString()');
      return '';
    }
  }

  // Create a new user
  Future<String> createNewUser(
    String email,
    String password,
    String fullName,
    String? phoneNumber,
    Uint8List? image,
  ) async {
    String res = 'error';

    try {
      final UserCredential userCredential =
          await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (image != null) {
        final String imageUrl = await _uploadImageToStorage(image);
        await _firestoreService
            .collection('buyers')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'fullName': fullName,
          'buyerId': userCredential.user!.uid,
          'phoneNumber': phoneNumber,
          'profileImage': imageUrl,
        });
      } else {
        await _firestoreService
            .collection('buyers')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'fullName': fullName,
          'buyerId': userCredential.user!.uid,
        });
      }

      res = 'success';
    } catch (e) {
      res = e.toString();
      debugPrint('Error creating user: $e.toString()');
    }
    return res;
  }

  // Login user
  Future<String> loginUser(String email, String password) async {
    String res = 'error';

    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = 'success';
    } catch (e) {
      res = e.toString();
      debugPrint('Error signing in: $e.toString()');
    }
    return res;
  }

  bool isUserLoggedIn() {
    var isLoggedIn = false;
    final currentUser = _authService.currentUser;
    _authService.authStateChanges().listen((user) {
      if (currentUser == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
      }
    });
    return isLoggedIn;
  }
}
