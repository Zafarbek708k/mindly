import 'package:flutter/material.dart';

class AchievementDetailsScreen extends StatelessWidget {
  const AchievementDetailsScreen({super.key, required this.achievementId});

  final String achievementId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Achievement Details')),
      body: Center(child: Text('Achievement ID: $achievementId')),
    );
  }
}
