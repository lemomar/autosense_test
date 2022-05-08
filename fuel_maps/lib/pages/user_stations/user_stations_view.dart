import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_maps/cubits/stations/stations_cubit.dart';
import 'package:fuel_maps/shared/shared.dart';

import '../map/station_edit_dialog.dart';

class UserStationsView extends StatelessWidget {
  const UserStationsView({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: UserStationsView());

  @override
  Widget build(BuildContext context) {
    final stations = context.select((StationsCubit cubit) => cubit.state.stations);
    return Scaffold(
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
            if (stations != null)
              ListView(
                shrinkWrap: true,
                children: [
                  ...stations.map(
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
