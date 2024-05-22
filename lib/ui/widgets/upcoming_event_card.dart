import 'package:flutter/material.dart';
import 'package:mingle/ui/widgets/ui_helper.dart';

import '../../data/model/event_model.dart';
import '../../utils/constants.dart';
import '../../utils/datetime_utils.dart';
import '../../utils/text_style.dart';


class UpComingEventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  const UpComingEventCard({Key? key, required this.event, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: <Widget>[
          Expanded(child: buildImage()),
          UIHelper.verticalSpace(24),
          buildEventInfo(context),
        ],
      ),
    );
  }

  Widget buildImage() {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: imgBG,
          width: double.infinity,
          child: Hero(
            tag: 'upcoming_event_${event.id}',
            child: Image.network(
              event.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEventInfo(BuildContext context) {
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
        UIHelper.horizontalSpace(16),
        Expanded( // Eklendi: Row'un genişliğini genişletmek için Expanded widget eklendi
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.name, style: titleStyle),
              UIHelper.verticalSpace(4),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, size: 16, color: Theme.of(context).primaryColor),
                  UIHelper.horizontalSpace(4),
                  Expanded(
                    child: Text(
                      event.location.toUpperCase(),
                      style: subtitleStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
