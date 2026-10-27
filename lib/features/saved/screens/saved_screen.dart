import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/widgets/app_state_widgets.dart';
import '../../../data/repositories/spot_repository.dart';
import '../../../models/spot.dart';
import '../../feed/widgets/spot_feed_list.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Future<List<Spot>> _savedSpots;

  @override
  void initState() {
    super.initState();
    _savedSpots = _load();
  }

  Future<List<Spot>> _load() => context.read<SpotRepository>().listSavedSpots();

  Future<void> _reload() {
    final savedSpots = _load();
    setState(() {
      _savedSpots = savedSpots;
    });
    return savedSpots;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Spot>>(
    future: _savedSpots,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const AppLoadingIndicator(label: 'Loading saved spots');
      }
      if (snapshot.hasError) {
        return AppErrorState(
          message: 'Your saved spots could not be loaded.',
          onRetry: _reload,
        );
      }
      final spots = snapshot.data ?? const <Spot>[];
      if (spots.isEmpty) {
        return const AppEmptyState(
          title: 'Your saved spots live here',
          message:
              'Tap Save on any spot to keep it here. Saved spots are only '
              'visible to you.',
          icon: Icons.bookmark_border,
        );
      }
      return RefreshIndicator(
        onRefresh: _reload,
        child: SpotFeedList(spots: spots),
      );
    },
  );
}
