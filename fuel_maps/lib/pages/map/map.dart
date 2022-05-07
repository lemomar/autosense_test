import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuel_maps/cubit/location/location_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends HookWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<LocationCubit>().updateLocation();
      return null;
    }, const []);
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return state.latLng != null
            ? GoogleMap(
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  zoom: 8,
                  target: state.latLng!,
                ),
              )
            : const Center(
                child: Text("Loading"),
              );
      },
    );
  }
}
