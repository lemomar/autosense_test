import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

part 'stations_state.dart';

class StationsCubit extends Cubit<StationsState> {
  StationsCubit() : super(const StationsInitial()) {
    fetchStations();
  }

  void fetchStations() async {
    try {
      final List<Station> stations = await Future.delayed(const Duration(milliseconds: 400), () => sampleStationList);
      emit(StationsLoaded(stations));
    } catch (_) {
      emit(const StationsError());
    }
  }
}
