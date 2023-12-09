import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String name;
  final String description;
  final String date;
  final String time;
  final String location;
  final String category;
  final String image;

  Activity({
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.image,
  });
}