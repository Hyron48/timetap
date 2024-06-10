part of 'tag_stamp_bloc.dart';

class TagStampState extends Equatable {
  const TagStampState();

  @override
  List<Object> get props => [];
}

class ClockInSuccessState extends TagStampState {}

class ClockInErrorState extends TagStampState {}

class ReadNfcState extends TagStampState {}

class ClockingInState extends TagStampState {}

class ClockInInitialState extends TagStampState {}

class ClockInCancelledState extends TagStampState {}

class NoSensorActiveState extends TagStampState {}
