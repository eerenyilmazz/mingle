import 'package:flutter/material.dart';
import 'package:mingle/ui/widgets/ui_helper.dart';
import '../../utils/constants.dart';
import '../../utils/text_style.dart';
import '../../data/model/event_model.dart';
import '../../utils/datetime_utils.dart';

class NearbyEventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  const NearbyEventCard({super.key, required this.event, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            buildImage(),
            buildEventInfo(context),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: imgBG,
        width: 80,
        height: 100,
        child: Hero(
          tag: 'nearby_event_${event.id}',
          child: Image.network(
            event.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildEventInfo(context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(DateTimeUtils.getFullDate(event.eventDate), style: monthStyle),
          UIHelper.verticalSpace(8),
          Text(event.name, style: titleStyle),
          UIHelper.verticalSpace(8),
          Row(
            children: <Widget>[
              Icon(Icons.location_on, size: 16, color: Theme.of(context).primaryColor),
              UIHelper.horizontalSpace(4),
              Text(event.location.toUpperCase(), style: subtitleStyle),
            ],
          ),
        ],
      ),
    );
  }
}
