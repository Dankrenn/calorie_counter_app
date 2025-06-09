import 'package:calorie_counter_app/view/entrance/reused_widgets/button_entrance_widget.dart';
import 'package:calorie_counter_app/view/hub/page/profile_page/calorie_counter/calorie_counter_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalorieCounterView extends StatelessWidget {
  const CalorieCounterView({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalorieCounterModel>(
      create: (context) => CalorieCounterModel(),
      child: _DataEntryWidget(),
    );
  }
}

class _DataEntryWidget extends StatelessWidget {
  const _DataEntryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CalorieCounterModel>(context);

    if (model.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Определитель нормы калорий"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GenderSelector(
                  isMaleSelected: model.isMaleSelected,
                  onMalePressed: () => model.setIsMaleSelected(true),
                  onFemalePressed: () => model.setIsMaleSelected(false),
                ),
                const SizedBox(height: 24),
                _InputField(
                  label: "Возраст (лет)",
                  controller: model.age,
                ),
                const SizedBox(height: 16),
                _InputField(
                  label: "Вес (кг)",
                  controller: model.weight,
                ),
                const SizedBox(height: 16),
                _InputField(
                  label: "Рост (см)",
                  controller: model.height,
                ),
                const SizedBox(height: 24),
                _ActivityLevelSelector(
                  selectedIndex: model.selectedActivityIndex,
                  onSelected: (index) => model.setSelectedActivityIndex(index),
                ),
                const SizedBox(height: 32),
                ButtonEntranceWidget(
                  text: 'Рассчитать норму',
                  callback: () => model.counterCalorie(context),
                ),
                const SizedBox(height: 32),
                _ResultCard(
                  title: "По формуле Миффлина-Сан Жеор",
                  value: model.mifflinResult,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final bool isMaleSelected;
  final VoidCallback onMalePressed;
  final VoidCallback onFemalePressed;

  const _GenderSelector({
    required this.isMaleSelected,
    required this.onMalePressed,
    required this.onFemalePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Пол",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onMalePressed,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: isMaleSelected ? Colors.blue : Colors.grey[300]!,
                  ),
                  backgroundColor: isMaleSelected
                      ? Colors.blue.withOpacity(0.1)
                      : null,
                ),
                child: Text(
                  "Мужской",
                  style: TextStyle(
                    fontSize: 16,
                    color: isMaleSelected ? Colors.blue : Colors.grey[300],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: onFemalePressed,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: !isMaleSelected ? Colors.pink : Colors.grey[300]!,
                  ),
                  backgroundColor: !isMaleSelected
                      ? Colors.pink.withOpacity(0.1)
                      : null,
                ),
                child: Text(
                  "Женский",
                  style: TextStyle(
                    fontSize: 16,
                    color: !isMaleSelected ? Colors.pink : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _InputField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class _ActivityLevelSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ActivityLevelSelector({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CalorieCounterModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Уровень активности",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: model.activities.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final activity = model.activities[index];
              return SizedBox(
                child: _ActivityCard(
                  title: activity["title"] as String,
                  desc: activity["desc"] as String,
                  isSelected: index == selectedIndex,
                  onTap: () => onSelected(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String desc;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.title,
    required this.desc,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String value;

  const _ResultCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              "ккал/день",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}