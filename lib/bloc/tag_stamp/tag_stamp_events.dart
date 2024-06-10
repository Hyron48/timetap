part of 'tag_stamp_bloc.dart';

abstract class TagStampEvent extends Equatable {
  const TagStampEvent();

  @override
  List<Object> get props => [];
}

class ExecClockIn extends TagStampEvent {}

class CancelClockIn extends TagStampEvent {}
