part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState({this.locationFetchFailed = true, this.latLng});
  final LatLng? latLng;
  final bool locationFetchFailed;

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial() : super();
}

class LocationFetched extends LocationState {
  const LocationFetched({required this.newLatLng}) : super(latLng: newLatLng);
  final LatLng newLatLng;
}

class LocationError extends LocationState {
  const LocationError() : super(locationFetchFailed: true, latLng: null);
}
