import 'package:facial/pages/TimeReports.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsPage extends StatefulWidget {
  ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final List<BarChartGroupData> _dayData = [
    // Define your day data here
  ];

  final List<BarChartGroupData> _weekData = [
    // Define your week data here
  ];

  final List<BarChartGroupData> _monthData = [
    // Define your month data here
  ];

  List<BarChartGroupData> getChartData(String period) {
    switch (period) {
      case 'Week':
        return _weekData;
      case 'Month':
        return _monthData;
      case 'Day':
      default:
        return _dayData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timePeriodProvider = Provider.of<TimePeriodProvider>(context);
    final selectedPeriod = timePeriodProvider.selectedPeriod;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              isSelected: [
                selectedPeriod == 'Day',
                selectedPeriod == 'Week',
                selectedPeriod == 'Month'
              ],
              onPressed: (index) {
                String period;
                if (index == 0) period = 'Day';
                else if (index == 1) period = 'Week';
                else period = 'Month';
                timePeriodProvider.setPeriod(period);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Day'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Week'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Month'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            const Text('Recordings'),
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
                  barGroups: getChartData(selectedPeriod),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
