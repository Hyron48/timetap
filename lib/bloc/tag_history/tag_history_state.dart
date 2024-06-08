part of 'tag_history_cubit.dart';

class TagHistoryState extends Equatable {
  final List<TagStampModel> tagsHistory;

  const TagHistoryState({
    this.tagsHistory = const [],
  });

  @override
  List<Object> get props => [tagsHistory];
}
