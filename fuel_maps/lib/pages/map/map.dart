import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuel_maps/pages/map/new_station_modal.dart';
import 'package:fuel_maps/pages/map/station_modal.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../blocs/app/app_bloc.dart';
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

    final app = context.watch<AppBloc>();
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
    if (location.newMarkerCoordinates != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("newMarkerId"),
          draggable: true,
          position: location.newMarkerCoordinates!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      );
    }
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (app.state.status == AppStatus.authenticated)
            FloatingActionButton(
              onPressed: () async {
                if (location.newMarkerCoordinates == null) {
                  final GoogleMapController newController = await controller.value.future;
                  LatLngBounds visibleRegion = await newController.getVisibleRegion();
                  LatLng centerLatLng = LatLng(
                    (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
                    (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) / 2,
                  );
                  context.read<LocationCubit>().updateNewMarkerCoordinates(
                        centerLatLng,
                      );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => NewStationModal(
                      latitude: location.newMarkerCoordinates!.latitude,
                      longitude: location.newMarkerCoordinates!.longitude,
                    ),
                  );
                }
              },
              tooltip: 'Add a station',
              child: location.newMarkerCoordinates == null
                  ? const Icon(Icons.add_location_alt_outlined)
                  : const Icon(Icons.check),
            ),
          const SizedBox(
            width: 12,
          ),
          FloatingActionButton(
            onPressed: () async {
              context.read<LocationCubit>().updateLocation();
              if (controller.value.isCompleted) {
                final newController = await controller.value.future;
                final mapState = context.read<LocationCubit>().state;
                newController.animateCamera(
                  CameraUpdate.newLatLng(
                    mapState.currentCoordinates!,
                  ),
                );
              }
            },
            tooltip: 'Locate',
            child: const Icon(Icons.location_pin),
          ),
        ],
      ),
      body: location.currentCoordinates != null
          ? GoogleMap(
              onMapCreated: ((c) => controller.value.complete(c)),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: markers,
              initialCameraPosition: CameraPosition(
                zoom: 1,
                target: location.currentCoordinates!,
              ),
              onTap: (LatLng newMarkerCoordinates) =>
                  context.read<LocationCubit>().updateNewMarkerCoordinates(newMarkerCoordinates),
            )
          : const Center(
              child: Text("Loading"),
            ),
    );
  }
}
