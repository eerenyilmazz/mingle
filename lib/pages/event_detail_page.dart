import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/color.dart';
import '../constant/text_style.dart';
import '../models/event_model.dart';
import '../utils/datetime_utils.dart';
import '../widgets/ui_helper.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage(this.event, {super.key});

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with TickerProviderStateMixin {
  late Event event;
  late AnimationController controller;
  late AnimationController bodyScrollAnimationController;
  late ScrollController scrollController;
  late Animation<double> scale;
  late Animation<double> appBarSlide;
  double headerImageSize = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    bodyScrollAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset >= headerImageSize / 2) {
          if (!bodyScrollAnimationController.isCompleted) {
            bodyScrollAnimationController.forward();
          }
        } else {
          if (bodyScrollAnimationController.isCompleted) {
            bodyScrollAnimationController.reverse();
          }
        }
      });

    appBarSlide = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: bodyScrollAnimationController,
    ));

    scale = Tween(begin: 1.0, end: 0.5).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: controller,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    bodyScrollAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    headerImageSize = MediaQuery.of(context).size.height / 2.5;
    return ScaleTransition(
      scale: scale,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildHeaderImage(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          buildEventTitle(),
                          UIHelper.verticalSpace(16),
                          buildEventDate(),
                          UIHelper.verticalSpace(24),
                          buildAboutEvent(),
                          UIHelper.verticalSpace(24),
                          buildOrganizeInfo(),
                          UIHelper.verticalSpace(24),
                          buildEventLocation(),
                          UIHelper.verticalSpace(124),
                          //...List.generate(10, (index) => ListTile(title: Text("Dummy content"))).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildPriceInfo(),
              ),
              AnimatedBuilder(
                animation: appBarSlide,
                builder: (context, snapshot) {
                  return Transform.translate(
                    offset: Offset(0.0, -1000 * (1 - appBarSlide.value)),
                    child: Material(
                      elevation: 2,
                      color: Theme.of(context).primaryColor,
                      child: buildHeaderButton(hasTitle: true),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderImage() {
    double maxHeight = MediaQuery.of(context).size.height;
    double minimumScale = 0.8;
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        controller.value += detail.primaryDelta! / maxHeight * 2;
      },
      onVerticalDragEnd: (detail) {
        if (scale.value > minimumScale) {
          controller.reverse();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Stack(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: headerImageSize,
            child: Hero(
              tag: 'event_details${event.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                child: Image.network(
                  event.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          buildHeaderButton(),
        ],
      ),
    );
  }

  Widget buildHeaderButton({bool hasTitle = false}) {
    final border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Card(
              shape: border,
              elevation: 0,
              margin: const EdgeInsets.all(0),
              color: hasTitle ? Theme.of(context).primaryColor : Colors.white,
              child: InkWell(
                customBorder: border,
                onTap: () {
                  if (bodyScrollAnimationController.isCompleted) {
                    bodyScrollAnimationController.reverse();
                  }
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: hasTitle ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            if (hasTitle)
              Text(event.name, style: titleStyle.copyWith(color: Colors.white)),
            Card(
              shape: const CircleBorder(),
              elevation: 0,
              color: Theme.of(context).primaryColor,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => setState(() => isFavorite = !isFavorite),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEventTitle() {
    return Text(
      event.name,
      style: headerStyle.copyWith(fontSize: 32),
    );
  }

  Widget buildEventDate() {
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(DateTimeUtils.getMonth(event.eventDate), style: monthStyle),
              Text(DateTimeUtils.getDayOfMonth(event.eventDate), style: titleStyle),
            ],
          ),
        ),
        UIHelper.horizontalSpace(12),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(DateTimeUtils.getDayOfWeek(event.eventDate), style: titleStyle),
            UIHelper.verticalSpace(4),
            Text(
              DateFormat('hh:mm a').format(event.eventDate.toLocal()),
              style: subtitleStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAboutEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("About", style: headerStyle),
        UIHelper.verticalSpace(),
        Text(event.description, style: subtitleStyle),
        UIHelper.verticalSpace(8),
      ],
    );
  }

  Widget buildOrganizeInfo() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          child: Text(event.organizer[0]),
        ),
        UIHelper.horizontalSpace(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(event.organizer, style: titleStyle),
            UIHelper.verticalSpace(4),
            const Text("Organizer", style: subtitleStyle),
          ],
        ),
      ],
    );
  }

  Widget buildEventLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Location',
          style: headerStyle,
        ),
        UIHelper.verticalSpace(8),
        GestureDetector(
          onTap: () {
            _launchMaps();
          },
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                event.location,
                style: subtitleStyle.copyWith(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _launchMaps() async {
    String location = event.location.replaceAll(' ', '+');
    String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  Widget buildPriceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Price", style: subtitleStyle),
                UIHelper.verticalSpace(8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "\$${event.price}",
                        style: titleStyle.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      const TextSpan(
                        text: "/per person",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {},
              child: Text(
                "Get a Ticket",
                style: titleStyle.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
