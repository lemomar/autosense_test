import 'package:flutter/material.dart';
import 'package:fuel_maps/shared/shared.dart';

import '../../models/models.dart';

class StationDetails extends StatelessWidget {
  const StationDetails({Key? key, required this.station}) : super(key: key);

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
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
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
        pump.toString() + "CHF",
      ),
    );
  }
}
