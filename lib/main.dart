import 'package:azul_envato_checker/azul_envato_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mbark_iptv/repository/api/api.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wakelock/wakelock.dart';

import 'helpers/helpers.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/categories/channels/channels_bloc.dart';
import 'logic/blocs/categories/live_caty/live_caty_bloc.dart';
import 'logic/blocs/categories/movie_caty/movie_caty_bloc.dart';
import 'logic/blocs/categories/series_caty/series_caty_bloc.dart';
import 'logic/cubits/favorites/favorites_cubit.dart';
import 'logic/cubits/settings/settings_cubit.dart';
import 'logic/cubits/video/video_cubit.dart';
import 'logic/cubits/watch/watching_cubit.dart';
import 'presentation/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Wakelock.enable();
  await GetStorage.init();
  await GetStorage.init("favorites");
  MobileAds.instance.initialize();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://c02f199280584f7fac1c049965f25427@o4504351469404160.ingest.sentry.io/4504351471435776';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp(
      iptv: IpTvApi(),
      authApi: AuthApi(),
      watchingLocale: WatchingLocale(),
      favoriteLocale: FavoriteLocale(),
    )),
  );
}

class MyApp extends StatefulWidget {
  final IpTvApi iptv;
  final AuthApi authApi;
  final WatchingLocale watchingLocale;
  final FavoriteLocale favoriteLocale;
  const MyApp(
      {super.key,
      required this.iptv,
      required this.authApi,
      required this.watchingLocale,
      required this.favoriteLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //Enable FullScreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(widget.authApi),
        ),
        BlocProvider<LiveCatyBloc>(
          create: (BuildContext context) => LiveCatyBloc(widget.iptv),
        ),
        BlocProvider<ChannelsBloc>(
          create: (BuildContext context) => ChannelsBloc(widget.iptv),
        ),
        BlocProvider<MovieCatyBloc>(
          create: (BuildContext context) => MovieCatyBloc(widget.iptv),
        ),
        BlocProvider<SeriesCatyBloc>(
          create: (BuildContext context) => SeriesCatyBloc(widget.iptv),
        ),
        BlocProvider<VideoCubit>(
          create: (BuildContext context) => VideoCubit(),
        ),
        BlocProvider<SettingsCubit>(
          create: (BuildContext context) => SettingsCubit(),
        ),
        BlocProvider<WatchingCubit>(
          create: (BuildContext context) =>
              WatchingCubit(widget.watchingLocale),
        ),
        BlocProvider<FavoritesCubit>(
          create: (BuildContext context) =>
              FavoritesCubit(widget.favoriteLocale),
        ),
      ],
      child: ResponsiveSizer(
        builder: (context, orient, type) {
          return GetMaterialApp(
            title: 'Azul IPTV',
            theme: MyThemApp.themeData(context),
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            getPages: [
              GetPage(name: screenSplash, page: () => const SplashScreen()),
              GetPage(name: screenWelcome, page: () => const WelcomeScreen()),
              GetPage(name: screenIntro, page: () => const IntroScreen()),
              GetPage(
                  name: screenLiveCategories,
                  page: () => const LiveCategoriesScreen()),
              GetPage(name: screenRegister, page: () => const RegisterScreen()),
              GetPage(
                  name: screenRegisterTv, page: () => const RegisterUserTv()),
              GetPage(
                  name: screenMovieCategories,
                  page: () => const MovieCategoriesScreen()),
              GetPage(
                  name: screenSeriesCategories,
                  page: () => const SeriesCategoriesScreen()),
              GetPage(name: screenSettings, page: () => const SettingsScreen()),
              GetPage(
                  name: screenFavourite, page: () => const FavouriteScreen()),
              GetPage(name: screenCatchUp, page: () => const CatchUpScreen()),
            ],
          );
        },
      ),
    );
  }
}
