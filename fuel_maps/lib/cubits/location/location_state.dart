part of 'location_cubit.dart';

class LocationState extends Equatable {
  const LocationState({this.locationFetchFailed = false, this.currentCoordinates, this.newMarkerCoordinates});
  final LatLng? currentCoordinates;
  final bool locationFetchFailed;
  final LatLng? newMarkerCoordinates;

  LocationState copyWith({
    LatLng? currentCoordinates,
    LatLng? newMarkerCoordinates,
    bool? locationFetchFailed,
  }) {
    return LocationState(
      currentCoordinates: currentCoordinates ?? this.currentCoordinates,
      locationFetchFailed: locationFetchFailed ?? this.locationFetchFailed,
      newMarkerCoordinates: newMarkerCoordinates ?? this.newMarkerCoordinates,
    );
  }

  @override
  List<Object?> get props => [
        currentCoordinates,
        locationFetchFailed,
        newMarkerCoordinates,
      ];
}

class LocationInitial extends LocationState {
  const LocationInitial() : super();
}

class LocationFetched extends LocationState {
  LocationFetched(LocationState newState)
      : super(
          currentCoordinates: newState.currentCoordinates,
          locationFetchFailed: newState.locationFetchFailed,
          newMarkerCoordinates: newState.newMarkerCoordinates,
        );
}

class LocationError extends LocationState {
  const LocationError() : super(locationFetchFailed: true, currentCoordinates: null);
}
