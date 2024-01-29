import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iris_app/interfaces/cadastro.dart';
import 'package:iris_app/l10n/l10n.dart';
import 'package:iris_app/provider/locale-provider.dart';

import 'firebase/firebase_control_page.dart';
import 'firebase/firebase_options.dart';
import 'interfaces/menu.dart';

import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import './interfaces/loading.dart';
import './interfaces/configuracao.dart';
import './interfaces/configuracao.dart';
import './interfaces/login.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light, 
    systemNavigationBarColor: Color(0xFFddd9e0),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Iris',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFdba0ff),
              )),
          debugShowCheckedModeBanner: false,
          
          locale: provider.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],

          // home: UserLogin(),
          home: const Menu(),

          // TODO(mafra): verificar erro de login
          //Login desabilitado por estar com erro
          // home: const MainPage(),
        );
      }
    )
  );
}
