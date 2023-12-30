import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ia_pour_le_mobile/Activity.dart';
import 'package:ia_pour_le_mobile/ActivitiesTemplate.dart';
import 'package:ia_pour_le_mobile/ActivityForm.dart';
import 'package:ia_pour_le_mobile/Profil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Set<String> favoriteProductIds =
      <String>{}; // Track favorite products for the user

  @override
  void initState() {
    super.initState();
    loadFavoriteProducts();

    // Fetch unique category values
    db.collection('activities').get().then((snapshot) {
      Set<String> uniqueCategories = {};
      for (var doc in snapshot.docs) {
        uniqueCategories.add(doc['category'] as String);
      }
      categoryValues = uniqueCategories.toList();
    });
  }

  Future<void> loadFavoriteProducts() async {
    try {
      // Get the current user's email
      String userEmail = user?.email ?? '';

      // Get the user's document from the 'favoris' collection
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('favoris').doc(userEmail).get();

      if (userDoc.exists) {
        // If the document exists, update the set of favorite product IDs
        Map<String, dynamic> data = userDoc.data()!;
        favoriteProductIds = Set<String>.from(data.keys);
      }
    } catch (e) {
      print('Error loading favorite products: $e');
    }
  }

  Future<void> toggleFavorite(String activityId) async {
    try {
      // Get the current user's email
      String userEmail = user?.email ?? '';

      if (favoriteProductIds.contains(activityId)) {
        // Product is already in favorites, remove it
        await db.collection('favoris').doc(userEmail).update({
          activityId: FieldValue.delete(),
        });

        // Update the set of favorite product IDs
        setState(() {
          favoriteProductIds.remove(activityId);
        });

        _showSuccessPopup(context, 'Activité retirée des favoris.');
      } else {
        // Product is not in favorites, add it
        await db.collection('favoris').doc(userEmail).set({
          activityId: true,
        }, SetOptions(merge: true));

        // Update the set of favorite product IDs
        setState(() {
          favoriteProductIds.add(activityId);
        });

        _showSuccessPopup(context, 'Activité ajoutée aux favoris.');
      }
    } catch (e) {
      _showErrorPopup(
          context, 'Erreur lors de la mise à jour des favoris : $e');
    }
  }

  Stream<QuerySnapshot> filteredActivitiesStream =
      FirebaseFirestore.instance.collection('activities').snapshots();

  Future<void> deleteActivity(String activityId) async {
    try {
      await db.collection('activities').doc(activityId).delete();
      _showSuccessPopup(context, 'Activité supprimé avec succès.');
    } catch (e) {
      _showErrorPopup(context, 'Erreur lors de la suppression du activity : $e');
    }
  }

  void _showSuccessPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Succès'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAddForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Ajouter une activité'),
          ),
          body: AddActivityForm(
            onAdd: (newActivity) async {
              await db.collection('activities').add(newActivity.toJson());
              Navigator.pop(context); // Close the form page when done
            },
          ),
        ),
      ),
    );
  }

  void _showProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserProfile(), // Replace UserProfile with your profile page
      ),
    );
  }

  int _currentIndex = 0;
  List<String> categoryValues = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1 + categoryValues.length, // 1 for 'All' + categories count
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'SocHub',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF643C8C),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                } catch (e) {
                  print('Error during logout: $e');
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              color: Colors.redAccent,
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                } catch (e) {
                  print('Error during logout: $e');
                }
              },
            ),
          ],
          bottom: TabBar(
            labelColor: const Color.fromARGB(255, 214, 178, 212),
            unselectedLabelColor: Colors.white,
            tabs: [
              const Tab(text: 'All'),
              for (String category in categoryValues) Tab(text: category),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: filteredActivitiesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Une erreur est survenue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Activity> activities = snapshot.data!.docs
                    .map((doc) => Activity.fromFirestore(doc))
                    .toList();
                return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) => ActivityItem(
                    activity: activities[index],
                    onToggleFavorite: (activityId) => toggleFavorite(activityId),
                    favoriteActivityIds: favoriteProductIds,
                  ),
                );
              },
            ),
            for (String category in categoryValues)
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('activities')
                    .where('category', isEqualTo: category)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Une erreur est survenue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<Activity> activities = snapshot.data!.docs
                      .map((doc) => Activity.fromFirestore(doc))
                      .toList();
                  return ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) => ActivityItem(
                      activity: activities[index],
                      onToggleFavorite: (activityId) =>
                          toggleFavorite(activityId),
                      favoriteActivityIds: favoriteProductIds,
                    ),
                  );
                },
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.pink.shade400,
          unselectedItemColor: const Color(0xFF643C8C),
          selectedFontSize: 16,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 1) {
                _showAddForm(
                    context); // Show the add dialog when "Ajout" is tapped
              } else if (_currentIndex == 2) {
                _showProfile(
                    context); // Show the profile page when "Profil" is tapped
              }
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              label: 'Activités',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ajout',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  void filterActivitiesByCategory(String category) {
    setState(() {
      if (category == 'All') {
        filteredActivitiesStream =
            FirebaseFirestore.instance.collection('activities').snapshots();
      } else {
        filteredActivitiesStream = FirebaseFirestore.instance
            .collection('activities')
            .where('category', isEqualTo: category)
            .snapshots();
      }
    });
  }
}
