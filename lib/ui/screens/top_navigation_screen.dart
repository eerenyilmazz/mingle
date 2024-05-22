import 'package:flutter/material.dart';
import 'package:mingle/ui/screens/top_navigation_screens/profile_screen.dart';
import '../../data/model/top_navigation_item.dart';
import 'home_page.dart';
import 'top_navigation_screens/chats_screen.dart';
import 'top_navigation_screens/match_screen.dart';

class TopNavigationScreen extends StatelessWidget {
  static const String id = 'top_navigation_screen';
  final List<TopNavigationItem> navigationItems = [
    TopNavigationItem(
      screen: const MyHomePage(),
      iconData: Icons.home,
    ),
    TopNavigationItem(
      screen: ProfileScreen(),
      iconData: Icons.person,
    ),
    TopNavigationItem(
      screen: ChatsScreen(),
      iconData: Icons.message_rounded,
    ),
    TopNavigationItem(
      screen: MatchScreen(),
      iconData: Icons.favorite,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var tabBar = TabBar(
      tabs: navigationItems
          .map((navItem) => SizedBox(
              height: double.infinity,
              child: Tab(icon: Icon(navItem.iconData, size: 26))))
          .toList(),
    );

    var appBar = AppBar(flexibleSpace: tabBar);

    return DefaultTabController(
      length: navigationItems.length,
      child: SafeArea(
        child: Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  tabBar.preferredSize.height -
                  appBar.preferredSize.height,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: navigationItems
                      .map((navItem) => navItem.screen)
                      .toList()),
            ),
          ),
        ),
      ),
    );
  }
}
