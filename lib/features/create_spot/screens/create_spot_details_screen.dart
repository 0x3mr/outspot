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
  final _placeNameController = TextEditingController();
  final _captionController = TextEditingController();
  final _selectedTags = <String>{};
  static const int _maxCaptionLength = 280;
  String? _selectedPhoto;
  String? _feedback;

  @override
  void dispose() {
    _placeNameController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _pickFromCamera() {
    setState(() {
      _selectedPhoto = 'camera_photo.jpg';
      _feedback = null;
    });
  }

  void _pickFromGallery() {
    setState(() {
      _selectedPhoto = 'gallery_photo.jpg';
      _feedback = null;
    });
  }

  void _removePhoto() {
    setState(() {
      _selectedPhoto = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final coordinates = ModalRoute.of(context)?.settings.arguments as LatLng?;
    final captionLength = _captionController.text.length;

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
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Spot Photo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            _buildPhotoSection(context),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Place name',
              hintText: 'e.g. Sunrise Cafe or Rooftop Viewpoint',
              controller: _placeNameController,
              onChanged: (_) => setState(() {}),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Add a name for your spot'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Caption',
              hintText: 'What should people know about this place?',
              controller: _captionController,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Add a caption for your spot';
                }
                if (value.length > _maxCaptionLength) {
                  return 'Caption exceeds $_maxCaptionLength characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$captionLength / $_maxCaptionLength',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: captionLength > _maxCaptionLength
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Add a few tags',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final tag in const [
                  'Cafe',
                  'Outdoors',
                  'Food',
                  'Quiet',
                  'Views',
                ])
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
              enabled:
                  _captionController.text.trim().isNotEmpty &&
                  captionLength <= _maxCaptionLength,
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

  Widget _buildPhotoSection(BuildContext context) {
    if (_selectedPhoto != null) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  size: 52,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _selectedPhoto!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Photo ready to upload',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filledTonal(
                tooltip: 'Remove photo',
                icon: const Icon(Icons.close, size: 18),
                onPressed: _removePhoto,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'No photo selected yet',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            'Add a photo so others know what to expect',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickFromCamera,
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: const Text('Take Photo'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: const Text('Choose from Gallery'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _preview() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _feedback = 'Your spot is ready for the next step.');
  }
}
