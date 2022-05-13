import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuel_maps/blocs/app/app_bloc.dart';

import '../../cubits/cubits.dart';
import '../../models/models.dart';
import '../../shared/shared.dart';

class StationEditDialog extends HookWidget {
  StationEditDialog({
    Key? key,
    Station? station,
    required this.longitude,
    required this.latitude,
  })  : station = station ?? Station.empty,
        super(key: key);

  final Station station;
  final double longitude;
  final double latitude;

  @override
  Widget build(BuildContext context) {
    final stationIdController = useTextEditingController(text: station.id);
    final stationNameController = useTextEditingController(text: station.name);
    var pumpListener = useState([...station.pumps]);

    void updatePump(int? index, Pump pump) {
      if (index == null) {
        pumpListener.value = [...pumpListener.value, pump];
      } else {
        pumpListener.value[index] = pump;
      }
    }

    useEffect(() {
      stationIdController.addListener(() {});
      stationNameController.addListener(() {});
      return () {
        stationNameController.removeListener(() {});
        stationIdController.removeListener(() {});
      };
    }, [stationIdController.text, stationNameController.text, pumpListener.value]);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              children: [
                DialogTitle(
                  station == Station.empty ? "New Station" : "Edit Station",
                  actions: titleTrailingIcons(
                    context,
                    stationIdController,
                    stationNameController,
                    pumpListener,
                  ),
                ),
                const DialogSubtitle("The station will be created at the location where you placed the marker."),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Station ID",
                        ),
                        controller: stationIdController,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: stationNameController,
                        decoration: const InputDecoration(
                          labelText: "Station Name",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          "Pumps",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      ...pumpListener.value.map(
                        (Pump pump) => ListTile(
                          leading: const Icon(Icons.local_gas_station),
                          title: Text(
                            "${pump.fuelType} (${pump.available ? 'Available' : 'Unavailable'})",
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "Pump ID: ${pump.id}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            "${pump.price} CHF",
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => showPumpEditDialog(
                            context,
                            pump,
                            updatePump,
                            index: pumpListener.value.indexOf(pump),
                          ),
                        ),
                      ),
                      Center(
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => showPumpEditDialog(
                            context,
                            Pump.empty,
                            updatePump,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> titleTrailingIcons(BuildContext context, TextEditingController stationIdController,
      TextEditingController stationNameController, ValueNotifier<List<Pump>> pumpListener) {
    return [
      IconButton(
        onPressed: () {
          context.read<StationsCubit>().deleteStation(station);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete),
      ),
      IconButton(
        onPressed: () {
          final stationsState = context.read<StationsCubit>();
          final appState = context.read<AppBloc>();
          final Station newStation = Station(
            id: stationIdController.text,
            creatorId: appState.state.user.id,
            name: stationNameController.text,
            pumps: pumpListener.value,
            city: station.city,
            address: station.address,
            longitude: longitude,
            latitude: latitude,
          );
          if (station == Station.empty) {
            stationsState.createStation(newStation);
            Navigator.pop(context);
            return;
          }
          stationsState.updateStation(newStation);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.check),
      ),
    ];
  }

  Future<dynamic> showPumpEditDialog(BuildContext context, Pump pump, void Function(int? index, Pump pump) updatePump,
      {int? index}) {
    return showDialog(
      context: context,
      builder: (context) => PumpEdit(
        index: index,
        pump: pump,
        onSave: updatePump,
      ),
    );
  }
}

class PumpEdit extends HookWidget {
  const PumpEdit({Key? key, required this.pump, required this.onSave, this.index}) : super(key: key);
  final Pump pump;
  final int? index;
  final void Function(int? index, Pump pump) onSave;

  @override
  Widget build(BuildContext context) {
    final pumpIdController = useTextEditingController(text: pump.id.toString());
    final pumpPriceController = useTextEditingController(text: pump.price.toString());
    final pumpFuelTypeController = useTextEditingController(text: pump.fuelType);
    final availabilityListener = useState(pump.available);

    useEffect(() {
      pumpIdController.addListener(() {});
      pumpPriceController.addListener(() {});
      pumpFuelTypeController.addListener(() {});

      return () {
        pumpIdController.removeListener(() {});
        pumpIdController.removeListener(() {});
        pumpFuelTypeController.removeListener(() {});
      };
    }, [pumpIdController.text, pumpPriceController.text, pumpFuelTypeController.text, availabilityListener.value]);

    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitle(
                "New Pump",
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  IconButton(
                    onPressed: () {
                      onSave(
                        index,
                        Pump(
                          available: availabilityListener.value,
                          id: int.parse(pumpIdController.text),
                          price: double.parse(pumpPriceController.text),
                          fuelType: pumpFuelTypeController.text,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                  )
                ],
              ),
              ListView(shrinkWrap: true, children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Pump ID"),
                  controller: pumpIdController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Fuel Type"),
                  controller: pumpFuelTypeController,
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  controller: pumpPriceController,
                ),
                const SizedBox(height: 12.0),
                ListTile(
                  title: const Text("Pump is available"),
                  trailing: Checkbox(
                    onChanged: (_) => availabilityListener.value = !availabilityListener.value,
                    value: availabilityListener.value,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    ));
  }
}
