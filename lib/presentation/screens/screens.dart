import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../helpers/helpers.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/categories/channels/channels_bloc.dart';
import '../../logic/blocs/categories/live_caty/live_caty_bloc.dart';
import '../../logic/blocs/categories/movie_caty/movie_caty_bloc.dart';
import '../../logic/blocs/categories/series_caty/series_caty_bloc.dart';
import '../../logic/cubits/video/video_cubit.dart';
import '../../repository/api/api.dart';
import '../../repository/models/movie_detail.dart';
import '../../repository/models/serie_details.dart';
import '../widgets/widgets.dart';

part 'live/live_categories.dart';
part 'live/live_channels.dart';
part 'movie/movie_categories.dart';
part 'movie/movie_channels.dart';
part 'movie/movie_details.dart';
part 'player/full_video.dart';
part 'player/player_video.dart';
part 'series/serie_details.dart';
part 'series/serie_seasons.dart';
part 'series/series_categories.dart';
part 'series/series_channels.dart';
part 'user/register.dart';
part 'user/settings.dart';
part 'user/splash.dart';
part 'welcome.dart';
