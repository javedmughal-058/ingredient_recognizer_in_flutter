import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('User Profile', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
