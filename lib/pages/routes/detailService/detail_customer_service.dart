import 'package:alumni_circle_app/dto/issues.dart';
import 'package:alumni_circle_app/endpoints/endpoints.dart';
import 'package:alumni_circle_app/pages/updateform/update_data_issues.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';


class DetailCustomerService extends StatefulWidget {
  final Issues issues;
  const DetailCustomerService({Key? key, required this.issues}) : super(key: key);

  @override
  State<DetailCustomerService> createState() => _DetailCustomerServiceState();
}

class _DetailCustomerServiceState extends State<DetailCustomerService> {
  Future<List<Issues>>? _issues;

  void _editIssues(Issues issues) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UpdateFormIssues(issues: issues),
    ),
  );
}

  void _deleteIssues(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text("Apakah Anda yakin ingin menghapus data?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                    true); // Setelah tombol "OK" ditekan, nilai dialog adalah true
              },
              child: const Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                    false); // Setelah tombol "Batal" ditekan, nilai dialog adalah false
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == null || !confirmDelete) {
      return;
    }

    try {
      await DataService.deleteIssues(id);
      List<Issues> updatedIsses = await DataService.fetchIssues();
      setState(() {
        _issues = Future.value(updatedIsses);
        Navigator.pushReplacementNamed(context, '/customerService');
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Success',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            content: Text(
              'Deleted datas successfully.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Failed to delete news: $error');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            content: Text(
              'Failed to delete datas $error',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Container(
          color: secondaryColor,
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image:  NetworkImage('${Endpoints.urlDatas}/public/${widget.issues.imageUrl}'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 70,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: secondaryColor,
                              ),
                              child: const Icon(Icons.arrow_back),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('🌟 ${widget.issues.titleIssues}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryFontColor),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Details",
                          style: TextStyle(color: primaryFontColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: ()=>{
                              _editIssues(widget.issues)
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.black,
                            )),
                        IconButton(
                            onPressed: () =>{
                              _deleteIssues(widget.issues.idCustomerService)
                            },
                            icon: Icon(
                              Icons.delete,
                              color:
                                   Colors.black,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: 370,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: primaryFontColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Date : ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '${widget.issues.createdAt}',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: 370,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: primaryFontColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Rating :',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: widget.issues.rating == 1 ? '⭐️' : widget.issues.rating == 2 ? '⭐️⭐️' : widget.issues.rating == 3 ? '⭐️⭐️⭐️' : widget.issues.rating == 4 ? '⭐️⭐️⭐️⭐️' : widget.issues.rating == 5 ? '⭐️⭐️⭐️⭐️⭐️' : '',
                              style: TextStyle(
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.issues.descriptionIssues,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: primaryFontColor),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: 370,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: primaryFontColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'CP :',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' 082236903868 (dwi angga)',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}