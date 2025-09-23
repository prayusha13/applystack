import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final Color appliedColor = Color(0xFF3B82F6);
    final Color interviewColor = Color(0xFF10B981);
    final Color offerColor = Color(0xFFF59E0B);
    final Color rejectedColor = Color(0xFFEF4444);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Stats'),
      ),
      body: Center(
        child: Obx(() {
          final stats = controller.stats;
          final total = stats['total'] ?? 0;

          if (total == 0) {
            return const Text("No application data to display yet.");
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    // The Pie Chart
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(value: (stats['applied'] ?? 0).toDouble(), title: '', color: appliedColor, radius: 50),
                              PieChartSectionData(value: (stats['interview'] ?? 0).toDouble(), title: '', color: interviewColor, radius: 50),
                              PieChartSectionData(value: (stats['offer'] ?? 0).toDouble(), title: '', color: offerColor, radius: 50),
                              PieChartSectionData(value: (stats['rejected'] ?? 0).toDouble(), title: '', color: rejectedColor, radius: 50),
                            ],
                            sectionsSpace: 2,
                            centerSpaceRadius: 50,
                          ),
                        ),
                      ),
                    ),
                    // The new Indicator Legend
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _Indicator(color: appliedColor, text: 'Applied', value: stats['applied'] ?? 0),
                          _Indicator(color: interviewColor, text: 'Interview', value: stats['interview'] ?? 0),
                          _Indicator(color: offerColor, text: 'Offer', value: stats['offer'] ?? 0),
                          _Indicator(color: rejectedColor, text: 'Rejected', value: stats['rejected'] ?? 0),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 48),
                ListTile(
                  title: Text("Total Applications", style: Theme.of(context).textTheme.titleLarge),
                  trailing: Text(total.toString(), style: Theme.of(context).textTheme.headlineSmall),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// A new, reusable widget for the legend items
class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final int value;

  const _Indicator({
    required this.color,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value.toString(), style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7))),
        ],
      ),
    );
  }
}