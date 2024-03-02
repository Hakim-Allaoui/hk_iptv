import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbark_iptv/main.dart';
import 'package:mbark_iptv/second/screens/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    //Reset Enable FullScreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    changeDeviceOrientBack();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse("0xff${remoteConfigModel.appColor}")),
      appBar: AppBar(
        title: Text(
          remoteConfigModel.appName ?? "PRO IPTV",
          style: Theme.of(context).textTheme.headlineMedium!.apply(
                color: Colors.white,
              ),
        ),
        centerTitle: true,
        backgroundColor: Color(int.parse("0xff${remoteConfigModel.appColor}")),
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          if(remoteConfigModel.bg_image != null) Positioned.fill(
            child: Image.network(
              remoteConfigModel.bg_image!,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                if(remoteConfigModel.logo != null) Image.network(
                  remoteConfigModel.logo!,
                  width: 200,
                  height: 200,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => HomePage(
                          url: remoteConfigModel.link ?? "https://www.google.com",
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0XFFFD81FE),
                            Color(0XFFAD3DFF),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: Offset(0, 12.0))
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            remoteConfigModel.buttonText ?? "Start",
                            style: Theme.of(context).textTheme.headlineMedium!.apply(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeDeviceOrientBack() {
    //change portrait mobile
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }
}
