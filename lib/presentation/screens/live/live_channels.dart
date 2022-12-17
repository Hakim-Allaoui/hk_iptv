part of '../screens.dart';

class LiveChannelsScreen extends StatefulWidget {
  const LiveChannelsScreen({Key? key, required this.catyId}) : super(key: key);
  final String catyId;

  @override
  State<LiveChannelsScreen> createState() => _ListChannelsScreen();
}

class _ListChannelsScreen extends State<LiveChannelsScreen> {
  VlcPlayerController? _videoPlayerController;
  int? selectedVideo;

  @override
  void initState() {
    context.read<ChannelsBloc>().add(GetLiveChannelsEvent(
          catyId: widget.catyId,
          typeCategory: TypeCategory.live,
        ));
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    if (_videoPlayerController != null) {
      await _videoPlayerController!.stopRendererScanning();
      await _videoPlayerController!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, stateAuth) {
          if (stateAuth is AuthSuccess) {
            final userAuth = stateAuth.user;

            return Scaffold(
              body: Ink(
                width: 100.w,
                height: 100.h,
                decoration: kDecorBackground,
                // padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10),
                child: Column(
                  children: [
                    BlocBuilder<VideoCubit, VideoState>(
                      builder: (context, stateVideo) {
                        if (stateVideo.isFull) {
                          return const SizedBox();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3.h),
                            const AppBarLive(),
                            const SizedBox(height: 15),
                          ],
                        );
                      },
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          BlocBuilder<VideoCubit, VideoState>(
                            builder: (context, stateVideo) {
                              bool setFull = stateVideo.isFull;
                              if (setFull) {
                                return const SizedBox();
                              }
                              return Expanded(
                                child: BlocBuilder<ChannelsBloc, ChannelsState>(
                                  builder: (context, state) {
                                    if (state is ChannelsLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (state is ChannelsLiveSuccess) {
                                      final categories = state.channels;
                                      return GridView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        itemCount: categories.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              selectedVideo == null ? 2 : 1,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing:
                                              selectedVideo == null ? 10 : 0,
                                          childAspectRatio: 7,
                                        ),
                                        itemBuilder: (_, i) {
                                          final model = categories[i];

                                          final link =
                                              "${userAuth.serverInfo!.serverUrl}/${userAuth.userInfo!.username}/${userAuth.userInfo!.password}/${model.streamId}";

                                          return CardLiveItem(
                                            title: model.name ?? "",
                                            image: model.streamIcon,
                                            link: link,
                                            isSelected: selectedVideo == null
                                                ? false
                                                : selectedVideo == i,
                                            onTap: () async {
                                              debugPrint("link: $link");
                                              if (selectedVideo == i &&
                                                  _videoPlayerController !=
                                                      null) {
                                                // OPEN FULL SCREEN
                                                context
                                                    .read<VideoCubit>()
                                                    .changeUrlVideo(true);
                                              } else {
                                                if (_videoPlayerController !=
                                                        null &&
                                                    (await _videoPlayerController!
                                                            .isPlaying() ??
                                                        false)) {
                                                  setState(() {
                                                    _videoPlayerController!
                                                        .pause();
                                                    _videoPlayerController =
                                                        null;
                                                  });
                                                }

                                                await Future.delayed(
                                                    const Duration(
                                                        milliseconds: 200));
                                                setState(() {
                                                  selectedVideo = i;
                                                  _videoPlayerController =
                                                      VlcPlayerController
                                                          .network(
                                                    link,
                                                    hwAcc: HwAcc.full,
                                                    autoPlay: true,
                                                    autoInitialize: true,
                                                    options: VlcPlayerOptions(),
                                                  );
                                                });
                                              }
                                            },
                                          );
                                        },
                                      );
                                    }

                                    return const Center(
                                      child: Text("Failed to load data..."),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          if (selectedVideo != null)
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: PlayerScreen(
                                      controller: _videoPlayerController,
                                    ),
                                  ),
                                  BlocBuilder<VideoCubit, VideoState>(
                                    builder: (context, stateVideo) {
                                      if (stateVideo.isFull) {
                                        return const SizedBox();
                                      }
                                      return const Expanded(child: SizedBox());
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Scaffold();
        },
      ),
    );
  }
}
