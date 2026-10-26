import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_state_widgets.dart';
import '../../../core/widgets/app_tag_chip.dart';
import '../../../core/widgets/app_text_field.dart';

class CreateSpotDetailsScreen extends StatefulWidget {
  const CreateSpotDetailsScreen({super.key});

  @override
  State<CreateSpotDetailsScreen> createState() =>
      _CreateSpotDetailsScreenState();
}

class _CreateSpotDetailsScreenState extends State<CreateSpotDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _captionController = TextEditingController();
  final _selectedTags = <String>{};
  String? _feedback;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coordinates = ModalRoute.of(context)?.settings.arguments as LatLng?;

    return Scaffold(
      appBar: AppBar(title: const Text('Add spot details')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.page,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    coordinates != null
                        ? 'Selected (${coordinates.latitude.toStringAsFixed(4)}°, ${coordinates.longitude.toStringAsFixed(4)}°)'
                        : 'Downtown Cairo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Caption',
              hintText: 'What should people know about this place?',
              controller: _captionController,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Add a caption for your spot'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Add a few tags',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final tag in const ['Cafe', 'Outdoors', 'Food', 'Quiet'])
                  AppTagChip(
                    label: tag,
                    selected: _selectedTags.contains(tag),
                    onSelected: (selected) => setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppSubmitButton(
              label: 'Preview spot',
              enabled: _captionController.text.trim().isNotEmpty,
              onPressed: _preview,
            ),
            if (_feedback != null) ...[
              const SizedBox(height: AppSpacing.sm),
              AppInlineValidationMessage(message: _feedback!),
            ],
          ],
        ),
      ),
    );
  }

  void _preview() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _feedback = 'Your spot is ready for the next step.');
  }
}
