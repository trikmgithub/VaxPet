import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vaxpet/core/constant/enviroment.dart';
import 'package:vaxpet/presentation/splash/bloc/splash_cubit.dart';
import 'package:vaxpet/presentation/splash/pages/splash.dart';
import 'package:vaxpet/service_locator.dart';
import 'core/configs/theme/app_theme.dart';

Future<void> main() async {
  await dotenv.load(
    fileName: Environment.fileName,
  );
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: const SplashPage(),
        // Add localization support
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('vi', 'VN'), // Vietnamese
        ],
        locale: const Locale(
          'vi',
          'VN',
        ), // Set Vietnamese as the default locale
      ),
    );
  }
}
