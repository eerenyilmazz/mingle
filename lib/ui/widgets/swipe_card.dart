import 'package:flutter/material.dart';
import '../../data/db/entity/app_user.dart';
import '../../utils/constants.dart';
import '../widgets/rounded_icon_button.dart';

class SwipeCard extends StatefulWidget {
  final AppUser person;
  final void Function() onSwipeLeft;
  final void Function() onSwipeRight;

  SwipeCard({
    required this.person,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> with SingleTickerProviderStateMixin {
  bool showInfo = false;
  Offset startDragOffset = Offset.zero;
  Offset currentDragOffset = Offset.zero;
  AnimationController? _animationController;
  Animation<Offset>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    startDragOffset = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      currentDragOffset = details.localPosition - startDragOffset;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dx = currentDragOffset.dx;

    if (dx > 100) {
      _animateCard(Offset(MediaQuery.of(context).size.width, 0), widget.onSwipeRight);
    } else if (dx < -100) {
      _animateCard(Offset(-MediaQuery.of(context).size.width, 0), widget.onSwipeLeft);
    } else {
      _resetCardPosition();
    }
  }

  void _animateCard(Offset targetOffset, Function onSwipe) {
    _animation = Tween<Offset>(begin: currentDragOffset, end: targetOffset).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          onSwipe();
          _resetCardPosition();
        }
      });

    _animationController?.forward(from: 0);
  }

  void _resetCardPosition() {
    setState(() {
      currentDragOffset = Offset.zero;
    });
    _animationController?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          final offset = _animation?.value ?? currentDragOffset;
          return Transform.translate(
            offset: offset,
            child: child,
          );
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.725,
              width: MediaQuery.of(context).size.width * 0.85,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.network(widget.person.profilePhotoPath, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: showInfo ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4) : const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.person.name,
                                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: kPrimaryColor),
                                    ),
                                    TextSpan(text: '  ${widget.person.age}', style: const TextStyle(fontSize: 20, color:kPrimaryColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          RoundedIconButton(
                            onPressed: () {
                              setState(() {
                                showInfo = !showInfo;
                              });
                            },
                            iconData: showInfo ? Icons.arrow_downward : Icons.person,
                            iconSize: 16,
                            buttonColor: kAccentColor,
                          ),
                        ],
                      ),
                    ),
                    showInfo ? const Divider(color: kAccentColor, thickness: 1.5, height: 0) : Container(),
                    showInfo
                        ? Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        color: Colors.black.withOpacity(.7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Opacity(
                              opacity: 0.8,
                              child: Text(
                                widget.person.bio.isNotEmpty ? widget.person.bio : "No bio.",
                                style: Theme.of(context).textTheme.bodyText1?.copyWith(color: kPrimaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
