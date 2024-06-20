import 'package:alumni_circle_app/components/custom_search_box.dart';
import 'package:alumni_circle_app/components/error_widget.dart';
import 'package:alumni_circle_app/components/paggination_page.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/cubit/question/cubit/question_cubit.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _questionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _searchQuery = '';

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
    _questionController.dispose();
    super.dispose();
  }

  void _fetchData() {
    BlocProvider.of<QuestionCubit>(context)
        .fetchQuestion(_currentPage, _searchController.text);
  }

  void sendQuestion() async {
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;
    final question = _questionController.text;

    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill in the data in the question box')));
      return;
    }

    final send = context.read<QuestionCubit>();
    send.sendQuestion(currentState.idAlumni, question,
        _currentPage); // Panggil method sendDiskusi
    if (send.state.errorMessage == '') {
      showSuccessDialog(context, 'post success.');
      _questionController.clear();
    } else {
      showErrorDialog(context, 'Failed to post');
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 1; // Reset halaman ke 1 saat melakukan pencarian
    });
    _fetchData();
  }

  void _onSearchCleared() {
    setState(() {
      _searchQuery = "";
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
                // return Container(child: ,);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Question Box Center',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: primaryFontColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: CustomSearchBox(
                          controller: _searchController,
                          onChanged: (value) => _onSearchChanged(value),
                          onClear: () => _onSearchCleared(),
                          hintText: 'Search User...',
                        ),
                      ),
                      BlocBuilder<QuestionCubit, QuestionState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state.errorMessage.isNotEmpty) {
                            return ErrorDisplay(
                              message: state.errorMessage,
                              onRetry: () {
                                context.read<QuestionCubit>().fetchQuestion(
                                    1, ''); // Retry fetching events
                              },
                            );
                          } else if (state.questionList.isEmpty) {
                            return Center(
                                child: Text('No discussion data available'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.questionList.length,
                              itemBuilder: (context, index) {
                                final question = state.questionList[index];
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
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
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
                                                        '${Endpoints.urlUas}/static/storages/${question.fotoProfile}'),
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
                                                            question.namaAlumni,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  primaryFontColor,
                                                              fontSize: 14,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      'Question 💙:',
                                                      style: const TextStyle(
                                                          color:
                                                              primaryFontColor,
                                                          fontSize: 14,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      question.isiPertanyaan,
                                                      style: const TextStyle(
                                                          color:
                                                              primaryFontColor,
                                                          fontSize: 16),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      question.email,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            secondaryFontColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      formatDateString(
                                                          question.tanggal),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            secondaryFontColor,
                                                      ),
                                                    ),
                                                    SizedBox(
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
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                            SizedBox(width: 20),
                            Text(
                              'Page $_currentPage',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 20),
                            BlocBuilder<QuestionCubit, QuestionState>(
                              builder: (context, state) {
                                return PaginationButton(
                                  buttonTo: 'increment',
                                  color: colors2,
                                  icon: Icons.arrow_forward,
                                  text: 'Next',
                                  isEnabled: !state.questionList.isEmpty,
                                  onTap: () {
                                    setState(() {
                                      if (!state.questionList.isEmpty) {
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
                  ),
                );
              } else {
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          "Welcome to Help Center",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: primaryFontColor,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Question ❤️",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryFontColor),
                                  ),
                                ),
                                TextFormField(
                                  controller: _questionController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter the discussion content',
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
                                SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      sendQuestion();
                                    },
                                    child: Padding(
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
