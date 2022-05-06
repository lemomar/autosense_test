import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'models/settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }
  Hive.registerAdapter(SettingsAdapter());
  await Hive.openBox<Settings>("settings");
  runApp(const FuelMaps());
}

class FuelMaps extends StatelessWidget {
  const FuelMaps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Settings>("settings").listenable(),
      builder: (context, Box<Settings> box, child) {
        final Settings settings = box.get("settings") ?? Settings();
        return MaterialApp(
          title: 'Fuel Maps',
          theme: settings.lightTheme,
          darkTheme: settings.darkTheme,
          themeMode: settings.getThemeMode(),
          home: MyHomePage(
            title: "Fuel Maps",
            settings: settings,
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.settings,
  }) : super(key: key);

  final String title;
  final Settings settings;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (isDarkModeActive) => widget.settings.changeThemeMode(isDarkModeActive),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
