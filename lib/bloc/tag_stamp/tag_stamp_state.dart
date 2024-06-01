part of 'tag_stamp_bloc.dart';

class TagStampState extends Equatable {
  final bool isClockIn;
  final bool showingNfcModal;

  const TagStampState({
    required this.isClockIn,
    required this.showingNfcModal,
  });

  @override
  List<Object> get props => [];
}

class ClockInSuccessState extends TagStampState {
  const ClockInSuccessState({
    super.isClockIn = true,
    super.showingNfcModal = false,
  });
}

class ClockInErrorState extends TagStampState {
  const ClockInErrorState({
    super.isClockIn = false,
    super.showingNfcModal = false,
  });
}

class ClockingInState extends TagStampState {
  const ClockingInState({
    super.isClockIn = false,
    super.showingNfcModal = true,
  });
}

class ClockInInitialState extends TagStampState {
  const ClockInInitialState({
    super.isClockIn = false,
    super.showingNfcModal = false,
  });
}
