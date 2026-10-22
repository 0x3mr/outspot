import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outspot/core/widgets/app_loading_indicator.dart';
import 'package:outspot/core/widgets/app_state_widgets.dart';
import 'package:outspot/core/widgets/app_tag_chip.dart';
import 'package:outspot/core/widgets/app_text_field.dart';

void main() {
  testWidgets('loading state shows progress and its label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppLoadingIndicator(label: 'Loading spots')),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading spots'), findsOneWidget);
  });

  testWidgets('empty and error states support recovery actions', (
    tester,
  ) async {
    var emptyActionCalled = false;
    var retryCalled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppEmptyState(
            title: 'Nothing here',
            message: 'Try adding a spot.',
            actionLabel: 'Add spot',
            onAction: () => emptyActionCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('Nothing here'), findsOneWidget);
    await tester.tap(find.text('Add spot'));
    expect(emptyActionCalled, isTrue);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppErrorState(
            message: 'Could not load spots.',
            onRetry: () => retryCalled = true,
          ),
        ),
      ),
    );
    expect(find.text('Something went wrong'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    expect(retryCalled, isTrue);
  });

  testWidgets('required input errors appear beside the field', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: const AppTextField(label: 'Caption', validator: _required),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('This field is required'), findsOneWidget);
  });

  testWidgets('tag chip reports selection changes', (tester) async {
    var selected = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AppTagChip(
              label: 'Outdoors',
              selected: selected,
              onSelected: (value) => setState(() => selected = value),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Outdoors'));
    await tester.pump();
    expect(selected, isTrue);
  });

  testWidgets('submit button disables while unavailable or submitting', (
    tester,
  ) async {
    var submitCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AppSubmitButton(
                label: 'Publish',
                enabled: false,
                onPressed: () => submitCount++,
              ),
              AppSubmitButton(
                label: 'Publishing',
                isSubmitting: true,
                onPressed: () => submitCount++,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Publish'), warnIfMissed: false);
    expect(submitCount, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

String? _required(String? value) =>
    value == null || value.trim().isEmpty ? 'This field is required' : null;
