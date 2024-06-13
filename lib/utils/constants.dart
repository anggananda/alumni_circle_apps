import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const primaryColor = Color(0xFFF4CE14);
const secondaryColor = Color(0xFFEAEAEA);
const thirdColor = Color(0xFFFFFFFF);
const primaryFontColor =  Color(0XFF333333);
const secondaryFontColor = Colors.grey;

final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
final DateFormat formatDate = DateFormat('yyyy-MM-dd H:mm');
// final String formatDate = DateFormat('yyyy-MM-dd H:mm');
const tokenStoreName = "access_token";

String formatDateString(String inputDate) {
  try {
    // Parse the input date
    // print('Input date: $inputDate');
    DateTime parsedDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US').parse(inputDate);
    
    // Format the parsed date to the desired format
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    // print('Formatted date: $formattedDate');
    
    return formattedDate;
  } catch (e) {
    throw Exception('Failed to format date: $e');
  }
}
