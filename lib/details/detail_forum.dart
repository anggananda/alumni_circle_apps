import 'package:alumni_circle_app/components/toggle_action_widget.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/cubit/reply/cubit/reply_cubit.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/dto/reply.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailForum extends StatefulWidget {
  final Diskusi diskusi;
  const DetailForum({Key? key, required this.diskusi}) : super(key: key);

  @override
  State<DetailForum> createState() => _DetailForumState();
}

class _DetailForumState extends State<DetailForum> {
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _fetchData() {
    BlocProvider.of<ReplyCubit>(context).fetchReply(widget.diskusi.idDiskusi);
  }

  void _sendReply() async {
    final profile = context.read<ProfileCubit>();
    final currentState = profile.state;

    final idAlumni = currentState.idAlumni;
    final idDiskusi = widget.diskusi.idDiskusi;
    final reply = _replyController.text;

    if (reply.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill the reply')));
      return;
    }

    debugPrint('$idAlumni, $idDiskusi, $reply');

    final send = context.read<ReplyCubit>(); // Gunakan DiskusiCubit
    send.sendReply(idAlumni, idDiskusi, reply); // Panggil method sendDiskusi
    if (send.state.errorMessage == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Success to post reply')));
      _replyController.clear();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to post reply')));
    }
  }

  void _formUpdate(Replies replies) {
    TextEditingController contentController =
        TextEditingController(text: replies.isiReply);
    showEditReplyDialog(
      context: context,
      contentController: contentController,
      onUpdate: () {
        _updateReply(replies.idReply,
            contentController.text); // Replace with actual idReply
      },
      primaryColor: primaryColor,
    );
  }

  void _updateReply(int idReply, String content) {
    final update = context.read<ReplyCubit>(); // Gunakan DiskusiCubit
    update.updateReply(idReply, content); // Panggil method sendDiskusi

    Navigator.of(context).pop();
    if (update.state.errorMessage == '') {
      showSuccessDialog(context, 'Successfully Update');
      _replyController.clear();
    } else {
      showErrorDialog(context, 'Failed to update');
    }
  }

  void _deleteReply(idReply) async {
    final deleteCubit = context.read<ReplyCubit>();
    deleteCubit.deleteReply(idReply);
    if (deleteCubit.state.errorMessage == '') {
      showSuccessDialog(context, 'Success Delete Reply');
    } else {
      showErrorDialog(context, 'Failed to delete reply');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discussion',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  color: thirdColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                '${Endpoints.urlUas}/static/storages/${widget.diskusi.fotoProfile}'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.diskusi.namaAlumni,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  widget.diskusi.email,
                                  style: const TextStyle(
                                    color: secondaryFontColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.diskusi.subjekDiskusi,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.diskusi.isiDiskusi,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(color: primaryFontColor),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDateString(widget.diskusi.tanggal),
                            style: const TextStyle(color: secondaryFontColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Replies",
                          style: TextStyle(
                            color: primaryFontColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<ReplyCubit, ReplyState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state.errorMessage.isNotEmpty) {
                      return Center(child: Text(state.errorMessage));
                    } else if (state.replyList.isEmpty) {
                      return Center(
                          child: Text('No discussion data available'));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.replyList.length,
                        itemBuilder: (context, index) {
                          final reply = state.replyList[index];
                          return Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: thirdColor,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            '${Endpoints.urlUas}/static/storages/${reply.fotoProfile}'),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              reply.namaAlumni,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              reply.email,
                                              style: const TextStyle(
                                                color: secondaryFontColor,
                                              ),
                                            ),
                                            Text(
                                              '${formatDateString(reply.tanggal)}',
                                              style: const TextStyle(
                                                color: secondaryFontColor,
                                                fontSize: 10
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      BlocBuilder<ProfileCubit, ProfileState>(
                                        builder: (context, state) {
                                          return (reply.idAlumni ==
                                                      state.idAlumni ||
                                                  state.roles == 'admin'
                                              ? Row(
                                                  children: [
                                                    ReplyActions(
                                                      onDelete: () =>
                                                          _deleteReply(
                                                              reply.idReply),
                                                      onEdit: () =>
                                                          _formUpdate(reply),
                                                    ),
                                                  ],
                                                )
                                              : Container());
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Text(
                                    reply.isiReply,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: thirdColor,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _replyController,
                      decoration: const InputDecoration(
                        hintText: 'Type your comment...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: primaryFontColor),
                    onPressed: _sendReply,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
