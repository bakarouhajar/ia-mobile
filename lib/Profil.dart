import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  String name = '';
  DateTime? birthDate;
  String address = '';
  String postalCode = '';
  String city = '';
  String profilePictureBase64 = '';
  String height = '';
  String weight = '';

  @override
  void initState() {
    super.initState();
    // Load user information when the widget is initialized
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      // Get the current user's email
      String? email = user?.email;

      if (email != null) {
        // Get the user's document from the 'utilisateurs' collection
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await db.collection('utilisateurs').doc(email).get();

        if (userDoc.exists) {
          // If the document exists, update the user information
          Map<String, dynamic> data = userDoc.data()!;
          setState(() {
            name = data['name'];
            birthDate = data['birthDate']?.toDate();
            address = data['address'] ?? '';
            postalCode = data['postalCode'] ?? '';
            city = data['city'] ?? '';
            profilePictureBase64 = data['profilePicture'] ?? '';
            height = data['height'] ?? '';
            weight = data['weight'] ?? '';
            // Chargez le mot de passe depuis les informations de l'utilisateur si vous le stockez côté client
          });
        }
      }
    } catch (e) {
      print('Error loading user information: $e');
    }
  }

  Future<void> _pickProfilePicture() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Convert the picked image to base64
      List<int> imageBytes = await pickedFile.readAsBytes();
      String base64String = base64Encode(Uint8List.fromList(imageBytes));

      // Update the profile picture state
      setState(() {
        profilePictureBase64 = base64String;
      });

      // Save the profile picture to the database
      _saveProfilePictureToDB(base64String);
    }
  }

  Future<void> _saveProfilePictureToDB(String base64String) async {
    try {
      String? email = user?.email;

      if (email != null) {
        // Update the user's document in the 'utilisateurs' collection
        await db.collection('utilisateurs').doc(email).update({
          'profilePicture': base64String,
        });
      }
    } catch (e) {
      print('Error saving profile picture to the database: $e');
    }
  }

  Future<void> _pickBirthDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        birthDate = date;

        // Save the birthdate to the database
        _saveBirthDateToDB(date);
      });
    }
  }

  Future<void> _saveBirthDateToDB(DateTime date) async {
    try {
      String? email = user?.email;

      if (email != null) {
        // Update the user's document in the 'utilisateurs' collection
        await db.collection('utilisateurs').doc(email).update({
          'birthDate': date,
        });
      }
    } catch (e) {
      print('Error saving birthdate to the database: $e');
    }
  }

  Future<void> _saveUserInfoToDB() async {
    try {
      String? email = user?.email;

      if (email != null) {
        // Update the user's document in the 'utilisateurs' collection
        await db.collection('utilisateurs').doc(email).update({
          'address': address,
          'postalCode': postalCode,
          'city': city,
          // Vous pouvez également mettre à jour le mot de passe ici si vous le stockez côté client
        });
      }
    } catch (e) {
      print('Error saving user information to the database: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Expanded(
              child: Text(
                'SocHub',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
        backgroundColor: const Color(0xFF603F8B),
        elevation: 0, // Remove the app bar shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your profil' , style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF603F8B),
              ),),
            InkWell(
              onTap: _pickProfilePicture,
              child: CircleAvatar(
                radius: 80,
                backgroundImage: profilePictureBase64.isNotEmpty
                    ? MemoryImage(Uint8List.fromList(
                        base64Decode(profilePictureBase64))) as ImageProvider
                    : const AssetImage('assets/default_profile_image.png'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: $name',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 77, 66, 92),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Birthdate: ${birthDate?.day}/${birthDate?.month}/${birthDate?.year}',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              'City: $city',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              'Postal Code: $postalCode',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              'Height: $height cm',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              'Weight: $weight kg',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _pickBirthDate();
            },
            child: const Icon(Icons.calendar_today),
          ),
          const SizedBox(height: 16),

          // Bouton pour sauvegarder les données
          FloatingActionButton(
            onPressed: () {
              _saveUserInfoToDB();
            },
            child: const Icon(Icons.save , color: Colors.green),
          ),
          const SizedBox(height: 16),

          // Bouton pour se déconnecter
          FloatingActionButton(
            onPressed: () {
              _signOut();
            },
            child: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
