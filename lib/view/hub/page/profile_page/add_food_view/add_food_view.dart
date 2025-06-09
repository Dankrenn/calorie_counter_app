import 'package:calorie_counter_app/view/hub/page/profile_page/add_food_view/add_food_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFoodView extends StatelessWidget {
  const AddFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddFoodModel>(
      create: (context) => AddFoodModel(),
      child: const _AddFoodWidget(),
    );
  }
}

class _AddFoodWidget extends StatelessWidget {
  const _AddFoodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AddFoodModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавить блюдо"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: model.nameController,
                decoration: const InputDecoration(
                  labelText: 'Название блюда',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: model.weightController,
                decoration: const InputDecoration(
                  labelText: 'Масса (граммы)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: model.compositionController,
                decoration: const InputDecoration(
                  labelText: 'Состав',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: model.caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Калории на порцию',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () =>  model.saveFoodItem(context),
                  child: const Text('Сохранить блюдо'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
