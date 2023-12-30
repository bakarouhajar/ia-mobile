import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String id;
  String titre;
  String lieu;
  double prix;
  String description;
  String date;
  String time;
  String category;
  String image;
  int nombreMinimumPersonnes; // New attribute

  Activity({
    required this.id,
    required this.titre,
    required this.lieu,
    required this.prix,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    required this.image,
    required this.nombreMinimumPersonnes, // New attribute
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Activity(
      id: doc.id,
      titre: data['titre'],
      lieu: data['lieu'],
      prix: data['prix'].toDouble(),
      description: data['description'],
      date: data['date'],
      time: data['time'],
      category: data['category'],
      image: data['image'],
      nombreMinimumPersonnes: data['nombreMinimumPersonnes'], // New attribute
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'lieu': lieu,
      'prix': prix,
      'description': description,
      'date': date,
      'time': time,
      'category': category,
      'image': image,
      'nombreMinimumPersonnes': nombreMinimumPersonnes, // New attribute
    };
  }
}
