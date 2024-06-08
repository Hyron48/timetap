part of 'tag_stamp_bloc.dart';

class TagStampState extends Equatable {
  final bool isClockedIn;
  final bool showingNfcModal;
  final bool isReadNfc;
  final bool isInError;

  const TagStampState({
    required this.isClockedIn,
    required this.showingNfcModal,
    required this.isReadNfc,
    required this.isInError,
  });

  @override
  List<Object> get props => [];
}

class ClockInSuccessState extends TagStampState {
  const ClockInSuccessState({
    super.isClockedIn = true,
    super.showingNfcModal = false,
    super.isReadNfc = true,
    super.isInError = false,
  });
}

class ClockInErrorState extends TagStampState {
  const ClockInErrorState({
    super.isClockedIn = false,
    super.showingNfcModal = false,
    super.isReadNfc = false,
    super.isInError = true,
  });
}

class ReadNfcState extends TagStampState {
  const ReadNfcState({
    super.isClockedIn = false,
    super.showingNfcModal = true,
    super.isReadNfc = true,
    super.isInError = false,
  });
}

class ClockingInState extends TagStampState {
  const ClockingInState({
    super.isClockedIn = false,
    super.showingNfcModal = true,
    super.isReadNfc = false,
    super.isInError = false,
  });
}

class ClockInInitialState extends TagStampState {
  const ClockInInitialState({
    super.isClockedIn = false,
    super.showingNfcModal = false,
    super.isReadNfc = false,
    super.isInError = false,
  });
}
