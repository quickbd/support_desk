import 'package:flutter/material.dart';

class MyInvoiceScreen extends StatelessWidget {
  const MyInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Invoice'),
      ),
      body: const Center(
        child: Text('My Invoice Screen Content'),
      ),
    );
  }
}
