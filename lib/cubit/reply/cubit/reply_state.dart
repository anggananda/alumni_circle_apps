part of 'reply_cubit.dart';

@immutable
class ReplyState {
  final List<Replies> replyList;
  final int idDiskusi;
  final bool isLoading;
  final String errorMessage;

  const ReplyState({
    required this.replyList,
    required this.idDiskusi,
    required this.isLoading,
    required this.errorMessage,
  });

  const ReplyState.initial()
      : replyList = const [],
        idDiskusi = 0,
        isLoading = false,
        errorMessage = '';

  ReplyState copyWith({
    List<Replies>? replyList,
    int? idDiskusi,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReplyState(
      replyList: replyList ?? this.replyList,
      idDiskusi: idDiskusi ?? this.idDiskusi,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

