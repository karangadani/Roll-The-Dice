import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shake/shake.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

void main() => runApp(MaterialApp(
      title: 'Dice App',
      home: MainPage(),
      theme: ThemeData.dark(),

      debugShowCheckedModeBanner: false,
    ));

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int num1 = 1;
  int num2 = 2;

  double randomPositionHeight1;
  double randomPositionWidth1;
  double randomPositionHeight2;
  double randomPositionWidth2;

  double deviceHeight;
  double deviceWidth;

  double getHeightnWidth({int min, int max}) {
    return (Random().nextDouble() * (max - min + 1) + min);
  }

  changeNum() async {
    setState(() {
      num1 = Random().nextInt(6) + 1;
      num2 = Random().nextInt(6) + 1;

      randomPositionHeight1 = getHeightnWidth(
          min: (deviceHeight * 0.1).toInt(),
          max: (deviceHeight * 0.7).toInt() - 60);
      randomPositionWidth1 = getHeightnWidth(
          min: (deviceWidth * 0.1).toInt(), max: (deviceWidth).toInt() - 60);
      randomPositionHeight2 = getHeightnWidth(
          min: (deviceHeight * 0.1).toInt(),
          max: (deviceHeight * 0.7).toInt() - 60);
      randomPositionWidth2 = getHeightnWidth(
          min: (deviceWidth * 0.1).toInt(), max: (deviceWidth).toInt() - 60);

    });
    await playLocalAsset();
  }

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("rolling.mp3");
  }

  void initState() {
    super.initState();

    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('shaked');
      changeNum();
    });

    Fluttertoast.showToast(msg: 'Shake Device to change number');
  }

  @override
  void didChangeDependencies() {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(" Height $deviceHeight");
    print("width $deviceWidth");

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
     
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Roll the Dice',
          style: TextStyle(fontFamily: 'MojorMono'),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Expanded(
                child: Stack(
                  children: [
                    Positioned(
                        top: randomPositionHeight1,
                        right: randomPositionWidth1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/dice$num1.png',
                            scale: 10,
                          ),
                        )),
                    Positioned(
                        top: randomPositionHeight2,
                        right: randomPositionWidth2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/dice$num2.png',
                              scale: 10),
                        )),
                  ],
                ),
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
                child: InkWell(
                    onTap: changeNum,
                    child: Card(
                      color: Colors.blue,
                      child: Container(
                        height: 40,
                        width: 75,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.replay,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Roll',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Satisfy',
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))),
          ),
          Container(
            height: deviceHeight * 0.07,
              child: GestureDetector(
            child: Text('About Developer'),
            onTap: () {
              AwesomeDialog(
                width: 500,
                context: context,
                customHeader: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile_img.jpeg'),
                ),
                animType: AnimType.SCALE,
                dialogType: DialogType.NO_HEADER,
                body: Container(
                  child: Column(
                    children: [
                      Text(
                        'Karan Gadani',
                        style: TextStyle(
                          fontFamily: 'Satisfy',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Flutter Developer',
                        style: TextStyle(
                          fontFamily: 'MojorMono',
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              )..show();

            },
          ),),
        ],
      ),
    );
  }
}
