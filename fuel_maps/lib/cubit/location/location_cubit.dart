import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationInitial());

  void updateLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission.name == "denied" || permission.name == "deniedForever" || permission.name == "unableToDetermine") {
        permission = await Geolocator.requestPermission();
      }
      final LatLng newLatLng = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((value) => LatLng(value.latitude, value.longitude));
      emit(LocationFetched(newLatLng: newLatLng));
    } catch (e) {
      emit(const LocationError());
    }
  }
}
