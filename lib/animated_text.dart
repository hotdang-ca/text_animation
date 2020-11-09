import 'dart:math';

import 'package:flutter/widgets.dart';

enum AnimationStyle {
  LowerCase,
  UpperCase,
  AllCase,
  NumericOnly,
  AlphaNumeric,
}

class AnimatedText extends StatefulWidget {
  static final String lowerCase = 'abcdefghijklmnopqrstuvwxyz';
  static final String upperCase = 'ABCDEFGHIJKLMNOPQRSTUVWZYZ';
  static final String numbers = '0123456789';

  final AnimationStyle animationStyle;
  final String text;
  final double fontSize;
  final Duration animationDuration;
  final Color fontColor;

  AnimatedText(this.text,
      {this.animationStyle = AnimationStyle.AlphaNumeric,
      this.fontSize,
      Duration animationDuration,
      this.fontColor})
      : animationDuration = animationDuration ?? Duration(seconds: 1);

  @override
  _AnimatedTextState createState() => _AnimatedTextState(
      text: this.text,
      fontSize: this.fontSize,
      animationDuration: this.animationDuration,
      animationStyle: this.animationStyle,
      fontColor: this.fontColor);
}

class _AnimatedTextState extends State<AnimatedText>
    with TickerProviderStateMixin {
  final String text;
  final double fontSize;
  final Duration animationDuration;
  final AnimationStyle animationStyle;
  final Color fontColor;

  String _fakeTextItem;
  String _currentCompoundString;

  AnimationController _individualLetterAnimationController;
  AnimationController _wholeStringAnimationController;
  // Animation _animation;

  _AnimatedTextState(
      {this.text,
      this.fontSize = 12.0,
      this.animationStyle,
      this.animationDuration,
      this.fontColor});

  @override
  void initState() {
    _currentCompoundString = text[0];

    var stringToUse = '';
    switch (this.animationStyle) {
      case AnimationStyle.LowerCase:
        stringToUse = AnimatedText.lowerCase;
        break;
      case AnimationStyle.UpperCase:
        stringToUse = AnimatedText.upperCase;
        break;
      case AnimationStyle.AllCase:
        stringToUse = AnimatedText.lowerCase + AnimatedText.upperCase;
        break;
      case AnimationStyle.NumericOnly:
        stringToUse = AnimatedText.numbers;
        break;
      case AnimationStyle.AlphaNumeric:
        stringToUse = AnimatedText.lowerCase +
            AnimatedText.upperCase +
            AnimatedText.numbers;
        break;
    }

    _individualLetterAnimationController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);

    _individualLetterAnimationController.addListener(() {
      var nextInt = Random().nextInt(stringToUse.length);
      var nextTick = (_individualLetterAnimationController.value * 10).toInt();

      if (nextTick == 5) {
        print('$nextTick');

        setState(() {
          this._fakeTextItem = stringToUse[nextInt];
        });
      }
    });

    _individualLetterAnimationController.forward();

    _individualLetterAnimationController.addStatusListener((status) {
      // from 0 to 1
      if (status == AnimationStatus.completed) {
        _individualLetterAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _individualLetterAnimationController.forward();
      }
    });

    _wholeStringAnimationController = AnimationController(
      duration: this.animationDuration,
      vsync: this,
      upperBound: (text.length - 1).toDouble(),
    );

    _wholeStringAnimationController.addListener(() {
      setState(() {
        if (_currentCompoundString.length <=
            _wholeStringAnimationController.value.toInt()) {
          _currentCompoundString +=
              text[_wholeStringAnimationController.value.toInt()];
        }
      });
    });

    _wholeStringAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // up one more
        setState(() {
          _fakeTextItem = '';
        });

        _individualLetterAnimationController.dispose();
      }
    });

    _individualLetterAnimationController.forward();
    _wholeStringAnimationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${this._currentCompoundString}${this._fakeTextItem}',
      style: TextStyle(
        fontSize: this.fontSize,
        color: this.fontColor,
      ),
    );
  }
}
