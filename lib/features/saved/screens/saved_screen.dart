import 'package:flutter/material.dart';

import '../../../core/widgets/app_state_widgets.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) => const AppEmptyState(
    title: 'Your saved spots live here',
    message: 'Save places you want to come back to and they will show up here.',
    icon: Icons.bookmark_border,
  );
}
