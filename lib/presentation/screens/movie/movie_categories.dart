part of '../screens.dart';

class MovieCategoriesScreen extends StatefulWidget {
  const MovieCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<MovieCategoriesScreen> createState() => _MovieCategoriesScreenState();
}

class _MovieCategoriesScreenState extends State<MovieCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        width: 100.w,
        height: 100.h,
        decoration: kDecorBackground,
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10),
        child: Column(
          children: [
            const AppBarLive(),
            const SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<MovieCatyBloc, MovieCatyState>(
                builder: (context, state) {
                  if (state is MovieCatyLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovieCatySuccess) {
                    final categories = state.categories;
                    return GridView.builder(
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4,
                      ),
                      itemBuilder: (_, i) {
                        return CardLiveItem(
                          title: categories[i].categoryName ?? "",
                          onTap: () {
                            // OPEN Channels
                            Get.to(() => MovieChannels(
                                catyId: categories[i].categoryId ?? ''));
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
            ),
          ],
        ),
      ),
    );
  }
}