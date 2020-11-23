import 'dart:math';

import 'package:flutter/material.dart';
import 'package:text_animation/entry.dart';
import 'package:text_animation/growable_animated_list.dart';

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

class _MyHomePageState extends State<MyHomePage> {
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

  List<Entry> _currentList;

  @override
  void initState() {
    super.initState();

    // set up scroll items
    _currentList = [];
    for (var i = 0; i < 24; i++) {
      var randomInteger = Random().nextInt(_subdomains.length);
      _currentList
          .add(Entry(i, _subdomains[randomInteger], Random().nextBool()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GrowableAnimatedList(list: _currentList),
    );
  }
}
