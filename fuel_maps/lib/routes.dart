import 'package:flutter/material.dart';
import 'package:fuel_maps/pages/auth/auth.dart';
import 'package:fuel_maps/pages/user_stations/user_stations_view.dart';

import 'blocs/app/app_bloc.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [UserStationsView.page()];
    case AppStatus.unauthenticated:
      return [Auth.page()];
  }
}
