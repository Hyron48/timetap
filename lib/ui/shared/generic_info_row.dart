import 'package:flutter/cupertino.dart';

import '../../utils/constants.dart';

class GenericInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const GenericInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: darkGrey, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(color: black, fontSize: 16),
        ),
      ],
    );
  }
}
