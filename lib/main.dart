import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_nearest_address/config/theme.dart';
import 'package:sample_nearest_address/presentation/features/main_screen/addresses.dart';
import 'package:sample_nearest_address/presentation/features/main_screen/addresses_bloc.dart';
import 'package:sample_nearest_address/presentation/features/splash_screen.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'locator.dart' as service_locator;

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() async {
  BlocOverrides.runZoned(
          () async {
  service_locator.init();

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.colorPrimaryDark,
  ));


  runApp(
      BlocProvider(
        create: (context) =>
        AddressesBloc()..add(const ShowAddressListEvent()),

        child:
      const MyApp(),
    ),
  );

},
blocObserver: SimpleBlocDelegate(),
);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: MyAppTheme.of(context),
      routes: _registerRoutes(),
    );
  }
}

Map<String, WidgetBuilder> _registerRoutes() {
  return <String, WidgetBuilder>{
    TestAppRoutes.splash: (context) => SplashScreen(),
    TestAppRoutes.main: (context) => const AddressListView(),
  };
}
