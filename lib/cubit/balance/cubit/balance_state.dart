part of 'balance_cubit.dart';

@immutable
 class BalanceState {
  final int balance;
  const BalanceState({required this.balance});
 }

final class BalanceInitialState extends BalanceState {
  const BalanceInitialState() : super(balance: 0);
}
