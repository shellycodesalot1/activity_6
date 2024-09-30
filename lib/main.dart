import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

// Step 1: Define the Counter class
class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));

    // Get the current screen information
    getCurrentScreen().then((screen) {
      if (screen != null) {
        // Calculate the position to center the window on the screen
        final double left = (screen.frame.width - windowWidth) / 2;
        final double top = (screen.frame.height - windowHeight) / 2;
        final Rect frame = Rect.fromLTWH(left, top, windowWidth, windowHeight);

        // Set the window size and position
        setWindowFrame(frame);
      }
    });
  }
}

// Defining a custom blue color similar to the screenshot banner
const Color customBlue = Color(0xFF2196F3); // You can adjust this color to match the exact blue.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter',
      theme: ThemeData(
        primaryColor: customBlue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: customBlue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: customBlue,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<Counter>(
              builder: (context, counter, child) {
                return Text(
                  'I am ${counter.count} years old',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<Counter>().increment();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: customBlue, // Button color
              ),
              child: const Text(
                'Increase Age',
                style: TextStyle(color: Colors.white), // Set text color to white
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<Counter>().decrement();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: customBlue, // Button color
              ),
              child: const Text(
                'Reduce Age',
                style: TextStyle(color: Colors.white), // Set text color to white
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}