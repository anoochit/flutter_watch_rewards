import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A customizable Flutter widget that displays a circular progress indicator
/// with rewards functionality.
///
/// This widget shows a circular progress indicator that fills up over time,
/// and displays a reward value that increases at specified intervals.
///
/// Example:
/// ```dart
/// WatchRewards(
///   radius: 50.0,
///   foregroundColor: Colors.blue,
///   backgroundColor: Colors.grey,
///   buttonColorBegin: Colors.blue,
///   buttonColorEnd: Colors.lightBlue,
///   buttonTitle: 'Claim',
///   value: 100.0,
///   stepValue: 10.0,
///   watchInteval: 100,
///   icon: Icon(Icons.star),
///   onValueChanged: (value) => print('New value: $value'),
///   onTap: () => print('Button tapped'),
/// )
/// ```
class WatchRewards extends StatefulWidget {
  /// Creates a WatchRewards widget.
  ///
  /// All parameters are required except [controller] and [symbol].
  const WatchRewards({
    super.key,
    required this.radius,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.buttonColorBegin,
    required this.buttonColorEnd,
    required this.buttonTitle,
    required this.value,
    required this.stepValue,
    required this.watchInteval,
    required this.icon,
    required this.onValueChanged,
    required this.onTap,
    this.controller,
    this.symbol = '',
  });

  /// The radius of the circular progress indicator.
  final double radius;

  /// The color of the progress indicator and text.
  final Color foregroundColor;

  /// The background color of the circular indicator.
  final Color backgroundColor;

  /// The start color of the button gradient.
  final Color buttonColorBegin;

  /// The end color of the button gradient.
  final Color buttonColorEnd;

  /// The text displayed on the button.
  final String buttonTitle;

  /// The initial value displayed in the center of the widget.
  final double value;

  /// The amount by which the value increases each cycle.
  final double stepValue;

  /// The interval (in secounds) between each progress update.
  final int watchInteval;

  /// The icon displayed in the center of the widget.
  final Icon icon;

  /// Callback function called when the value changes.
  final Function(double) onValueChanged;

  /// Callback function called when the button is tapped.
  final VoidCallback onTap;

  /// Optional controller to manually control the widget's state.
  final WatchRewardsController? controller;

  /// Optional symbol to be displayed before the value (e.g., currency symbol).
  final String symbol;

  @override
  State<WatchRewards> createState() => _WatchRewardsState();
}

class _WatchRewardsState extends State<WatchRewards> {
  late double _value;
  late int _count;
  late NumberFormat _numberFormat;
  bool _isRunning = false;
  late StreamSubscription _subScription;
  late Stream _stream;
  bool _showStep = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _count = 0;
    _numberFormat = NumberFormat.currency(symbol: widget.symbol);

    if (widget.controller != null) {
      widget.controller!._setCallbacks(
          startCallback: start, stopCallback: stop, pauseCallback: pause);
    } else {
      start();
    }
  }

  start() {
    if (!_isRunning) {
      _isRunning = true;
      openStream();
    }
  }

  stop() {
    if (_isRunning) {
      _isRunning = false;
      _subScription.cancel();
      setState(() {
        _count = 0;
      });
    }
  }

  pause() {
    if (_isRunning) {
      _isRunning = false;
      _subScription.pause();
    }
  }

  void openStream() {
    //
    _stream = Stream.periodic(
        Duration(milliseconds: (10 * widget.watchInteval)), (count) {
      return count;
    });

    _subScription = _stream.listen((v) {
      if (_isRunning) {
        setState(() {
          _count++;
          if (_count == 15) _showStep = false;
          if (_count == 100) {
            _showStep = true;
            _count = 0;
            _value = _value + widget.stepValue;
            widget.onValueChanged(_value);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subScription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popupWidth = widget.radius * 2;
    final popupHeight = 12 * 2.5;

    final indicatorContainerWidth = popupWidth;
    final indicatorContainerHeight = popupWidth + (widget.radius * 0.25);
    final buttonWidth = widget.radius * 2.5;
    final buttonHeight = 28.0;

    return Column(
      children: [
        // popup
        AnimatedOpacity(
          opacity: _showStep ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: SizedBox(
            width: popupWidth,
            height: popupHeight,
            child: Stack(
              children: [
                // box
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 12.0),
                  child: Transform.rotate(
                    angle: 0.8,
                    child: Container(
                      width: 12,
                      height: 12,
                      color: widget.foregroundColor,
                    ),
                  ),
                ),

                // text step value
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.foregroundColor,
                      borderRadius: BorderRadius.circular(widget.radius),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                      child: Text(
                        '+ ${widget.stepValue}',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .apply(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 8.0),

        // counter
        SizedBox(
          width: indicatorContainerWidth,
          height: indicatorContainerHeight,
          child: Stack(
            children: [
              // circle progress indicator
              SizedBox(
                width: popupWidth,
                height: popupWidth,
                child: Stack(
                  children: [
                    // background
                    Container(
                      width: popupWidth,
                      height: popupWidth,
                      decoration: BoxDecoration(
                        color: widget.backgroundColor,
                        borderRadius: BorderRadius.circular(widget.radius),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // icon
                            widget.icon,
                            // value
                            Text(
                              _numberFormat.format(widget.value),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(
                                      color: widget.foregroundColor,
                                      fontWeightDelta: 2),
                            )
                          ],
                        ),
                      ),
                    ),

                    // circle progress indicator
                    Positioned.fill(
                      child: CircularProgressIndicator(
                        strokeWidth: 4.0,
                        color: widget.foregroundColor,
                        value: (_count * 0.01),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        //button
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () => widget.onTap(),
            child: Container(
              width: buttonWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    colors: [
                      widget.buttonColorBegin,
                      widget.buttonColorEnd,
                    ],
                  )),
              child: Center(
                child: Text(
                  widget.buttonTitle,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

/// Controller for manually managing the state of a [WatchRewards] widget.
///
/// This controller allows external control over starting, stopping, and pausing
/// the progress of a [WatchRewards] widget.
class WatchRewardsController {
  VoidCallback? _startCallBack;
  VoidCallback? _stopCallBack;
  VoidCallback? _pauseCallBack;

  /// Starts the progress of the associated [WatchRewards] widget.
  void start() => _startCallBack?.call();

  /// Stops the progress of the associated [WatchRewards] widget and resets the count.
  void stop() => _stopCallBack?.call();

  /// Pauses the progress of the associated [WatchRewards] widget.
  void pause() => _pauseCallBack?.call();

  // Internal method to set callbacks. Not intended for public use.
  void _setCallbacks({
    required VoidCallback startCallback,
    required VoidCallback stopCallback,
    required VoidCallback pauseCallback,
  }) {
    _startCallBack = startCallback;
    _stopCallBack = stopCallback;
    _pauseCallBack = pauseCallback;
  }
}
