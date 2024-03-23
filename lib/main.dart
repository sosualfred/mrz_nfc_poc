import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrz_nfc_poc/camera_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HelloScreen extends StatefulWidget {
  const HelloScreen({super.key});

  @override
  State<HelloScreen> createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen> {
  static const platform = MethodChannel('com.example.mrz_nfc_poc/hello');

// Get battery level.
  String _platformHello = '-';

  Future<void> _getPlatformHello() async {
    String platformHello;
    try {
      final result = await platform.invokeMethod<String>('getPlatformHello');
      platformHello = 'Platform hello: $result';
    } on PlatformException catch (e) {
      platformHello = 'Failed to get platformHello: ${e.message}';
    }

    setState(() {
      _platformHello = platformHello;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPlatformHello();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_platformHello),
            ElevatedButton(
              onPressed: _getPlatformHello,
              child: const Text('Get Platform Hello'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                );
              },
              child: const Text('MRZ Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelloScreen()),
                );
              },
              child: const Text('Platform Channel Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
