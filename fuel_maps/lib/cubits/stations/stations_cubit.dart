import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

part 'stations_state.dart';

class StationsCubit extends Cubit<StationsState> {
  StationsCubit() : super(const StationsInitial()) {
    fetchStations();
  }

  void _updateStations(Response response) {
    try {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(response.data["stations"]);
      final List<Station> stations = data.map(Station.fromJson).toList();
      emit(state.copyWith(stations: stations));
    } catch (e) {
      print(e);
    }
  }

  void fetchStations() async {
    try {
      emit(state.copyWith(status: StationsFetchStatus.loading));
      final Response response = await Dio().get("http://100.104.208.24:3000/");
      _updateStations(response);
    } catch (_) {
      emit(const StationsError());
    }
  }

  void createStation(Station newStation) async {
    try {
      emit(state.copyWith(status: StationsFetchStatus.loading));
      final Response response = await Dio().post(
        "http://100.104.208.24:3000/new-station",
        data: {
          ...newStation.toJson(),
        },
        options: Options(headers: {"Accept": "application/json"}),
      );
      _updateStations(response);
    } catch (e) {
      print(e);
      fetchStations();
    }
  }

  void updateStation(Station newStation) async {
    try {
      emit(state.copyWith(status: StationsFetchStatus.loading));
      final Response response = await Dio().post(
        "http://100.104.208.24:3000/update-station",
        data: {
          ...newStation.toJson(),
        },
        options: Options(headers: {"Accept": "application/json"}),
      );
      _updateStations(response);
    } catch (_) {
      fetchStations();
    }
  }
}
