import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ia_pour_le_mobile/model/activity.dart';

class ActivityService {
  final CollectionReference activities =
      FirebaseFirestore.instance.collection('Activity');

  Stream<List<Activity>> getActivities() {
    return activities.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Activity(
          name: data['name'],
          description: data['description'],
          date: data['date'],
          time: data['time'],
          location: data['location'],
          category: data['category'],
          image: data['image'],
        );
      }).toList();
    });
  }

  Future<void> addActivity(String name, String description, String date,
      String time, String location, String category, String image) {
    return activities.add({
      'name': name,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'category': category,
      'image': image,
    });
  }
}