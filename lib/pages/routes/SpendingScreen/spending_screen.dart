import 'package:alumni_circle_app/cubit/balance/cubit/balance_cubit.dart';
import 'package:alumni_circle_app/pages/routes/SpendingScreen/spending_form_screen.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_circle_app/dto/spendings.dart';
import 'package:alumni_circle_app/services/data_service.dart';
// import 'package:my_app/utils/constants.dart';

class SpendingScreen extends StatefulWidget {
  const SpendingScreen({super.key});

  @override
  State<SpendingScreen> createState() => _SpendingScreenState();
}

class _SpendingScreenState extends State<SpendingScreen> {
  Future<List<Spendings>>? _spendings;

  @override
  void initState() {
    super.initState();
    _spendings =
        DataService.fetchSpendings(); // Call your data fetching function
  }

  Future<void> sendSpending(BalanceCubit balanceCubit, int spending) async {
    final response =
        await DataService.sendSpendingData(spending); // Get the Cubit
    if (response.statusCode == 201) {
      debugPrint("sending success");
      setState(() {
        _spendings = DataService.fetchSpendings();
      });
      balanceCubit.updateBalance(spending);
    } else {
      debugPrint("failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final balanceCubit = BlocProvider.of<BalanceCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spendings'),
      ),
      body: FutureBuilder<List<Spendings>>(
        future: _spendings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final dataList = snapshot.data!;
            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final item = dataList[index];
                return MyListItemWidget(item: item);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}')); // Handle errors
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SpendingFormScreen(
              onSubmit: (spending) {
                sendSpending(balanceCubit, spending);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyListItemWidget extends StatelessWidget {
  final Spendings item;

  const MyListItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${item.spending}'),
      subtitle: Text(formatDate.format(item.createdAt)),
      leading: const Icon(Icons.monetization_on),
    );
  }
}
