import 'package:calorie_counter_app/view/hub/page/add_food_calorie_view/add_food_calorie_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFoodCalorieView extends StatelessWidget {
  const AddFoodCalorieView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddFoodCalorieModel>(
      create: (context) => AddFoodCalorieModel(),
      child: const _AddFoodCalorieWidget(),
    );
  }
}

class _AddFoodCalorieWidget extends StatelessWidget {
  const _AddFoodCalorieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AddFoodCalorieModel>(context);

    if (model.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Мои блюда"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: model.foodItems.length,
        itemBuilder: (context, index) {
          final foodItem = model.foodItems[index];
          return Dismissible(
            key: Key(foodItem.name),
            background: Container(color: Colors.red),
            onDismissed: (direction) {
              model.deleteFoodItem(foodItem);
            },
            child: ListTile(
              title: Text(foodItem.name),
              subtitle: Text('${foodItem.weight} г, ${foodItem.calories} ккал'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      model.deleteFoodItem(foodItem);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      model.addFoodToDailyIntake(foodItem);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Переход на экран добавления нового блюда
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

