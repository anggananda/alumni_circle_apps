// ignore_for_file: library_private_types_in_public_api

import 'package:alumni_circle_app/cubit/balance/cubit/balance_cubit.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  BalanceCubit?
      balanceCubit; // get balance cubit as state management for balance
  

  @override
  void initState() {
    super.initState();
    final cubit = context.read<BalanceCubit>();
    
    final currentState = cubit.state;
    
    // Check if balance is already available
    if (currentState is BalanceInitialState || currentState.balance <= 0) {
      cubit.fetchBalance(); // Dispatch event to fetch balance
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white), // recolor the icon
      ),
      // ignore: sized_box_for_whitespace
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome with Cubit",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Here to demonstrate interaction flow with Cubit and HTTP, update cubit balance with persist updated based on get data balance and spending activity",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                        width: double.infinity,
                      ),
                      BlocBuilder<BalanceCubit, BalanceState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              Text(
                                state.balance > 0
                                    ? formatter.format(state.balance)
                                    : "Waiting for Balance",
                                style: const TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Current Balance Dwi Angga',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
