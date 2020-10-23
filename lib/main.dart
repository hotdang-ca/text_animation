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

  Entry(this.id, this.domainName);
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  static const EXPANDED_BOX_HEIGHT = 300.0;
  static const NORMAL_BOX_HEIGHT = 75.0;
  static const NORMAL_BOX_PADDING = 4.0;
  static const EXPANDED_BOX_PADDING = 64.0;

  static const ANIMATION_CURVE = Curves.easeInOut;
  static const ANIMATION_DURATION = Duration(milliseconds: 350);
  var DOMAIN_REGEX =
      RegExp(r"^((?!-)[a-zA-Z0-9-]{0,62}[a-zA-Z0-9]\.)+([a-zA-Z]{2,63})$");

  ScrollController _scrollController;
  List<Entry> _scrollItems;

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

  bool _isFocused = false; // TODO: this was good for one... now we have a lot.

  @override
  void initState() {
    super.initState();

    // set up scroll items
    _scrollItems = [];
    for (var i = 0; i < 24; i++) {
      var randomInteger = Random().nextInt(_subdomains.length);
      _scrollItems.add(Entry(i, _subdomains[randomInteger]));
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

  Widget domainText(String text) {
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

    var prefix = matches.elementAt(0).group(0).replaceAll(domainAndTld, '');

    print('PREFIX: ${prefix}');
    print('DOMAIN: $domainAndTld');
    print('---');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prefix,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w100,
            )),
        Text(domainAndTld,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w200,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildListViewChild(Entry entry, int index) {
      bool isCurrentItem = _focusedListViewHeights[_scrollItems[index].id] ==
          EXPANDED_BOX_HEIGHT;

      return GestureDetector(
        onTap: () {
          setState(() {
            _focusedListViewHeights.update(
                _scrollItems[index].id,
                (value) =>
                    _isFocused ? NORMAL_BOX_HEIGHT : EXPANDED_BOX_HEIGHT);
            _isFocused = !_isFocused;
          });
        },
        child: AnimatedContainer(
          duration: ANIMATION_DURATION * 0.8,
          curve: ANIMATION_CURVE,
          decoration: BoxDecoration(
            color: Colors.amber,
            // border: Border.all(
            //     color: Colors.black, style: BorderStyle.solid, width: 1.0,
            // )
          ),
          height: _focusedListViewHeights[_scrollItems[index].id],
          margin: EdgeInsets.only(
              top: isCurrentItem ? EXPANDED_BOX_PADDING : NORMAL_BOX_PADDING,
              bottom:
                  isCurrentItem ? EXPANDED_BOX_PADDING : NORMAL_BOX_PADDING),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // IP ADDRESS
              AnimatedDefaultTextStyle(
                duration: ANIMATION_DURATION * 0.8,
                curve: ANIMATION_CURVE,
                style: TextStyle(fontSize: isCurrentItem ? 24.0 : 0.0),
                child: Text(
                  entry.ipAddress,
                ),
              ),
              AnimatedContainer(
                duration: ANIMATION_DURATION,
                curve: ANIMATION_CURVE,
                child: Container(
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                    ),
                    child: Center(
                        child: AnimatedDefaultTextStyle(
                      duration: ANIMATION_DURATION,
                      curve: ANIMATION_CURVE,
                      style: TextStyle(fontSize: isCurrentItem ? 28.0 : 18.0),
                      child: domainText(entry.domainName),
                    ))),
              ),

              // HOSTNAME
              AnimatedDefaultTextStyle(
                duration: ANIMATION_DURATION * 1.5,
                curve: ANIMATION_CURVE,
                style: TextStyle(
                  fontSize: isCurrentItem ? 24.0 : 0.0,
                ),
                child: Text(entry.hostName),
              ),
              AnimatedDefaultTextStyle(
                duration: ANIMATION_DURATION * 2,
                curve: ANIMATION_CURVE,
                style: TextStyle(
                  fontSize: isCurrentItem ? 24.0 : 0.0,
                ),
                child: Text(entry.macAddress),
              ),
            ],
          )),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
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
