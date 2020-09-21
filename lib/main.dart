import 'package:covid_tracker/homepage.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'datasource.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(CovidTracker());
}

class CovidTracker extends StatelessWidget {
  const CovidTracker({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(data: (brightness) {
      return ThemeData(
          fontFamily: 'OpenSans',
          primaryColor: primaryBlack,
          brightness: brightness == Brightness.light
              ? Brightness.light
              : Brightness.dark,
          scaffoldBackgroundColor: brightness == Brightness.dark
              ? Colors.blueGrey[900]
              : Colors.white);
    }, themedWidgetBuilder: (context, theme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: HomePage(),
      );
    });
  }
}
