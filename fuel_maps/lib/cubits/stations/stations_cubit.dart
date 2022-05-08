import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

part 'stations_state.dart';

class StationsCubit extends Cubit<StationsState> {
  StationsCubit() : super(const StationsInitial()) {
    fetchStations();
  }

  void fetchStations() async {
    try {
      final Response response = await Dio().get("http://localhost:3000/");
      if (response.statusCode != 200) throw Exception();
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response.data["stations"]);
      final List<Station> stations = data.map(Station.fromJson).toList();
      emit(StationsLoaded(stations));
    } catch (_) {
      emit(const StationsError());
    }
  }
}
