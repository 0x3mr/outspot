import 'package:flutter/material.dart';

import '../../core/navigation/app_routes.dart';

class FeaturePlaceholderScreen extends StatelessWidget {
  const FeaturePlaceholderScreen({
    super.key,
    required this.title,
    this.message,
  });

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const DrawerHeader(child: Text('Outspot')),
              for (final entry in AppRoutes.titles.entries)
                ListTile(
                  title: Text(entry.value),
                  selected: ModalRoute.of(context)?.settings.name == entry.key,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, entry.key);
                  },
                ),
            ],
          ),
        ),
      ),
      body: Center(child: Text(message ?? '$title screen')),
    );
  }
}
