part of '../screens.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        width: 100.w,
        height: 100.h,
        decoration: kDecorBackground,
        child: Column(
          children: [
            const IntroImageAnimated(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5.h,
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    Text(
                      "Watch films anywhere\nand anytime",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headlineLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Enjoy watching your favorite movies\nwherever and whenever you like"
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 15.sp,
                      ),
                    ),
                    const Spacer(),
                    CardTallButton(
                      label: "Add User",
                      onTap: () => Get.toNamed(screenRegister),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}