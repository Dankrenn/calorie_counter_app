import 'package:calorie_counter_app/data/user_info_of_calorie.dart';
import 'package:calorie_counter_app/view/hub/page/profile_page/hictory_weight/historu_weight_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoryWeightView extends StatelessWidget {
  const HistoryWeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoryWeightModel>(
      create: (context) => HistoryWeightModel(),
      child: const _DataEntryWidget(),
    );
  }
}

class _DataEntryWidget extends StatelessWidget {
  const _DataEntryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HistoryWeightModel>(context);

    if (model.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('История изменений веса'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <CartesianSeries<UserInfoOfCalorie, DateTime>>[
                  LineSeries<UserInfoOfCalorie, DateTime>(
                    dataSource: model.history,
                    xValueMapper: (UserInfoOfCalorie info, _) => info.timestamp,
                    yValueMapper: (UserInfoOfCalorie info, _) => info.weight,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: model.history.length,
                itemBuilder: (context, index) {
                  final item = model.history[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.monitor_weight),
                      title: Text('Запись ${index + 1}'),
                      subtitle: Text('${item.timestamp.toLocal()}'),
                      trailing: Text('${item.weight} кг'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
