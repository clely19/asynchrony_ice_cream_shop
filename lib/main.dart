import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icecream_shop/widgets/ChatBox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Timer _timer;
  int _start = 10;
  late Offset _personPosition;
  late bool _isWalking;
  late bool _iceCream = false;

  @override
  void initState() {
    super.initState();
    _personPosition = const Offset(0, 400); // Initial position off-screen
    _isWalking = false;
  }

  //calls _movePerson
  Future<void> _walkToShop(Offset arg1, Offset arg2) async {
    setState(() {
      _isWalking = true;
    });
    await _movePerson(arg1, arg2);

    setState(() {
      _isWalking = false;
    });
  }

  //moves from a position to another position linearly
  Future<void> _movePerson(Offset from, Offset to) async {
    const Duration duration = Duration(seconds: 4);
    final double stepX = (to.dx - from.dx) / (duration.inMilliseconds / 100);
    final double stepY = (to.dy - from.dy) / (duration.inMilliseconds / 100);

    for (int i = 0; i < (duration.inMilliseconds / 100).floor(); i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _personPosition += Offset(stepX, stepY);
      });
    }
    if (to.dx == 70 && to.dy == 150) {
      print("Walked to shop");
      Future.delayed(
          const Duration(seconds: 2), () => print("got my ice cream"));
    }
  }

  //starts a timer of 10 sec
  //when timer displays zero, calls _walkToShop
  Future<void> startTimer() async {
    print("Waiting for shop to open...");
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      print("$_start");
      if (_start == 0) {
        if (!_isWalking) {
          _walkToShop(const Offset(0, 400), const Offset(70, 150));
        }
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  //contrls the chatbox when dash gets ice cream
  ChatWithIcecream() {
    _iceCream = true;
    setState(() {
      if (_iceCream) {
        Future.delayed(const Duration(seconds: 2),
            () => _walkToShop(const Offset(70, 150), const Offset(150, 250)));
      }
    });
    return const ChatBox(
      message: "I got my ice cream!",
      chatBoxColor: Colors.grey,
      textColor: Colors.black,
    );
  }

  //image when dash gets ice cream
  DashWithIcecream() {
    return const AssetImage("assets/images/dash_icecream.png");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ice Cream Shop: Asynchrony',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ice Cream Shop: Asynchrony'),
          backgroundColor: Colors.black26,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Stack(
                children: [
                  //Ice cream shop with/ without timer
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/ice_cream_shop.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Stack(
                        children: [
                          //displays closed/open image on shop
                          Positioned(
                            right: MediaQuery.of(context).size.width * 0.31,
                            top: MediaQuery.of(context).size.height * 0.28,
                            child: _start == 0
                                ? Image.asset('assets/images/open.png',
                                    scale: 13)
                                : Image.asset('assets/images/close.png',
                                    scale: 14),
                          ),
                          _start != 0

                              //displays the timer on shop
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "$_start",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),

                  //dash moving/not moving, without/ with ice cream
                  Positioned(
                    left: _personPosition.dx,
                    top: _personPosition.dy,
                    child: Stack(
                      children: [
                        //image of dash controls
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (_personPosition.dx == 70 &&
                                          _personPosition.dy == 150 ||
                                      _iceCream)
                                  ? DashWithIcecream()
                                  : const AssetImage('assets/images/dash.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),

                        //chatbox controls
                        _start == 0
                            ? //chatbox displayed when dash gets ice cream
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: (_personPosition.dx == 70 &&
                                            _personPosition.dy == 150 ||
                                        _iceCream)
                                    ? ChatWithIcecream()
                                    : //chatbox displayed when timer ends
                                    const ChatBox(
                                        message:
                                            "It's open!\n Now I can get my ice cream",
                                        chatBoxColor: Colors.grey,
                                        textColor: Colors.black,
                                      ),
                              )
                            : _start == 10
                                ? //chatbox displayed before timer starts
                                const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ChatBox(
                                      message:
                                          "There are still 10 secs for the\n shop to open.\n I gotta wait!!",
                                      chatBoxColor: Colors.grey,
                                      textColor: Colors.black,
                                    ),
                                  )
                                : //chatbox displayed when timer is running
                                const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ChatBox(
                                      message: "WAITING!!",
                                      chatBoxColor: Colors.grey,
                                      textColor: Colors.black,
                                    ),
                                  ),
                      ],
                    ),
                  ),

                  //Button triggers timer
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () async {
                        await startTimer();
                      },
                      child: const Text("START"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
