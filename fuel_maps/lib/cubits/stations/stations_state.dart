// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  List<Object> get props => [
        status,
        [...?stations],
      ];

  StationsState copyWith({
    StationsFetchStatus? status,
    List<Station>? stations,
  }) {
    return StationsState(
      status: status ?? this.status,
      stations: stations ?? this.stations,
    );
  }
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
          status: StationsFetchStatus.success,
          stations: newStations,
        );
  final List<Station> newStations;
}
