import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final List<BarChartGroupData> _barGroups = [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: 10,
          color: Colors.red,

        ),
        BarChartRodData(
          toY: 30,
          color: Colors.green,
        ),
      ],
      barsSpace: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => const Text('Recordings'),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text('$value'),
                  ),
                ),
              ),
              gridData: FlGridData(show: true),
              barTouchData: BarTouchData(enabled: false),
              borderData: FlBorderData(show: true),
              barGroups: _barGroups,
            ),
          ),
        ),
      ),
    );
  }
}
