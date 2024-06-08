import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timetap/models/tag-stamp/tag_stamp_model.dart';
import 'package:timetap/utils/routes.dart';

import '../../utils/constants.dart';

class TagStampIndex extends StatelessWidget {
  final TagStampModel tagStamp;

  const TagStampIndex({
    super.key,
    required this.tagStamp,
  });

  String formatDateTime(String dateTimeString) {
    DateTime parsedDate = DateTime.parse(dateTimeString);

    DateTime localDate = parsedDate.toLocal();

    DateFormat formatter = DateFormat('dd-MM-yy HH:mm');
    return formatter.format(localDate);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Hero(
        tag: tagStamp.id,
        child: Text(
          tagStamp.positionLabel,
          style: TextStyle(color: black, fontSize: 15),
        ),
      ),
      trailing: Text(
        formatDateTime(tagStamp.timeCode.toString()),
        style: TextStyle(color: darkGrey, fontSize: 12),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(Routes.tagStampDetailRoute, arguments: tagStamp);
      },
    );
  }
}
