part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  LocationState({this.locationFetchFailed = true, this.latLng});
  final LatLng? latLng;
  bool locationFetchFailed;

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {
  LocationInitial() : super();
}

class LocationFetched extends LocationState {
  LocationFetched({required this.newLatLng}) : super(latLng: newLatLng);
  final LatLng newLatLng;
}

class LocationError extends LocationState {
  LocationError() : super(locationFetchFailed: true, latLng: null);
}
