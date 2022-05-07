import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuel_maps/models/station/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../cubits/cubits.dart';

class MapScreen extends HookWidget {
  const MapScreen({Key? key, required this.controller}) : super(key: key);

  final ValueNotifier<Completer<GoogleMapController>> controller;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<LocationCubit>().updateLocation();
      return null;
    }, const []);

    final location = context.watch<LocationCubit>().state;

    if (location.locationFetchFailed) {
      return const Center(
        child: Text("An error occured"),
      );
    }

    return location.latLng != null
        ? GoogleMap(
            onMapCreated: ((c) => controller.value.complete(c)),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: sampleStationList.map((station) => station.toMarker()).toSet(),
            initialCameraPosition: CameraPosition(
              zoom: 8,
              target: location.latLng!,
            ),
          )
        : const Center(
            child: Text("Loading"),
          );
  }
}
