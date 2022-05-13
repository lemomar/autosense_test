import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_maps/cubits/stations/stations_cubit.dart';
import 'package:fuel_maps/pages/map/station_edit_dialog.dart';
import 'package:fuel_maps/shared/shared.dart';

import '../../blocs/app/app_bloc.dart';
import '../../models/models.dart';

class StationDetailsDialog extends StatelessWidget {
  const StationDetailsDialog({Key? key, required this.station}) : super(key: key);

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DialogTitle(
                station.name,
                actions: [
                  IconButton(
                    onPressed: context.read<AppBloc>().state.status == AppStatus.authenticated
                        ? () {
                            context.read<StationsCubit>().deleteStation(station);
                            Navigator.pop(context);
                          }
                        : null,
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                  IconButton(
                      onPressed: context.read<AppBloc>().state.status == AppStatus.authenticated
                          ? () => showDialog(
                                context: context,
                                builder: (context) => StationEditDialog(
                                  longitude: station.longitude,
                                  latitude: station.latitude,
                                  station: station,
                                ),
                              )
                          : null,
                      disabledColor: Theme.of(context).colorScheme.primary.withOpacity(.3),
                      icon: const Icon(Icons.edit))
                ],
              ),
              DialogSubtitle("Address: ${station.address}, ${station.city}"),
              PumpListView(station: station),
            ],
          ),
        ),
      ),
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        child: const Text("Edit"),
      ),
    );
  }
}

class PumpListView extends StatelessWidget {
  const PumpListView({
    Key? key,
    required this.station,
  }) : super(key: key);

  final Station station;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => PumpListTile(pump: station.pumps[index]),
      itemCount: station.pumps.length,
    );
  }
}

class PumpListTile extends StatelessWidget {
  const PumpListTile({Key? key, required this.pump}) : super(key: key);
  final Pump pump;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: pump.available ? const Icon(Icons.check) : const Icon(Icons.close),
      enabled: pump.available,
      title: Text(
        pump.fuelType,
      ),
      subtitle: Text(
        "Price: ${pump.price} CHF",
      ),
    );
  }
}
