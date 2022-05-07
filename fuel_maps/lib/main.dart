import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'models/settings/settings.dart';
import 'pages/pages.dart';

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

class MyHomePage extends HookWidget {
  MyHomePage({
    Key? key,
    required this.title,
    required this.settings,
  }) : super(key: key);

  final String title;
  final Settings settings;

  final GlobalKey mapGlobalKey = GlobalKey<NavigatorState>();
  final GlobalKey favoriteGlobalKey = GlobalKey<NavigatorState>();
  final GlobalKey profileGlobalKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final counter = useState(0);
    final bottomBarState = useState(0);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // final Color bottomBarUnselectedColor = isDark ? colorScheme.onSecondary : colorScheme.onPrimary;
    // final Color bottomBarActiveColor = isDark ? colorScheme.secondary : colorScheme.primary;
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        isDark: isDark,
        colorScheme: colorScheme,
        bottomBarState: bottomBarState,
      ),
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: IndexedStack(
          children: [
            CounterAndSwitch(
              counter: counter,
              settings: settings,
              navigatorKey: mapGlobalKey,
            ),
            CounterOnly(
              counter: counter,
              navigatorKey: favoriteGlobalKey,
            ),
            SwitchOnly(
              settings: settings,
              navigatorKey: profileGlobalKey,
            ),
          ],
          index: bottomBarState.value,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterOnly extends StatelessWidget {
  const CounterOnly({
    Key? key,
    required this.counter,
    required this.navigatorKey,
  }) : super(key: key);

  final ValueNotifier<int> counter;

  final GlobalKey navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (context) => MaterialPageRoute(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MapScreen(),
                ),
              ),
              child: const Text("Navigate"),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchOnly extends StatelessWidget {
  const SwitchOnly({
    Key? key,
    required this.settings,
    required this.navigatorKey,
  }) : super(key: key);

  final Settings settings;

  final GlobalKey navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (context) => MaterialPageRoute(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Change theme:',
            ),
            Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (isDarkModeActive) => settings.changeThemeMode(isDarkModeActive),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MapScreen(),
                ),
              ),
              child: const Text("Navigate"),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterAndSwitch extends StatelessWidget {
  const CounterAndSwitch({
    Key? key,
    required this.counter,
    required this.settings,
    required this.navigatorKey,
  }) : super(key: key);

  final ValueNotifier<int> counter;
  final Settings settings;
  final GlobalKey navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (context) => MaterialPageRoute(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (isDarkModeActive) => settings.changeThemeMode(isDarkModeActive),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MapScreen(),
                ),
              ),
              child: const Text("Navigate"),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    Key? key,
    required this.isDark,
    required this.colorScheme,
    required this.bottomBarState,
  }) : super(key: key);

  final bool isDark;
  final ColorScheme colorScheme;
  final ValueNotifier<int> bottomBarState;

  @override
  Widget build(BuildContext context) {
    final Color bottomBarBackgroundColor = isDark ? colorScheme.secondary : colorScheme.primary;
    final Color bottomBarSelectedColor = isDark ? colorScheme.onSecondary : colorScheme.onPrimary;
    return Container(
      decoration: BoxDecoration(
        color: bottomBarBackgroundColor,
      ),
      child: SalomonBottomBar(
        currentIndex: bottomBarState.value,
        onTap: (int index) => bottomBarState.value = index,
        selectedItemColor: bottomBarSelectedColor,
        unselectedItemColor: bottomBarSelectedColor.withOpacity(.4),
        items: [
          SalomonBottomBarItem(
            title: const Text('Map'),
            icon: const Icon(Icons.location_on_rounded),
          ),
          SalomonBottomBarItem(
            title: const Text('Favorite'),
            icon: const Icon(Icons.favorite_outline_rounded),
          ),
          SalomonBottomBarItem(
            title: const Text('Profile'),
            icon: const Icon(Icons.person_rounded),
          ),
        ],
      ),
    );
  }
}
