import 'package:alumni_circle_app/dto/issues.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/routes/detailService/detail_customer_service.dart';
import 'package:flutter/material.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerServiceScreen extends StatefulWidget {
  const CustomerServiceScreen({Key? key}) : super(key: key);

  @override
  State<CustomerServiceScreen> createState() => _CustomerServiceScreenState();
}

class _CustomerServiceScreenState extends State<CustomerServiceScreen> {
  late Future<List<Issues>> _issues;

  @override
  void initState() {
    super.initState();
    _issues = DataService.fetchIssues();
  }

  void _navigateToDetail(Issues issues) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailCustomerService(issues: issues),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Customer Services"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Issues>>(
          future: _issues,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: data.map((post) {
                    return GestureDetector(
                      onTap: () => _navigateToDetail(post), // Navigasi ke halaman detail saat konten diklik
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: thirdColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              '${Endpoints.urlIssues}/public/${post.imageUrl}',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                post.titleIssues,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/formData');
        },
        child: const Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
    );
  }
}
