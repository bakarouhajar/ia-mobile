import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ia_pour_le_mobile/Activity.dart';

class ActivityItem extends StatelessWidget {
  final Activity activity;
  final Function(String) onToggleFavorite;
  final Set<String> favoriteActivityIds;

  const ActivityItem({
    super.key,
    required this.activity,
    required this.onToggleFavorite,
    required this.favoriteActivityIds,
  });

  @override
  Widget build(BuildContext context) {
    bool isFavorite = favoriteActivityIds.contains(activity.id);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: () {
          _showActivityDetails(context);
        },
        leading: Image.memory(
          base64Decode(activity.image),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(
          activity.titre,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          activity.lieu,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${activity.prix} €',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                onToggleFavorite(activity.id);
                print('Toggle favorites button pressed for ${activity.titre}');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showActivityDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            activity.titre,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF643C8C), // Choose your preferred title color
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(
                    base64Decode(activity.image),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text('Location: ${activity.lieu}', style: _getTextStyle()),
              Text('Price: ${activity.prix} €', style: _getTextStyle()),
              Text('Date: ${activity.date}', style: _getTextStyle()),
              Text('Time: ${activity.time}', style: _getTextStyle()),
              Text('Description: ${activity.description}',
                  style: _getTextStyle()),
              Text('Category: ${activity.category}', style: _getTextStyle()),
              // Add more details as needed
              Text(
                'Minimum Number of People: ${activity.nombreMinimumPersonnes}',
                style: _getTextStyle(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  TextStyle _getTextStyle() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.black87, // Choose your preferred text color
    );
  }
}
