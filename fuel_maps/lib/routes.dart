import 'package:flutter/material.dart';
import 'package:fuel_maps/pages/profile/profile_view.dart';

import 'blocs/app/app_bloc.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [ProfileView.page()];
    case AppStatus.unauthenticated:
      return [Login.page()];
  }
}
