import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timetap/bloc/tag_stamp/tag_stamp_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetap/ui/shared/drawer.dart';
import '../../models/tag-stamp/tag_stamp_modal_info.dart';
import '../../utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> showGeneralDialog(BuildContext context, TagStampModalInfo info) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: info.title,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: Center(child: info.icon),
                ),
                if (info.bodyMessage != null) info.bodyMessage!,
                if (info.btn != null) info.btn!
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.homeHeader ?? 'Not Found',
        ),
      ),
      endDrawer: const NavigatorDrawer(),
      body: BlocListener<TagStampBloc, TagStampState>(
        listener: (BuildContext context, TagStampState tagStampState) {
          TagStampModalInfo info = TagStampModalInfo();
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }

          if (tagStampState is ClockingInState) {
            info.title = Text(
              AppLocalizations.of(context)?.readNFCHeader ?? 'Not Found',
            );
            info.icon = SvgPicture.asset(
              'assets/svg/nfc-reading.svg',
              width: 100,
              height: 100,
            );
            info.bodyMessage = Text(
              AppLocalizations.of(context)?.readNFCMessage ?? 'Not Found',
            );
          }

          if (tagStampState is ReadNfcState) {
            info.title = Text(
              AppLocalizations.of(context)?.verifyPhaseHeader ?? 'Not Found',
            );
            info.icon = CircularProgressIndicator(color: black);
            info.bodyMessage = Text(
              AppLocalizations.of(context)?.verifyPhaseMessage ?? 'Not Found',
            );
          }

          if (tagStampState is ClockInSuccessState) {
            info.title = Text(
              AppLocalizations.of(context)?.tapSuccessHeader ?? 'Not Found',
            );
            info.icon = Icon(
              Icons.check,
              color: black,
            );
            info.bodyMessage = Text(
              AppLocalizations.of(context)?.tapSuccessMessage ?? 'Not Found',
            );
          }

          if (tagStampState is ClockInErrorState) {
            info.title = Text(
              AppLocalizations.of(context)?.tapErrorHeader ?? 'Not Found',
            );
            info.icon = Icon(
              Icons.error_outline,
              color: black,
            );
            info.bodyMessage = Text(
              AppLocalizations.of(context)?.tapErrorMessage ?? 'Not Found',
            );
            info.btn = ElevatedButton(
              onPressed: () {
                BlocProvider.of<TagStampBloc>(context).add(ExecClockIn());
              },
              child: Text('Retry'),
            );
          }

          showGeneralDialog(context, info);

          if (tagStampState is ClockInSuccessState) {
            Future.delayed(const Duration(seconds: 5), () => Navigator.of(context));
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () =>
                  BlocProvider.of<TagStampBloc>(context).add(ExecClockIn()),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/add_clock_in.svg',
                  width: (MediaQuery.of(context).size.width / 2.4),
                  height: (MediaQuery.of(context).size.height / 2.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
