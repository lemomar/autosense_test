part of 'stations_cubit.dart';

enum StationsFetchStatus { success, loading, error }

class StationsState extends Equatable {
  const StationsState({
    required this.status,
    this.stations,
  });

  final StationsFetchStatus status;
  final List<Station>? stations;

  @override
  List<Object> get props => [status, stations ?? []];
}

class StationsInitial extends StationsState {
  const StationsInitial() : super(status: StationsFetchStatus.loading);
}

class StationsError extends StationsState {
  const StationsError() : super(status: StationsFetchStatus.error);
}

class StationsLoaded extends StationsState {
  const StationsLoaded(this.newStations)
      : super(
          status: StationsFetchStatus.loading,
          stations: newStations,
        );
  final List<Station> newStations;
}
