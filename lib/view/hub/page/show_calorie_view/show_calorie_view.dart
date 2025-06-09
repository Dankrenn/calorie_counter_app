import 'package:calorie_counter_app/view/hub/page/show_calorie_view/show_calorie_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowCalorieView extends StatelessWidget {
  const ShowCalorieView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShowCaloriesModel>(
      create: (context) => ShowCaloriesModel(),
      child: const _CalorieDisplayWidget(),
    );
  }
}

class _CalorieDisplayWidget extends StatelessWidget {
  const _CalorieDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ShowCaloriesModel>(context);

    if (model.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (model.userCalorieInfo == null) {
      return const Scaffold(
        body: Center(
          child: Text('Нет данных о норме калорий'),
        ),
      );
    }

    final userCalorieInfo = model.userCalorieInfo!;
    final int consumedCalories = model.dailyIntake?.totalCalories ?? 0;
    final int requiredCalories = userCalorieInfo.mifflinResult;
    final double progress = requiredCalories > 0
        ? consumedCalories / requiredCalories
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Потребление калорий'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Потребление калорий за ${_formatDate(model.selectedDate)}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              '$consumedCalories / $requiredCalories ккал',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: progress > 1
                  ? AlwaysStoppedAnimation<Color>(Colors.red)
                  : AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            Text(
              progress > 1 ? 'Превышено!' : 'В пределах нормы',
              style: TextStyle(
                color: progress > 1 ? Colors.red : Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            if (model.dailyIntake != null) ...[
              const Text(
                'Съеденные продукты:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: model.dailyIntake!.foodItems.length,
                  itemBuilder: (context, index) {
                    final item = model.dailyIntake!.foodItems[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('${item.weight}г - ${item.calories} ккал'),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
