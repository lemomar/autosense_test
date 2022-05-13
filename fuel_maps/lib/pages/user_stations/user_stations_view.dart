import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_maps/blocs/app/app_bloc.dart';
import 'package:fuel_maps/cubits/cubits.dart';
import 'package:fuel_maps/models/station/station.dart';
import 'package:fuel_maps/shared/shared.dart';

import '../map/station_edit_dialog.dart';

class UserStationsView extends StatelessWidget {
  const UserStationsView({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: UserStationsView());

  void logout(BuildContext context) => context.read<AppBloc>().add(AppLogoutRequested());

  @override
  Widget build(BuildContext context) {
    final String userId = context.select((AppBloc appBloc) => appBloc.state.user.id);
    var stations = context.select((StationsCubit cubit) => cubit.state.stations);
    final stationsToDisplay = (stations ?? []).where((station) => station.creatorId == userId).toList();
    if (stations == null || stationsToDisplay.isEmpty) {
      return const EmptyStationList();
    }
    return StationsList(stationsToDisplay: stationsToDisplay);
  }
}

class EmptyStationList extends StatelessWidget {
  const EmptyStationList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.logout,
        ),
        tooltip: "Log out",
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Center(
              child: DialogTitle("Your stations"),
            ),
            DialogSubtitle(
              "You haven't created any stations so far. Feel free to browse the map and add as many as you want.",
            ),
          ],
        ),
      ),
    );
  }
}

class StationsList extends StatelessWidget {
  const StationsList({
    Key? key,
    required this.stationsToDisplay,
  }) : super(key: key);

  final List<Station> stationsToDisplay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.logout,
        ),
        tooltip: "Log out",
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogTitle(
              "Your stations",
            ),
            const DialogSubtitle(
              "Here are all the stations you have created up until now. Feel free to edit them from here or from the Map",
            ),
            ListView(
              shrinkWrap: true,
              children: [
                ...stationsToDisplay.map(
                  (station) => ListTile(
                    title: Text(station.name),
                    subtitle: Text("Address: ${station.address}, ${station.city}"),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => StationEditDialog(
                        longitude: station.longitude,
                        latitude: station.latitude,
                        station: station,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () => () => {},
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
