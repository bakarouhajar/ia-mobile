import 'package:flutter/material.dart';
import 'package:ia_pour_le_mobile/model/activity.dart';

class ActivityTemplate extends StatelessWidget {
  final Activity activity;

  ActivityTemplate({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Add elevation for a shadow effect
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(
          activity.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location: ${activity.location}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Date: ${activity.date}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Time: ${activity.time}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Category: ${activity.category}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Description: ${activity.description}',
              style: TextStyle(fontSize: 14),
            ),
            // Add more fields as needed

            // Display image if available
            if (activity.image != null && activity.image.isNotEmpty) 
              Image.network(
                activity.image,
                height: 100, // Adjust the height as needed
                width: double.infinity, // Take the full width
                fit: BoxFit.cover, // Adjust the image fit
              ),
          ],
        ),
        // Customize as needed based on your Activity model
        // For example, you can add more information like date, time, etc.
      ),
    );
  }
}
