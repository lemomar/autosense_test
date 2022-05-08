import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuel_maps/pages/map/station_modal.dart';
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
    final stationsState = context.watch<StationsCubit>().state;

    if (location.locationFetchFailed) {
      return const Center(
        child: Text("An error occured"),
      );
    }

    Set<Marker> markers = <Marker>{};
    if (stationsState.stations != null) {
      markers.addAll(stationsState.stations!
          .map(
            (station) => (station.toMarker()).copyWith(
              onTapParam: () => showDialog(
                context: context,
                builder: (context) => StationDetails(station: station),
              ),
            ),
          )
          .toList());
    }

    return location.latLng != null
        ? GoogleMap(
            onMapCreated: ((c) => controller.value.complete(c)),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: markers,
            initialCameraPosition: CameraPosition(
              zoom: 1,
              target: location.latLng!,
            ),
          )
        : const Center(
            child: Text("Loading"),
          );
  }
}
