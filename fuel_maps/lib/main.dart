import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuel_maps/blocs/app/app_bloc.dart';
import 'package:fuel_maps/firebase_options.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'cubits/cubits.dart';
import 'models/settings/settings.dart';
import 'pages/pages.dart';
import 'repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  if (!kIsWeb) {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  }
  Hive.registerAdapter(SettingsAdapter());
  await Hive.openBox<Settings>("settings");
  final AuthRepository authRepository = AuthRepository();
  runApp(FuelMaps(authRepository: authRepository));
}

class FuelMaps extends StatelessWidget {
  const FuelMaps({Key? key, authRepository})
      : _authRepository = authRepository,
        super(key: key);

  final AuthRepository _authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(authRepository: _authRepository),
          ),
          BlocProvider(
            create: (context) => LocationCubit(),
          ),
          BlocProvider(
            create: (_) => StationsCubit(),
          ),
        ],
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Settings>("settings").listenable(),
          builder: (context, Box<Settings> box, child) {
            final Settings settings = box.get("settings") ?? Settings();
            return MaterialApp(
              title: 'Fuel Maps',
              theme: settings.lightTheme,
              darkTheme: settings.darkTheme,
              themeMode: settings.getThemeMode(),
              home: AppView(
                title: "Fuel Maps",
                settings: settings,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppView extends HookWidget {
  AppView({
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
    final ValueNotifier<Completer<GoogleMapController>> mapController = useState(Completer());
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
      body: SafeArea(
        top: true,
        child: Center(
          child: IndexedStack(
            children: [
              MapScreen(controller: mapController),
              SwitchOnly(
                // counter: counter,
                settings: settings,
                navigatorKey: favoriteGlobalKey,
              ),
              const Profile(),
            ],
            index: bottomBarState.value,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButtons(
        counter: counter,
        mapController: mapController,
      ),
    );
  }
}

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({
    Key? key,
    required this.counter,
    required this.mapController,
  }) : super(key: key);

  final ValueNotifier<int> counter;
  final ValueNotifier<Completer<GoogleMapController>> mapController;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppBloc>().state;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (app.status == AppStatus.authenticated)
          FloatingActionButton(
            onPressed: () async {
              counter.value++;
              context.read<LocationCubit>().updateLocation();
              if (mapController.value.isCompleted) {
                final controller = await mapController.value.future;
                final mapState = context.read<LocationCubit>().state;
                controller.moveCamera(
                  CameraUpdate.newLatLng(
                    mapState.latLng!,
                  ),
                );
              }
            },
            tooltip: 'Add a station',
            child: const Icon(
              Icons.add_location_alt_outlined,
            ),
          ),
        const SizedBox(
          width: 12,
        ),
        FloatingActionButton(
          onPressed: () async {
            counter.value++;
            context.read<LocationCubit>().updateLocation();
            if (mapController.value.isCompleted) {
              final controller = await mapController.value.future;
              final mapState = context.read<LocationCubit>().state;
              controller.moveCamera(
                CameraUpdate.newLatLng(
                  mapState.latLng!,
                ),
              );
            }
          },
          tooltip: 'Locate',
          child: const Icon(Icons.location_pin),
        ),
      ],
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
                  builder: (context) => const Profile(),
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
                  builder: (context) => const Profile(),
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
                  builder: (context) => const Profile(),
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
    final Color bottomBarBackgroundColor = colorScheme.primary;
    final Color bottomBarSelectedColor = colorScheme.onPrimary;
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
