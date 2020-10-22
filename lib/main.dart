import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Entry {
  int id;
  String domainName;
  String ipAddress;
  String hostName;
  String dateTime;
  String macAddress;

  Entry(this.id, this.domainName);
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  static const BOX_WIDTH = 125.0;
  static const EXPANDED_BOX_HEIGHT = 250.0;
  static const NORMAL_BOX_HEIGHT = 75.0;
  static const NORMAL_BOX_PADDING = 4.0;
  static const EXPANDED_BOX_PADDING = 64.0;

  static const ANIMATION_CURVE = Curves.easeInOut;
  static const ANIMATION_DURATION = Duration(milliseconds: 350);

  Animation<double> _primaryTextAnimation;
  Animation<double> _secondaryTextAnimation;
  AnimationController _primaryTextAnimationController;
  AnimationController _secondaryTextAnimationController;

  ScrollController _scrollController;
  List<Entry> _scrollItems;

  List<String> _subdomains = [
    'sub1.donkeykong.com',
    'securepubads.g.doubleclick.net',
    'a1051.b.akamai.net',
    'a1051.a.akamai.net',
    'news-edge.origin-apple.com.akadns.net',
    'r8---sn-gvbxgn-tm0e.googlevideo.com',
    '1b_dns-sd__.udp.driessen',
    'mads.amazon-adsystem.com',
    'officeci-mauservice.azurewebsites.net',
    'app-measurement.com',
    'fransnet-0bdvxlvgg.2my.network',
    'tpc.googlesyncidcation.com',
  ];

  bool _animated = false;
  Map<int, double> _focusedListViewHeights;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _scrollItems = [];
    for (var i = 0; i < 24; i++) {
      var randomInteger = Random().nextInt(_subdomains.length);
      _scrollItems.add(Entry(i, _subdomains[randomInteger]));
    }

    // _focusedListViewHeights = Map<String, double>().addEntries(_scrollItems.map((element) => {'$element': NORMAL_BOX_HEIGHT }));
    _focusedListViewHeights = Map<int, double>();

    _scrollItems.forEach((element) {
      _focusedListViewHeights.putIfAbsent(element.id, () => NORMAL_BOX_HEIGHT);
    });

    setupBoxAnimations();
    setupListAnimations();
  }

  setupListAnimations() {
    _scrollController = ScrollController();
  }

  setupBoxAnimations() {
    _primaryTextAnimationController = AnimationController(
      duration: ANIMATION_DURATION,
      vsync: this,
    );
    _primaryTextAnimation =
        Tween(begin: NORMAL_BOX_HEIGHT, end: -NORMAL_BOX_HEIGHT).animate(
      CurvedAnimation(
        curve: ANIMATION_CURVE,
        parent: _primaryTextAnimationController,
      ),
    );

    _secondaryTextAnimationController = AnimationController(
      duration: ANIMATION_DURATION,
      vsync: this,
    );
    _secondaryTextAnimation =
        Tween(begin: NORMAL_BOX_HEIGHT, end: 150.0).animate(
      CurvedAnimation(
          curve: ANIMATION_CURVE, parent: _secondaryTextAnimationController),
    );
  }

  @override
  Widget build(BuildContext context) {
    var middleContainer = Positioned(
      left: 100,
      top: 100,
      child: Container(
        width: BOX_WIDTH,
        height: BOX_WIDTH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.red,
        ),
        child:
            Center(child: Text('Hello', style: TextStyle(color: Colors.white))),
      ),
    );

    var topLeftContainer = Positioned(
      left: 50,
      top: 50,
      child: AnimatedBuilder(
        animation: _primaryTextAnimation,
        builder: (BuildContext context, child) {
          return Transform.translate(
              offset: Offset(
                  _primaryTextAnimation.value, _primaryTextAnimation.value),
              child: child);
        },
        child: Container(
          width: BOX_WIDTH,
          height: BOX_WIDTH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.green,
          ),
          child: Center(
              child: Text('Hello', style: TextStyle(color: Colors.white))),
        ),
      ),
    );

    var bottomRightContainer = Positioned(
      left: 50,
      top: 50,
      child: AnimatedBuilder(
        animation: _secondaryTextAnimation,
        builder: (BuildContext context, child) {
          return Transform.translate(
            offset: Offset(
                _secondaryTextAnimation.value, _secondaryTextAnimation.value),
            child: child,
          );
        },
        child: Container(
          width: BOX_WIDTH,
          height: BOX_WIDTH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.blue,
          ),
          child: Center(
              child: Text('Hello', style: TextStyle(color: Colors.white))),
        ),
      ),
    );

    Widget buildListViewChild(String childTitle, int index) {
      return GestureDetector(
        onLongPress: () {
          setState(() {
            _focusedListViewHeights.update(
                _scrollItems[index].id,
                (value) =>
                    _isFocused ? NORMAL_BOX_HEIGHT : EXPANDED_BOX_HEIGHT);
            _isFocused = !_isFocused;
          });

          print('You pressed me: $childTitle');
        },
        child: AnimatedContainer(
          duration: ANIMATION_DURATION,
          curve: ANIMATION_CURVE,
          decoration: BoxDecoration(
              color: Colors.amber,
              border: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 1.0)),
          height: _focusedListViewHeights[_scrollItems[index].id],
          margin: EdgeInsets.only(
              top: _focusedListViewHeights[_scrollItems[index].id] ==
                      EXPANDED_BOX_HEIGHT
                  ? EXPANDED_BOX_PADDING
                  : NORMAL_BOX_PADDING,
              bottom: _focusedListViewHeights[_scrollItems[index].id] ==
                      EXPANDED_BOX_HEIGHT
                  ? EXPANDED_BOX_PADDING
                  : NORMAL_BOX_PADDING),
          child: Center(child: Text(childTitle)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _scrollItems.length,
        itemBuilder: (BuildContext context, int idx) {
          return buildListViewChild(_scrollItems[idx].domainName, idx);
        },
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: [
      // GestureDetector(
      //   onTap: () {
      //     _animate();
      //   },
      //   child: Container(
      //     width: 350,
      //     height: 350,
      //     alignment: Alignment.center,
      //     decoration: BoxDecoration(
      //       border: Border.all(
      //         color: Colors.black,
      //         width: 1.0,
      //         style: BorderStyle.solid,
      //       ),
      //     ),
      //     child: Stack(
      //       children: [
      //         bottomRightContainer,
      //         topLeftContainer,
      //         middleContainer,
      //       ],
      //     ),
      //   ),
      // ),
      // ],
      // ),
    );
  }

  void _animate() {
    if (_animated) {
      _primaryTextAnimationController.reverse();
      _secondaryTextAnimationController.reverse();
    } else {
      _secondaryTextAnimationController.forward();
      _primaryTextAnimationController.forward();
    }

    setState(() {
      _animated = !_animated;
    });
  }
}
