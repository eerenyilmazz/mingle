import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant/text_style.dart';
import '../models/event_model.dart';
import '../services/event_service.dart'; // EventService'ı ekledik
import '../utils/app_utils.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/home_bg_color.dart';
import '../widgets/nearby_event_card.dart';
import '../widgets/ui_helper.dart';
import '../widgets/upcoming_event_card.dart';
import 'event_detail_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key}); // Key'yi düzelttim

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;

  late ScrollController scrollController = ScrollController();
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..forward();
  late AnimationController opacityController = AnimationController(
    vsync: this,
    duration: const Duration(microseconds: 1),
  );
  late Animation<double> opacity;

  final EventService _eventService = EventService(); // EventService örneği oluşturduk

  void viewEventDetail(Event event) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: EventDetailPage(event),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    opacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: opacityController,
    ));
    scrollController.addListener(() {
      opacityController.value = offsetToOpacity(
          currentOffset: scrollController.offset, maxOffset: scrollController.position.maxScrollExtent / 2);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          HomeBackgroundColor(opacity),
          SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildSearchAppBar(),
                UIHelper.verticalSpace(16),
                FutureBuilder<List<Event>>(
                  future: _eventService.getUpcomingEvents(DateTime.now().add(const Duration(days: 7))), // Yaklaşık 1 hafta sonrasına kadar olan etkinlikleri getiriyoruz
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Veriler yüklenirken gösterilecek yüklenme animasyonu
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Hata durumunda hata mesajı göster
                    } else {
                      return buildUpComingEventList(snapshot.data!); // Veriler geldiyse etkinlik listesini oluştur
                    }
                  },
                ),

                UIHelper.verticalSpace(16),
                FutureBuilder<List<Event>>(
                  future: _eventService.getNearbyEvents(), // Firebase'den yakındaki etkinlikleri çekiyoruz
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Veriler yüklenirken gösterilecek yüklenme animasyonu
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Hata durumunda hata mesajı göster
                    } else {
                      return buildNearbyConcerts(snapshot.data!); // Veriler geldiyse yakındaki etkinlik listesini oluştur
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomePageButtonNavigationBar(
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(FontAwesomeIcons.qrcode),
      ),
    );
  }

  Widget buildSearchAppBar() {
    const inputBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    );
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: inputBorder,
        ),
      ),
    );
  }

  Widget buildUpComingEventList(List<Event> events) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Upcoming Events",
            style: headerStyle.copyWith(color: Colors.white),
          ),
          UIHelper.verticalSpace(16),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: events.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final event = events[index];
                return UpComingEventCard(event: event, onTap: () => viewEventDetail(event));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNearbyConcerts(List<Event> events) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text("Nearby Concerts", style: headerStyle),
              const Spacer(),
              const Icon(Icons.more_horiz),
              UIHelper.horizontalSpace(16),
            ],
          ),
          ListView.builder(
            itemCount: events.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              final event = events[index];
              var animation = Tween<double>(begin: 800.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Interval((1 / events.length) * index, 1.0, curve: Curves.decelerate),
                ),
              );
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(animation.value, 0.0),
                  child: NearbyEventCard(
                    event: event,
                    onTap: () => viewEventDetail(event),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
