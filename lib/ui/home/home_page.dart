import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timetap/bloc/tag_stamp/tag_stamp_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timetap/ui/shared/drawer.dart';
import 'package:timetap/utils/routes.dart';
import '../../models/tag-stamp/tag_stamp_modal_info.dart';
import '../../utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> showGeneralDialog(
      BuildContext context, TagStampModalInfo info) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: info.title,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: Center(child: info.icon),
                ),
                SizedBox(
                  height: 16,
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

  void refreshAlertDialog(BuildContext context) {
    BlocProvider.of<TagStampBloc>(context).add(CancelClockIn());
    BlocProvider.of<TagStampBloc>(context).add(ExecClockIn());
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TagStampBloc>(context).add(ExecClockIn());
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            AppLocalizations.of(context)?.homeHeader ?? 'Not Found',
            style: TextStyle(fontSize: fontSizeTitle, color: bluePrimary),
          ),
        ),
      ),
      endDrawer: const NavigatorDrawer(),
      body: BlocListener<TagStampBloc, TagStampState>(
        listener: (BuildContext context, TagStampState tagStampState) {
          TagStampModalInfo info = TagStampModalInfo();
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }

          if (tagStampState is ClockInCancelledState) {
            return;
          }

          if (tagStampState is ClockingInState) {
            info.title = Text(
              AppLocalizations.of(context)?.readNFCHeader ?? 'Not Found',
              style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: mediumFontWeight,
                  color: bluePrimary),
            );
            info.icon = SvgPicture.asset(
              'assets/svg/nfc_reading.svg',
              width: 100,
              height: 100,
            );
            info.bodyMessage = Text(
              AppLocalizations.of(context)?.readNFCMessage ?? 'Not Found',
              style: TextStyle(
                  fontSize: fontSizeText, fontWeight: lightFontWeight),
            );
          }

          if (tagStampState is ReadNfcState) {
            info.title = Text(
              AppLocalizations.of(context)?.verifyPhaseHeader ?? 'Not Found',
              style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: mediumFontWeight,
                  color: bluePrimary),
            );
            info.icon = CircularProgressIndicator(color: black);
            info.bodyMessage = Text(
              AppLocalizations.of(context)?.verifyPhaseMessage ?? 'Not Found',
              style: TextStyle(
                  fontSize: fontSizeText, fontWeight: lightFontWeight),
            );
          }

          if (tagStampState is ClockInSuccessState) {
            info.title = Text(
              AppLocalizations.of(context)?.tapSuccessHeader ?? 'Not Found',
              style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: mediumFontWeight,
                  color: bluePrimary),
            );
            info.icon = Icon(
              Icons.check,
              color: black,
              size: 50,
            );
            info.bodyMessage = Text(
              AppLocalizations.of(context)?.tapSuccessMessage ?? 'Not Found',
              style: TextStyle(
                  fontSize: fontSizeText, fontWeight: lightFontWeight),
            );
          }

          if (tagStampState is ClockInErrorState) {
            info.title = Text(
              AppLocalizations.of(context)?.tapErrorHeader ?? 'Not Found',
              style: TextStyle(
                  fontSize: fontSizeTitle,
                  fontWeight: mediumFontWeight,
                  color: bluePrimary),
            );
            info.icon = Icon(
              Icons.error_outline,
              color: black,
              size: 50,
            );
            info.bodyMessage = Text(
              AppLocalizations.of(context)?.generalErrorMessage ?? 'Not Found',
              style: TextStyle(
                  fontSize: fontSizeText, fontWeight: lightFontWeight),
            );
            info.btn = ElevatedButton(
              onPressed: () =>
                  BlocProvider.of<TagStampBloc>(context).add(ExecClockIn()),
              style: ElevatedButton.styleFrom(
                backgroundColor: bluePrimary,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)?.retryBtn ?? 'Not Found',
                style: TextStyle(color: white),
              ),
            );
          }

          if (tagStampState is NoSensorActiveState) {
            info.title = Text(
              AppLocalizations.of(context)?.sensorDisabledTitle ?? 'Not Found',
              style: TextStyle(
                  fontSize: fontSizeTitle, fontWeight: mediumFontWeight),
            );
            info.icon = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.nfc,
                  color: black,
                ),
                SizedBox(
                  width: 16,
                ),
                Icon(
                  Icons.gps_fixed,
                  color: black,
                ),
              ],
            );
            info.bodyMessage = Text(
              AppLocalizations.of(context)?.sensorDisabledMessage ??
                  'Not Found',
              style: TextStyle(
                  fontSize: fontSizeText, fontWeight: lightFontWeight),
            );
            info.btn = ElevatedButton(
              onPressed: () =>
                  BlocProvider.of<TagStampBloc>(context).add(ExecClockIn()),
              style: ElevatedButton.styleFrom(
                backgroundColor: bluePrimary,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)?.retryBtn ?? 'Not Found',
                style: TextStyle(color: white),
              ),
            );
          }

          showGeneralDialog(context, info);

          if (tagStampState is ClockInSuccessState) {
            BlocProvider.of<TagStampBloc>(context).add(CancelClockIn());
            Future.delayed(
              const Duration(seconds: 3),
              () => Navigator.of(context).popAndPushNamed(Routes.tagHistoryRoute),
            );
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => refreshAlertDialog(context),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/logo_home_placeholder.svg',
                  width: (MediaQuery.of(context).size.width / 2.6),
                  height: (MediaQuery.of(context).size.height / 2.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
