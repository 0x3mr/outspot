import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/widgets/app_state_widgets.dart';
import '../../../data/repositories/spot_provider.dart';
import '../widgets/spot_feed_list.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SpotProvider>().loadSpots();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SpotProvider>();
    if (provider.isLoading && provider.spots.isEmpty) {
      return const AppLoadingIndicator(label: 'Loading spots');
    }
    if (provider.error != null && provider.spots.isEmpty) {
      return AppErrorState(
        message: 'Your spots could not be loaded.',
        onRetry: () => context.read<SpotProvider>().loadSpots(),
      );
    }
    return SpotFeedList(spots: provider.spots);
  }
}
