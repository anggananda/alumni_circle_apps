import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/cubit/reply/cubit/reply_cubit.dart';
import 'package:alumni_circle_app/dto/diskusi.dart';
import 'package:alumni_circle_app/dto/reply.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/update_discussion_page.dart';
import 'package:alumni_circle_app/services/data_service.dart';
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

  void _fetchData() {
    BlocProvider.of<ReplyCubit>(context)
        .fetchReply(widget.diskusi.idDiskusi);
  }

  void _sendReply() async {
    final profile = context.read<ProfileCubit>();
    final currentState = profile.state;

    final idAlumni = currentState.idAlumni;
    final idDiskusi = widget.diskusi.idDiskusi;
    final reply = _replyController.text;

    debugPrint('$idAlumni, $idDiskusi, $reply');

    final send = context.read<ReplyCubit>(); // Gunakan DiskusiCubit
    send.sendReply(idAlumni, idDiskusi, reply); // Panggil method sendDiskusi
    ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Create Discussion')));
    _replyController.clear();
  }

  void _updateReply(Replies replies) async {
    TextEditingController contentController =
        TextEditingController(text: replies.isiReply);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 16,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Edit Reply',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        try {

                          final update = context.read<ReplyCubit>(); // Gunakan DiskusiCubit
                          update.updateReply(replies.idReply, contentController.text); // Panggil method sendDiskusi
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 16,
                                child: Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Success',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Reply updated successfully.',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } catch (error) {
                          print('Failed to update reply: $error');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 16,
                                child: Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Error',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Failed to update reply. Please try again.',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteReply(idReply) async {
    final deleteCubit = context.read<ReplyCubit>();
    deleteCubit.deleteReply(idReply);
    if(deleteCubit.state.errorMessage == ''){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Delete Reply')));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to Delete Reply')));
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
                          Row(
                            children: [
                              IconButton(
                                onPressed: (){},
                                icon: const Icon(
                                  Icons.thumb_up,
                                  size: 22,
                                ),
                              ),
                              Text("0"),
                              IconButton(
                                onPressed: (){},
                                icon: const Icon(
                                  Icons.thumb_down,
                                  size: 22,
                                ),
                              ),
                              Text("0"),
                            ],
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
                    return Center(child: Text('No discussion data available'));
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
                                                    IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15.0),
                                                                ),
                                                                title:
                                                                    const Text(
                                                                  "Confirm Delete",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                                content:
                                                                    const Text(
                                                                  "Are you sure you want to delete this reply?",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    child:
                                                                        const Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                  ElevatedButton(
                                                                    child:
                                                                        const Text(
                                                                      "Delete",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .red,
                                                                      onPrimary:
                                                                          Colors
                                                                              .redAccent,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      _deleteReply(
                                                                          reply
                                                                              .idReply);
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete)),
                                                    IconButton(
                                                        onPressed: () {
                                                          _updateReply(reply);
                                                        },
                                                        icon: Icon(Icons.edit))
                                                  ],
                                                )
                                              : Container());
                                        },
                                      ),
                                    ],
                                  ),
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
