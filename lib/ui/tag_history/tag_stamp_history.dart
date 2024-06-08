import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetap/bloc/tag_history/tag_history_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetap/models/tag-stamp/tag_stamp_model.dart';
import 'package:timetap/ui/tag_history/tag_stamp_index.dart';
import '../shared/drawer.dart';
import '../shared/shimmer.dart';

class TagStampHistory extends StatelessWidget {

  Future<List<TagStampModel>> getHistory(BuildContext context) async {
    return await context.read<TagHistoryCubit>().getTagHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.tagHistoryTitle ?? 'Not Found',
        ),
      ),
      endDrawer: const NavigatorDrawer(),
      body: BlocListener<TagHistoryCubit, TagHistoryState>(
        listener: (BuildContext context, TagHistoryState tagStampHistory) {},
        child: FutureBuilder(
          future: getHistory(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return TagStampIndex(tagStamp: snapshot.data![index]);
                },
              );
            } else {
              return ShimmerList();
            }
          }
        ),
      ),
    );
  }
}
