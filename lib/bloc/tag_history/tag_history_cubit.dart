import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/tag-stamp/tag_stamp_model.dart';
import '../../repository/tag_stamp/tag_stamp_repository.dart';

part 'tag_history_state.dart';

class TagHistoryCubit extends Cubit<TagHistoryState> {
  final TagStampRepository _tagStampRepository;

  TagHistoryCubit(this._tagStampRepository) : super(const TagHistoryState());

  Future<List<TagStampModel>> getTagHistory() async {
    return await _tagStampRepository.getAllTagStamp();
  }
}
