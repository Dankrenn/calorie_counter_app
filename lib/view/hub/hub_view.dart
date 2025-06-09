import 'package:calorie_counter_app/view/hub/hub_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HubView extends StatelessWidget {
  const HubView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HubModel>(
      create: (context) => HubModel(),
      child: _DataEntryWidget(),
    );
  }
}

class _DataEntryWidget extends StatelessWidget {
  const _DataEntryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HubModel>(context);
    return Scaffold(
      body: model.tabs[model.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: model.currentIndex,
        onTap:(index) => model.updateCurrentIndex(index),
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 24),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.receipt_sharp),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.data_usage),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: '',),
        ],
      ),
    );
  }
}