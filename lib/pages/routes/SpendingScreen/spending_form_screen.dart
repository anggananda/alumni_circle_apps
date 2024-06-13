import 'package:flutter/material.dart';

class SpendingFormScreen extends StatefulWidget {
  final Function(int spending) onSubmit; // Callback for submitted data

  const SpendingFormScreen({super.key, required this.onSubmit});

  @override
  // ignore: library_private_types_in_public_api
  _SpendingFormScreenState createState() => _SpendingFormScreenState();
}

class _SpendingFormScreenState extends State<SpendingFormScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  int _spending = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Spending'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter spending amount.';
                }
                return null;
              },
              onSaved: (newValue) => _spending = int.parse(newValue!),
            ),
            const SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.onSubmit(_spending); // Call callback with data
                  Navigator.pop(context); // Close bottom sheet
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
