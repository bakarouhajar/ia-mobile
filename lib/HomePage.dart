import 'package:flutter/material.dart';
import 'package:ia_pour_le_mobile/model/activity.dart';
import 'package:ia_pour_le_mobile/service/ActivityService.dart';
import 'package:ia_pour_le_mobile/template/ActivitiesTemplate.dart';
import 'package:ia_pour_le_mobile/template/ActivityForm.dart';
import 'template/ActivitiesTemplate.dart'; // Import the ActivityTemplate widget

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  void openAddBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddBox(title: '',), // Use the AddBox widget here
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final ActivityService _activityService = ActivityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SocHub'),
      backgroundColor: Color(0xFF603F8B),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 1) {
              widget.openAddBox(context);
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
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
      body: _currentIndex == 0
          ? buildActivitiesList()
          : Container(), // Display content only on the "Activités" tab
    );
  }

  Widget buildActivitiesList() {
    return StreamBuilder<List<Activity>>(
      stream: _activityService.getActivities(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Activity> activities = snapshot.data!;

        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            return ActivityTemplate(activity: activities[index]);
          },
        );
      },
    );
  }
}
