import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_maps/routes.dart';

import '../../blocs/app/app_bloc.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlowBuilder(
      state: context.select((AppBloc element) => element.state.status),
      onGeneratePages: onGenerateAppViewPages,
    );
  }
}
