import 'package:alumni_circle_app/components/custom_search_box.dart';
import 'package:alumni_circle_app/components/error_widget.dart';
import 'package:alumni_circle_app/components/paggination_page.dart';
import 'package:alumni_circle_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:alumni_circle_app/cubit/feedback/cubit/feedback_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // String _searchQuery = '';

  late TextEditingController _searchController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _fetchData() {
    final accessToken = context.read<AuthCubit>().state.accessToken;
    BlocProvider.of<FeedbackCubit>(context)
        .fetchFeedback(_currentPage, _searchController.text, accessToken!);
  }

  void _sendFeedback() async {
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;
    final feedback = _feedbackController.text;

    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill in the data in the feedback box')));
      return;
    }
    final accessToken = context.read<AuthCubit>().state.accessToken;

    final send = context.read<FeedbackCubit>(); // Gunakan DiskusiCubit
    send.sendFeedback(currentState.idAlumni, feedback, _currentPage,
        accessToken!); // Panggil method sendDiskusi

    if (send.state.errorMessage == '') {
      showSuccessDialog(context, 'post success.');
      _feedbackController.clear();
    } else {
      showErrorDialog(context, 'Failed to post');
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      // _searchQuery = value;
      _currentPage = 1; // Reset halaman ke 1 saat melakukan pencarian
    });
    _fetchData();
  }

  void _onSearchCleared() {
    setState(() {
      // _searchQuery = "";
      _currentPage = 1; // Reset halaman ke 1 saat pencarian dihapus
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state.roles == 'admin') {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Feedback Hub',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: primaryFontColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: CustomSearchBox(
                        controller: _searchController,
                        onChanged: (value) => _onSearchChanged(value),
                        onClear: () => _onSearchCleared(),
                        hintText: 'Search Forum...',
                      ),
                    ),
                    BlocBuilder<FeedbackCubit, FeedbackState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state.errorMessage.isNotEmpty) {
                          return BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return ErrorDisplay(
                                message: "Failed to fetch discussion",
                                onRetry: () {
                                  context.read<FeedbackCubit>().fetchFeedback(
                                      1,
                                      '',
                                      state
                                          .accessToken!); // Retry fetching events
                                },
                              );
                            },
                          );
                        } else if (state.feedbackList.isEmpty) {
                          return const Center(
                              child: Text('No discussion data available'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.feedbackList.length,
                            itemBuilder: (context, index) {
                              final feedback = state.feedbackList[index];
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: thirdColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 52, 42, 42),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${Endpoints.urlUas}/static/storages/${feedback.fotoProfile}'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          feedback.namaAlumni,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                primaryFontColor,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  const Text(
                                                    'Feedback 💚:',
                                                    style: TextStyle(
                                                        color: primaryFontColor,
                                                        fontSize: 14,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    feedback.isiFeedback,
                                                    style: const TextStyle(
                                                        color: primaryFontColor,
                                                        fontSize: 16),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    feedback.email,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: secondaryFontColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    formatDateString(
                                                        feedback.tanggal),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: secondaryFontColor,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
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
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PaginationButton(
                            buttonTo: 'decrement',
                            color: colors2,
                            icon: Icons.arrow_back,
                            text: 'Previous',
                            isEnabled: _currentPage > 1,
                            onTap: () {
                              setState(() {
                                if (_currentPage > 1) {
                                  _currentPage--;
                                  _fetchData();
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Page $_currentPage',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 20),
                          BlocBuilder<FeedbackCubit, FeedbackState>(
                            builder: (context, state) {
                              return PaginationButton(
                                buttonTo: 'increment',
                                color: colors2,
                                icon: Icons.arrow_forward,
                                text: 'Next',
                                isEnabled: state.feedbackList.isNotEmpty,
                                onTap: () {
                                  setState(() {
                                    if (state.feedbackList.isNotEmpty) {
                                      _currentPage++;
                                      _fetchData();
                                    }
                                  });
                                },
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.9),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: const ListTile(
                        title: Text(
                          "Feedback",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: primaryFontColor,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "How can we assist you today?",
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryFontColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Feedback ❤️",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryFontColor),
                                  ),
                                ),
                                TextFormField(
                                  controller: _feedbackController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter the feedback content',
                                    filled: true,
                                    fillColor: thirdColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintStyle: const TextStyle(
                                        color: secondaryFontColor),
                                  ),
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _sendFeedback();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: primaryFontColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
              }
            },
          ),
        ));
  }
}
