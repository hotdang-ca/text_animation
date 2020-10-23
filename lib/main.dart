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
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Entry {
  int id;
  String domainName;
  String ipAddress = '192.168.11.20';
  String hostName = 'Frans_iP11pMx';
  String dateTime = '13:04 EDT';
  String macAddress = '80:32:04:5b:7a:c3';
  bool isBlocked;

  Entry(this.id, this.domainName, this.isBlocked);
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  static const EXPANDED_BOX_HEIGHT = 300.0;
  static const NORMAL_BOX_HEIGHT = 100.0;
  static const NORMAL_BOX_PADDING = 4.0;
  static const EXPANDED_BOX_PADDING = 16.0;
  static const ANIMATION_CURVE = Curves.easeInOut;
  static const ANIMATION_DURATION = Duration(milliseconds: 350);

  var DOMAIN_REGEX =
      RegExp(r"^((?!-)[a-zA-Z0-9-]{0,62}[a-zA-Z0-9]\.)+([a-zA-Z]{2,63})$");

  bool _isFocused = false;
  ScrollController _scrollController;
  List<Entry> _scrollItems;
  Entry _currentItem;
  Entry _nextItem;
  Entry _secondNextItem;
  Entry _thirdNextItem;
  Entry _fourthNextItem;

  Entry _previousItem;
  Entry _secondPreviousItem;
  Entry _thirdPreviousItem;
  Entry _fourthPreviousItem;

  List<String> _subdomains = [
    'sub1.donkeykong.com',
    'securepubads.g.doubleclick.net',
    'a1051.b.akamai.net',
    'a1051.a.akamai.net',
    'news-edge.origin-apple.com.akadns.net',
    'r8---sn-gvbxgn-tm0e.googlevideo.com',
    '1b-dns-sd.udp.driessen',
    'mads.amazon-adsystem.com',
    'officeci-mauservice.azurewebsites.net',
    'app-measurement.com',
    'fransnet-0bdvxlvgg.2my.network',
    'tpc.googlesyncidcation.com',
  ];

  Map<int, double> _focusedListViewHeights;

  @override
  void initState() {
    super.initState();

    // set up scroll items
    _scrollItems = [];
    for (var i = 0; i < 24; i++) {
      var randomInteger = Random().nextInt(_subdomains.length);
      _scrollItems
          .add(Entry(i, _subdomains[randomInteger], Random().nextBool()));
    }

    // setup db of Ids to Heights
    _focusedListViewHeights = Map<int, double>();
    _scrollItems.forEach((element) {
      _focusedListViewHeights.putIfAbsent(element.id, () => NORMAL_BOX_HEIGHT);
    });

    // setup our animation
    setupListAnimations();
  }

  setupListAnimations() {
    _scrollController = ScrollController(); // it was easy :)
  }

  Widget domainText(Entry entry) {
    String text = entry.domainName;

    // let's focus on secondary items
    var smallFontSize = _isFocused && _currentItem.id != entry.id ? 10.0 : 18.0;
    var largeFontSize = _isFocused && _currentItem.id != entry.id ? 14.0 : 28.0;

    Iterable<Match> matches = DOMAIN_REGEX.allMatches(text);
    if (matches == null || matches.length == 0) {
      print('Invalid domain: $text');
      return Text('--');
    }

    if (matches.elementAt(0).groupCount < 2) {
      print(
          'Invalid domain: $text, group count: ${matches.elementAt(0).groupCount}');
      return Text(text);
    }

    var domain = matches.elementAt(0).group(1);
    var tld = matches.elementAt(0).group(2);
    var domainAndTld = '$domain$tld';

    // var fontSize = _
    var prefix = matches.elementAt(0).group(0).replaceAll(domainAndTld, '');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedDefaultTextStyle(
          curve: ANIMATION_CURVE,
          duration: ANIMATION_DURATION,
          style: TextStyle(fontSize: smallFontSize),
          child: Text(prefix,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: Colors.white,
              )),
        ),
        AnimatedDefaultTextStyle(
          curve: ANIMATION_CURVE,
          duration: ANIMATION_DURATION,
          style: TextStyle(fontSize: largeFontSize),
          child: Text(
            domainAndTld,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildListViewChild(Entry entry, int index) {
      bool isPreviousItem = false;
      bool isNextItem = false;
      bool isCurrentItem = false;
      bool isSecondPreviousItem = false;
      bool isSecondNextItem = false;
      bool isThirdPreviousItem = false;
      bool isThirdNextItem = false;
      bool isFourthPreviousItem = false;
      bool isFourthNextItem = false;

      isCurrentItem =
          _currentItem != null && _scrollItems[index].id == _currentItem.id;
      isPreviousItem =
          _previousItem != null && _scrollItems[index].id == _previousItem.id;
      isNextItem = _nextItem != null && _scrollItems[index].id == _nextItem.id;

      isSecondPreviousItem = _secondPreviousItem != null &&
          _scrollItems[index].id == _secondPreviousItem.id;
      isSecondNextItem = _secondNextItem != null &&
          _scrollItems[index].id == _secondNextItem.id;

      isThirdPreviousItem = _thirdPreviousItem != null &&
          _scrollItems[index].id == _thirdPreviousItem.id;
      isThirdNextItem =
          _thirdNextItem != null && _scrollItems[index].id == _thirdNextItem.id;

      isFourthPreviousItem = _fourthPreviousItem != null &&
          _scrollItems[index].id == _fourthPreviousItem.id;
      isFourthNextItem = _fourthNextItem != null &&
          _scrollItems[index].id == _fourthNextItem.id;

      print('is focused: $_isFocused');

      return GestureDetector(
        onTap: () {
          setState(() {
            bool isAlreadyFocused =
                _focusedListViewHeights[index] == EXPANDED_BOX_HEIGHT;

            _focusedListViewHeights.update(
                _scrollItems[index].id,
                (value) => value == EXPANDED_BOX_HEIGHT
                    ? NORMAL_BOX_HEIGHT
                    : EXPANDED_BOX_HEIGHT);

            if (isAlreadyFocused) {
              _isFocused = false;
              _currentItem = null;
              _nextItem = null;
              _previousItem = null;
              _secondNextItem = null;
              _secondPreviousItem = null;
              _thirdNextItem = null;
              _thirdPreviousItem = null;
              _fourthNextItem = null;
              _fourthPreviousItem = null;
            } else {
              _isFocused = true;
              _currentItem = _scrollItems[index];

              _nextItem = _scrollItems.length > index + 1
                  ? _scrollItems[index + 1]
                  : null;
              _secondNextItem = _scrollItems.length > index + 2
                  ? _scrollItems[index + 2]
                  : null;
              _thirdNextItem = _scrollItems.length > index + 3
                  ? _scrollItems[index + 3]
                  : null;
              _fourthNextItem = _scrollItems.length > index + 4
                  ? _scrollItems[index + 4]
                  : null;

              _previousItem = index > 0 ? _scrollItems[index - 1] : null;
              _secondPreviousItem = index > 1 ? _scrollItems[index - 2] : null;
              _thirdPreviousItem = index > 2 ? _scrollItems[index - 3] : null;
              _fourthPreviousItem = index > 3 ? _scrollItems[index - 4] : null;
            }
          });
        },
        // onPanStart: (DragStartDetails details) {
        //   bool isAlreadyFocused =
        //       _focusedListViewHeights[index] == EXPANDED_BOX_HEIGHT;
        //   if (isAlreadyFocused) {
        //     setState(() {
        //       // turn off all statuses
        //       _focusedListViewHeights.update(
        //           _scrollItems[index].id, (value) => NORMAL_BOX_HEIGHT);

        //       _currentItem = null;
        //       _nextItem = null;
        //       _previousItem = null;
        //     });
        //   }
        // },
        child: AnimatedContainer(
          duration: ANIMATION_DURATION * 1.8,
          curve: ANIMATION_CURVE,
          decoration: BoxDecoration(
            color: entry.isBlocked ? Colors.red : Colors.green,
            // border: Border.all(
            //     color: Colors.black, style: BorderStyle.solid, width: 1.0,
            // )
          ),
          height: isCurrentItem
              ? _focusedListViewHeights[_scrollItems[index].id]
              : isPreviousItem || isNextItem
                  ? NORMAL_BOX_HEIGHT * .75
                  : isSecondPreviousItem ||
                          isSecondNextItem ||
                          isThirdPreviousItem ||
                          isThirdNextItem ||
                          isFourthPreviousItem ||
                          isFourthNextItem ||
                          _isFocused
                      ? NORMAL_BOX_HEIGHT * 0.5
                      : NORMAL_BOX_HEIGHT,
          margin: EdgeInsets.only(
              top:
                  NORMAL_BOX_PADDING, // isCurrentItem ? EXPANDED_BOX_PADDING : NORMAL_BOX_PADDING,
              bottom:
                  NORMAL_BOX_PADDING, // isCurrentItem ? EXPANDED_BOX_PADDING : NORMAL_BOX_PADDING,
              left: isPreviousItem || isNextItem
                  ? EXPANDED_BOX_PADDING
                  : isSecondNextItem || isSecondPreviousItem
                      ? EXPANDED_BOX_PADDING * 2
                      : isThirdNextItem || isThirdPreviousItem
                          ? EXPANDED_BOX_PADDING * 3
                          : isFourthNextItem ||
                                  isFourthPreviousItem ||
                                  (_isFocused && !isCurrentItem)
                              ? EXPANDED_BOX_PADDING * 4
                              : NORMAL_BOX_PADDING,
              right: isPreviousItem || isNextItem
                  ? EXPANDED_BOX_PADDING
                  : isSecondNextItem || isSecondPreviousItem
                      ? EXPANDED_BOX_PADDING * 2
                      : isThirdNextItem || isThirdPreviousItem
                          ? EXPANDED_BOX_PADDING * 3
                          : isFourthNextItem ||
                                  isFourthPreviousItem ||
                                  (_isFocused && !isCurrentItem)
                              ? EXPANDED_BOX_PADDING * 4
                              : NORMAL_BOX_PADDING),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // IP ADDRESS
              // AnimatedDefaultTextStyle(
              //   duration: ANIMATION_DURATION * 0.8,
              //   curve: ANIMATION_CURVE,
              //   style: TextStyle(fontSize: isCurrentItem ? 24.0 : 0.0),
              //   child: Text(
              //     entry.ipAddress,
              //   ),
              // ),

              // DOMAIN NAME
              AnimatedContainer(
                duration: ANIMATION_DURATION,
                curve: ANIMATION_CURVE,
                padding: EdgeInsets.only(
                    top: isSecondNextItem || isSecondPreviousItem ? 4 : 16,
                    bottom: isSecondNextItem || isSecondPreviousItem ? 4 : 16),
                child: Center(
                  child: domainText(
                    entry,
                  ),
                ),
              ),

              // HOSTNAME
              // AnimatedDefaultTextStyle(
              //   duration: ANIMATION_DURATION * 1.5,
              //   curve: ANIMATION_CURVE,
              //   style: TextStyle(fontSize: isCurrentItem ? 24.0 : 0.0),
              //   child: Text(entry.hostName),
              // ),

              // MAC ADDRESS
              // AnimatedDefaultTextStyle(
              //   duration: ANIMATION_DURATION * 2,
              //   curve: ANIMATION_CURVE,
              //   style: TextStyle(
              //     fontSize: isCurrentItem ? 24.0 : 0.0,
              //   ),
              //   child: Text(entry.macAddress),
              // ),

              // JUST AN INDICATOR
              // isPreviousItem
              //     ? Text('previous')
              //     : isNextItem
              //         ? Text('next')
              //         : isCurrentItem
              //             ? Text('current')
              //             : Text('--'),
            ],
          )),
        ),
      );
    }

    return Scaffold(
      // backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _scrollItems.length,
        itemBuilder: (BuildContext context, int idx) {
          return buildListViewChild(_scrollItems[idx], idx);
        },
      ),
    );
  }
}
