part of 'widgets.dart';

class CardChannelMovieItem extends StatelessWidget {
  const CardChannelMovieItem(
      {Key? key, required this.onTap, this.title, this.image})
      : super(key: key);
  final Function() onTap;
  final String? title;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      focusColor: kColorFocus,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
          color: kColorCardLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: image ?? "",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, i, e) {
                    return const SizedBox();
                  },
                  placeholder: (_, i) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title ?? 'null',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardButtonWatchMovie extends StatefulWidget {
  const CardButtonWatchMovie(
      {Key? key, required this.title, required this.onTap})
      : super(key: key);
  final String title;
  final Function() onTap;

  @override
  State<CardButtonWatchMovie> createState() => _CardButtonWatchMovieState();
}

class _CardButtonWatchMovieState extends State<CardButtonWatchMovie> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10),
        onFocusChange: (bool value) {
          setState(() {
            isFocused = value;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: isFocused
                ? LinearGradient(
                    colors: [kColorPrimary, kColorPrimaryDark],
                  )
                : LinearGradient(
                    colors: [
                      kColorPrimary.withOpacity(.4),
                      kColorPrimaryDark.withOpacity(.4)
                    ],
                  ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
          child: Text(
            widget.title.toUpperCase(),
            style:
                isFocused ? Get.textTheme.headline4 : Get.textTheme.headline5,
          ),
        ),
      ),
    );
  }
}

class CardInfoMovie extends StatelessWidget {
  const CardInfoMovie(
      {Key? key,
      required this.hint,
      required this.title,
      required this.icon,
      this.isShowMore = false})
      : super(key: key);
  final String hint;
  final String title;
  final IconData icon;
  final bool isShowMore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 15.sp,
              ),
              const SizedBox(width: 5),
              Text(
                hint,
                style: Get.textTheme.headline5,
              ),
            ],
          ),
          const SizedBox(height: 3),
          !isShowMore
              ? Text(
                  title,
                  style: Get.textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.w100,
                  ),
                )
              : ReadMoreText(
                  title,
                  trimLines: 2,
                  colorClickableText: kColorFocus,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'more',
                  trimExpandedText: 'less',
                  style: Get.textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.w100,
                  ),
                  moreStyle: Get.textTheme.headline5!.copyWith(
                    color: kColorFocus,
                  ),
                  lessStyle: Get.textTheme.headline5!.copyWith(
                    color: kColorFocus,
                  ),
                ),
        ],
      ),
    );
  }
}

class CardMovieImageRate extends StatelessWidget {
  const CardMovieImageRate({Key? key, required this.image, required this.rate})
      : super(key: key);
  final String image;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: image,
            width: 18.w,
            height: 55.h,
            fit: BoxFit.cover,
            errorWidget: (_, i, e) {
              return Container(
                color: Colors.grey,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        RatingBarIndicator(
          rating: double.parse(rate),
          itemBuilder: (context, index) => const Icon(
            FontAwesomeIcons.solidStar,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 18.sp,
          direction: Axis.horizontal,
        ),
      ],
    );
  }
}

class CardMovieImagesBackground extends StatefulWidget {
  const CardMovieImagesBackground({Key? key, required this.listImages})
      : super(key: key);
  final List<String> listImages;

  @override
  State<CardMovieImagesBackground> createState() =>
      _CardMovieImagesBackgroundState();
}

class _CardMovieImagesBackgroundState extends State<CardMovieImagesBackground> {
  late bool isNotEmpty;
  late int sizeList;
  int indexImage = 1;

  _runAnimation() async {
    await Future.delayed(const Duration(seconds: 5));

    if (mounted) {
      setState(() {
        if ((indexImage + 1) >= sizeList) {
          indexImage = 0;
        } else {
          indexImage = indexImage + 1;
        }
      });
      _runAnimation();
    }
  }

  @override
  void initState() {
    isNotEmpty = widget.listImages.isNotEmpty;

    if (isNotEmpty) {
      sizeList = widget.listImages.length;
      _runAnimation();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isNotEmpty) {
      return const SizedBox();
    }

    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 3),
          child: CachedNetworkImage(
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
            imageUrl: widget.listImages[indexImage],
            errorWidget: (_, i, e) {
              return const SizedBox();
            },
          ),
        ),
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              colors: [
                kColorBackDark.withOpacity(1),
                kColorBack.withOpacity(.5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}