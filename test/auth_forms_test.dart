import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:outspot/core/navigation/app_routes.dart';
import 'package:outspot/features/auth/auth_validators.dart';
import 'package:outspot/features/auth/screens/register_screen.dart';

void main() {
  group('AuthValidators', () {
    test('email requires a well-formed address', () {
      expect(AuthValidators.email(''), 'Enter your email address');
      expect(AuthValidators.email('maya'), 'Enter a valid email address');
      expect(
        AuthValidators.email('maya@outspot'),
        'Enter a valid email address',
      );
      expect(AuthValidators.email(' maya@outspot.app '), isNull);
    });

    test('username allows 3-20 letters, numbers, and underscores', () {
      expect(AuthValidators.username(''), 'Choose a username');
      expect(AuthValidators.username('ab'), isNotNull);
      expect(AuthValidators.username('has space'), isNotNull);
      expect(AuthValidators.username('a' * 21), isNotNull);
      expect(AuthValidators.username('maya_42'), isNull);
    });

    test('new passwords need a minimum length and a matching confirmation', () {
      expect(AuthValidators.newPassword(''), 'Enter a password');
      expect(AuthValidators.newPassword('short'), 'Use at least 8 characters');
      expect(AuthValidators.newPassword('long-enough'), isNull);
      expect(
        AuthValidators.confirmPassword('other', 'long-enough'),
        'Passwords do not match',
      );
      expect(
        AuthValidators.confirmPassword('long-enough', 'long-enough'),
        isNull,
      );
    });

    test('sign-in password only needs to be present', () {
      expect(AuthValidators.signInPassword(''), 'Enter your password');
      expect(AuthValidators.signInPassword('x'), isNull);
    });
  });

  group('Sign in form', () {
    testWidgets('empty submit shows required-field errors', (tester) async {
      await tester.pumpWidget(_authApp(isRegistering: false));

      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pump();

      expect(find.text('Enter your email address'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('malformed email is rejected', (tester) async {
      await tester.pumpWidget(_authApp(isRegistering: false));

      await tester.enterText(_field('Email'), 'maya-at-outspot');
      await tester.enterText(_field('Password'), 'secret');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pump();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('password is obscured by default and can be revealed', (
      tester,
    ) async {
      await tester.pumpWidget(_authApp(isRegistering: false));

      expect(_isObscured(tester, 'Password'), isTrue);
      await tester.tap(find.byTooltip('Show password'));
      await tester.pump();
      expect(_isObscured(tester, 'Password'), isFalse);
      await tester.tap(find.byTooltip('Hide password'));
      await tester.pump();
      expect(_isObscured(tester, 'Password'), isTrue);
    });

    testWidgets('repeated submit taps only sign in once', (tester) async {
      var feedOpened = 0;
      await tester.pumpWidget(
        _authApp(isRegistering: false, onFeedOpened: () => feedOpened++),
      );

      await tester.enterText(_field('Email'), 'maya@outspot.app');
      await tester.enterText(_field('Password'), 'secret');
      final submit = find.widgetWithText(FilledButton, 'Sign in');
      await tester.tap(submit);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(FilledButton), warnIfMissed: false);
      await tester.pump(RegisterScreen.mockSubmitDelay);
      await tester.pumpAndSettle();

      expect(feedOpened, 1);
      expect(find.text('Feed stub'), findsOneWidget);
    });

    testWidgets('links to registration', (tester) async {
      await tester.pumpWidget(_authApp(isRegistering: false));

      await tester.tap(find.text('New to Outspot? Create an account'));
      await tester.pump();

      expect(find.text('Join Outspot'), findsOneWidget);
      expect(_field('Username'), findsOneWidget);
      expect(_field('Confirm password'), findsOneWidget);
    });
  });

  group('Registration form', () {
    testWidgets('empty submit shows required-field errors', (tester) async {
      await tester.pumpWidget(_authApp());

      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await tester.pump();

      expect(find.text('Enter your name'), findsOneWidget);
      expect(find.text('Choose a username'), findsOneWidget);
      expect(find.text('Enter your email address'), findsOneWidget);
      expect(find.text('Enter a password'), findsOneWidget);
      expect(find.text('Confirm your password'), findsOneWidget);
    });

    testWidgets('short and mismatched passwords are rejected', (tester) async {
      await tester.pumpWidget(_authApp());

      await tester.enterText(_field('Password'), 'short');
      await tester.enterText(_field('Confirm password'), 'shorter');
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await tester.pump();

      expect(find.text('Use at least 8 characters'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('both password fields start obscured', (tester) async {
      await tester.pumpWidget(_authApp());

      expect(_isObscured(tester, 'Password'), isTrue);
      expect(_isObscured(tester, 'Confirm password'), isTrue);
    });

    testWidgets('valid details continue to the feed', (tester) async {
      await tester.pumpWidget(_authApp());

      await tester.enterText(_field('Name'), 'Maya Hassan');
      await tester.enterText(_field('Username'), 'maya_h');
      await tester.enterText(_field('Email'), 'maya@outspot.app');
      await tester.enterText(_field('Password'), 'long-enough');
      await tester.enterText(_field('Confirm password'), 'long-enough');
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await tester.pump(RegisterScreen.mockSubmitDelay);
      await tester.pumpAndSettle();

      expect(find.text('Feed stub'), findsOneWidget);
    });

    testWidgets('links back to sign in', (tester) async {
      await tester.pumpWidget(_authApp());

      await tester.tap(find.text('Already have an account? Sign in'));
      await tester.pump();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(_field('Username'), findsNothing);
    });
  });
}

Widget _authApp({bool isRegistering = true, VoidCallback? onFeedOpened}) =>
    MaterialApp(
      onGenerateInitialRoutes: (_) => [
        MaterialPageRoute<void>(
          builder: (_) => RegisterScreen(isRegistering: isRegistering),
        ),
      ],
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.feed) onFeedOpened?.call();
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const Scaffold(body: Text('Feed stub')),
        );
      },
    );

Finder _field(String label) => find.widgetWithText(TextFormField, label);

bool _isObscured(WidgetTester tester, String label) => tester
    .widget<TextField>(
      find.descendant(of: _field(label), matching: find.byType(TextField)),
    )
    .obscureText;
