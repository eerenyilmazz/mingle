import 'package:flutter/material.dart';
import 'package:mingle/utils/constants.dart';
import '../../../data/db/remote/event_service.dart';
import '../../../data/db/entity/event.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/text_style.dart';
import '../../widgets/home_bg_color.dart';
import '../../widgets/nearby_event_card.dart';
import '../../widgets/ui_helper.dart';
import '../../widgets/upcoming_event_card.dart';
import '../event_detail_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  static const String id = 'homepage_screen';


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

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

  final EventService _eventService = EventService();
  List<Event> _upcomingEvents = [];
  List<Event> _nearbyEvents = [];
  String _searchQuery = '';

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
    _loadData();
  }

  Future<void> _loadData() async {
    final upcomingEvents = await _eventService.getUpcomingEvents(DateTime.now().add(const Duration(days: 7)));
    final nearbyEvents = await _eventService.getNearbyEvents();
    setState(() {
      _upcomingEvents = upcomingEvents;
      _nearbyEvents = nearbyEvents;
    });
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
                buildUpComingEventList(),
                UIHelper.verticalSpace(16),
                buildNearbyConcerts(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchAppBar() {
    const inputBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: kPrimaryColor),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        style: const TextStyle(color: kPrimaryColor),
        decoration: const InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 24),
          border: inputBorder,
          enabledBorder: inputBorder,
          focusedBorder: inputBorder,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget buildUpComingEventList() {
    final filteredEvents = _upcomingEvents.where((event) => event.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Upcoming Events",
            style: headerStyle.copyWith(color: kPrimaryColor),
          ),
          UIHelper.verticalSpace(16),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: filteredEvents.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return UpComingEventCard(event: event, onTap: () => viewEventDetail(event));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNearbyConcerts() {
    final filteredEvents = _nearbyEvents.where((event) => event.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        color: kPrimaryColor,
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
            itemCount: filteredEvents.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              var animation = Tween<double>(begin: 800.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Interval((1 / filteredEvents.length) * index, 1.0, curve: Curves.decelerate),
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
