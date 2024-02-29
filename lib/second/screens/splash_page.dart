import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    changeDeviceOrientBack();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome!"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => const HomePage(url: "https://www.google.com",)));
          },
          child: const Text("Continue"),
        ),
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
