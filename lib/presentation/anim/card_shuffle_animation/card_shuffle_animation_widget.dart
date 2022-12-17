import 'package:flutter/material.dart';

class CardShuffleAnimation extends StatefulWidget {
  CardShuffleAnimation({
    Key? key,
    required this.child,
    required this.cardWidth,
    required this.onTapCardAfterAnimation,
  }) : super(key: key);

  final Widget child;
  final double cardWidth;
  final Function(int) onTapCardAfterAnimation;

  late final _state = CardShuffleAnimationState(
    child: child,
    cardWidth: cardWidth,
    onTapCardAfterAnimation: onTapCardAfterAnimation,
  );

  Future<void> startAnimation() async {
    await _state.startAnimation();
  }

  void resetAnimation() {
    _state.resetAnimation();
  }

  @override
  CardShuffleAnimationState createState() => _state;
}

class CardShuffleAnimationState extends State<CardShuffleAnimation>
    with TickerProviderStateMixin {
  CardShuffleAnimationState({
    required this.child,
    required this.cardWidth,
    required this.onTapCardAfterAnimation,
  });

  final Widget child;
  final double cardWidth;
  final Function(int) onTapCardAfterAnimation;

  final _cardsCount = 12;

  late final List<int> _indexList =
      List.generate(_cardsCount, (index) => index);

  late Animation<double> _scaleAnimation;
  late AnimationController _scaleAnimationController;
  final _scaleTween = Tween<double>(begin: 1.0, end: 0.56);
  final _scaleDuration = 500;

  late Animation<double> _angleAnimation;
  late AnimationController _angleAnimationController;
  final _angleTween = Tween<double>(begin: 0.0, end: 1.0);
  final _angleDuration = 500;

  late Animation<double> _translateAnimation;
  late AnimationController _translateAnimationController;
  final _translateTween = Tween<double>(begin: 0.0, end: 1.0);
  final _translateDuration = 500;

  var _dAngle = List<double>.empty(growable: true);
  var _dx = List<double>.empty(growable: true);
  var _dy = List<double>.empty(growable: true);

  var _isCompletedAnimation = false;

  @override
  void initState() {
    super.initState();

    _scaleAnimationController = AnimationController(
      duration: Duration(milliseconds: _scaleDuration),
      vsync: this,
    );

    _scaleAnimation = _scaleTween.animate(_scaleAnimationController)
      ..addListener(() {
        setState(() {});
      });

    _translateAnimationController = AnimationController(
      duration: Duration(milliseconds: _translateDuration),
      vsync: this,
    );

    _translateAnimation = _translateTween
        .chain(CurveTween(curve: Curves.decelerate))
        .animate(_translateAnimationController)
      ..addListener(() {
        setState(() {});
      });

    _angleAnimationController = AnimationController(
      duration: Duration(milliseconds: _angleDuration),
      vsync: this,
    );

    _angleAnimation = _angleTween
        .chain(CurveTween(curve: Curves.decelerate))
        .animate(_angleAnimationController)
      ..addListener(() {
        setState(() {});
      });

    _generateRandomData(0);
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _angleAnimationController.dispose();
    _translateAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offsets = _indexList
        .map((index) => Offset(_getOffsetX(index), _getOffsetY(index)))
        .toList();

    final cardWidget = SizedBox(
      width: cardWidth,
      child: child,
    );

    return Stack(
      children: [
        ..._indexList.map(
          (index) => Align(
            alignment: Alignment.topCenter,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.translate(
                offset: offsets[index],
                child: Transform.rotate(
                  angle: _getAngle(index),
                  child: GestureDetector(
                    onTap: () async {
                      if (index == _indexList.length - 1 &&
                          _isReadyAnimation()) {
                        await startAnimation();
                      }
                      if (_isCompletedAnimation) {
                        final mod = index % 3;
                        onTapCardAfterAnimation(mod);
                      }
                    },
                    child: cardWidget,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> startAnimation() async {
    await _scaleAnimationController.forward();
    setState(() {});
    await Future.delayed(Duration(milliseconds: _scaleDuration));

    // 5回発散
    const animCount = 5;
    for (var i = 0; i < animCount; i++) {
      _generateRandomData(i);
      _translateAnimationController.forward();
      await _angleAnimationController.forward();
      await Future.delayed(Duration(milliseconds: _translateDuration));

      if (i == animCount - 1) _angleAnimationController.reverse();
      await _translateAnimationController.reverse();
      if (i != animCount - 1) _angleAnimationController.reverse();
    }

    // 最後、3ケ所に収束
    _dx = List.generate(_cardsCount, (index) {
      final mod = index % 3;
      switch (mod) {
        case 0:
          return -cardWidth - 8;
        case 1:
          return 0;
        case 2:
          return cardWidth + 8;
      }
      return 0;
    });
    _dy = List.generate(_cardsCount, (index) => 0);
    _dAngle = List.generate(_cardsCount, (index) => 0);

    _translateAnimationController.forward();
    await _angleAnimationController.forward();

    _isCompletedAnimation = true;
    setState(() {});
  }

  void resetAnimation() {
    _scaleAnimationController.reset();
    _translateAnimationController.reset();
    _angleAnimationController.reset();
    _dAngle = List<double>.empty(growable: true);
    _dx = List<double>.empty(growable: true);
    _dy = List<double>.empty(growable: true);
    _isCompletedAnimation = false;
    setState(() {});
  }

  void _generateRandomData(int index) {
    _dAngle = [4.0, 3.0, 0.0, 2.0, 4.0, 1.0, 2.0, 1.0, 0.0, 4.0, 1.0, 1.0];
    final xSet = [
      [
        -180.0,
        -150.0,
        -120.0,
        -90.0,
        -60.0,
        -30.0,
        30.0,
        60.0,
        90.0,
        120.0,
        150.0,
        180.0,
      ],
      [
        -170.0,
        -150.0,
        -130.0,
        -110.0,
        -90.0,
        -70.0,
        70.0,
        90.0,
        110.0,
        130.0,
        150.0,
        170.0,
      ],
      [
        -180.0,
        -170.0,
        -160.0,
        -50.0,
        -40.0,
        -30.0,
        30.0,
        40.0,
        50.0,
        160.0,
        170.0,
        180.0,
      ],
      [
        -80.0,
        -70.0,
        -60.0,
        -50.0,
        -40.0,
        -30.0,
        30.0,
        40.0,
        50.0,
        60.0,
        70.0,
        80.0,
      ],
      [
        -180.0,
        -150.0,
        -120.0,
        -90.0,
        -60.0,
        -30.0,
        30.0,
        60.0,
        90.0,
        120.0,
        150.0,
        180.0,
      ],
    ];

    final ySet = [
      [
        70.0,
        -135.0,
        -55.0,
        126.0,
        -145.0,
        -95.0,
        107.0,
        -134.0,
        108.0,
        -108.0,
        -208.0,
        58.0
      ],
      [
        -70.0,
        135.0,
        -95.0,
        76.0,
        -165.0,
        95.0,
        127.0,
        134.0,
        -108.0,
        -108.0,
        208.0,
        118.0
      ],
      [
        90.0,
        -85.0,
        -90.0,
        60.0,
        45.0,
        -60.0,
        20.0,
        -34.0,
        25.0,
        -88.0,
        -58.0,
        70.0
      ],
      [
        -110.0,
        160.0,
        -180.0,
        -126.0,
        195.0,
        125.0,
        -135.0,
        -100.0,
        130.0,
        180.0,
        -200.0,
        110.0
      ],
      [
        -130.0,
        135.0,
        85.0,
        -126.0,
        145.0,
        95.0,
        -107.0,
        134.0,
        -108.0,
        -108.0,
        198.0,
        -58.0
      ],
    ];

    _dx = xSet[index];
    _dy = ySet[index];
  }

  double _getAngle(int index) {
    if (_dAngle.isNotEmpty) {
      return _dAngle[index] * _angleAnimation.value;
    }
    return 0;
  }

  double _getOffsetX(int index) {
    if (_dx.isNotEmpty) {
      return _dx[index] * _translateAnimation.value;
    }
    return 0;
  }

  double _getOffsetY(int index) {
    if (_dy.isNotEmpty) {
      return _dy[index] * _translateAnimation.value;
    }
    return 0;
  }

  bool _isReadyAnimation() {
    return _scaleAnimationController.status == AnimationStatus.dismissed &&
        _angleAnimationController.status == AnimationStatus.dismissed &&
        _translateAnimationController.status == AnimationStatus.dismissed;
  }
}
