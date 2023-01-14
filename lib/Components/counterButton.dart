import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounterButton extends StatefulWidget {

  const CounterButton(
      {Key? key,
        required this.count,
        required this.onChange,
        required this.loading,
        this.countColor = Colors.black,
        this.addIcon = const Icon(Icons.add),
        this.removeIcon = const Icon(Icons.remove),
        this.buttonColor = Colors.black,
        this.progressColor = Colors.black})
      : super(key: key);

  final int count;
  final Color countColor;
  final ValueChanged<int> onChange;
  final bool loading;
  final Color progressColor;
  final Color buttonColor;
  final Icon addIcon;
  final Icon removeIcon;

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<CounterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.loading)
                LinearProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(widget.progressColor),
                  backgroundColor: Colors.transparent,
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: IconButton(
                        onPressed: widget.loading
                            ? null
                            : () {
                          widget.onChange(widget.count - 1);
                        },
                        icon: widget.removeIcon,
                        padding: EdgeInsets.zero,
                        color: widget.buttonColor,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      layoutBuilder: (Widget? currentChild,
                          List<Widget> previousChildren) {
                        return currentChild!;
                      },
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final Animation<Offset> inAnimation = Tween<Offset>(
                            begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .animate(animation);
                        final Animation<Offset> outAnimation = Tween<Offset>(
                            begin: const Offset(-1.0, 0.0),
                            end: Offset.zero)
                            .animate(animation);

                        if (child.key.toString() == widget.count.toString()) {
                          return ClipRect(
                            child: SlideTransition(
                                position: inAnimation, child: child),
                          );
                        } else {
                          return ClipRect(
                            child: SlideTransition(
                                position: outAnimation, child: child),
                          );
                        }
                      },
                      child: SizedBox(
                        key: Key(widget.count.toString()),
                        width: 32.0,
                        height: 32.0,
                        child: Center(
                          child: Text(
                            widget.count.toString(),
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: widget.countColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: IconButton(
                        onPressed: widget.loading
                            ? null
                            : () {
                          widget.onChange(widget.count + 1);
                        },
                        icon: widget.addIcon,
                        padding: EdgeInsets.zero,
                        color: widget.buttonColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}