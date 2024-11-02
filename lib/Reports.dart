import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //backgroundColor: Colors.grey[400],
        appBar: AppBar(
          title: Text('Reports Page'),
          centerTitle: true,

        ),
    );
  }
}
