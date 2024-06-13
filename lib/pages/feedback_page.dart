import 'package:alumni_circle_app/components/custom_search_box.dart';
import 'package:alumni_circle_app/cubit/alumni/cubit/alumni_cubit.dart';
import 'package:alumni_circle_app/cubit/feedback/cubit/feedback_cubit.dart';
import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/services/data_service.dart';
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
    super.dispose();
  }

  void _fetchData() {
    BlocProvider.of<FeedbackCubit>(context)
        .fetchFeedback(_currentPage, _searchController.text);
  }

  void _sendFeedback() async {
    final cubit = context.read<ProfileCubit>();
    final currentState = cubit.state;
    final feedback = _feedbackController.text;

    final send = context.read<FeedbackCubit>(); // Gunakan DiskusiCubit
    send.sendFeedback(currentState.idAlumni, feedback,
        _currentPage); // Panggil method sendDiskusi
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully Create Discussion')));
    _searchController.clear();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: 
      SingleChildScrollView(
        child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.roles == 'admin') {
            return Column(
              children: [
                Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.only(
                              bottom: 20
                            ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text('Feedback Hub', style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24, color: primaryFontColor
                          ),),
                        ),
                      ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: CustomSearchBox(
                    controller: _searchController,
                    onChanged: (value) => _fetchData(),
                    onClear: () => _fetchData(),
                    hintText: 'Search Forum...',
                  ),
                ),
                BlocBuilder<FeedbackCubit, FeedbackState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state.errorMessage.isNotEmpty) {
                            return Center(child: Text(state.errorMessage));
                          } else if (state.feedbackList.isEmpty) {
                            return Center(
                                child: Text('No discussion data available'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.feedbackList.length,
                              itemBuilder: (context, index) {
                                final feedback = state.feedbackList[index];
                                return 
                                SingleChildScrollView(
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
                                                        '${Endpoints.urlUas}/static/storages/${feedback.fotoProfile}'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
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
                                                            feedback.isiFeedback,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    primaryFontColor,
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      feedback.email,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            secondaryFontColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          formatDateString(
                                                              feedback.tanggal),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                secondaryFontColor,
                                                          ),
                                                        ),
                                                      ],
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: _currentPage > 1 ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: _currentPage > 1
                              ? () {
                                  setState(() {
                                    if (_currentPage > 1) {
                                      _currentPage--;
                                      _fetchData();
                                    }
                                  });
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Previous',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Page $_currentPage',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                      BlocBuilder<FeedbackCubit, FeedbackState>(
                        builder: (context, state) {
                          return Material(
                            color: state.feedbackList.isEmpty
                                ? Colors.grey
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setState(() {
                                  state.feedbackList.isEmpty
                                      ? _currentPage
                                      : _currentPage++;
                                  _fetchData();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Next',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.arrow_forward,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
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
                          "Feedback",
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
                                SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _sendFeedback();
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
                                      primary: primaryColor,
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
      )
    );
  }
}