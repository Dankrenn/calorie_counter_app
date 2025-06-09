import 'package:calorie_counter_app/service/theme_provider.dart';
import 'package:calorie_counter_app/view/hub/page/profile_page/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileModel>(
      create: (context) => ProfileModel(),
      child: _DataEntryWidget(),
    );
  }
}

class _DataEntryWidget extends StatelessWidget {
  const _DataEntryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProfileModel>(context);
    final provider = Provider.of<ThemeProvider>(context);
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(provider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => provider.updateTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => model.logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _UserInfoCard(email: model.email),
            const SizedBox(height: 24),
            _NavigationCard(
              icon: Icons.add_circle_outline,
              title: "Добавить блюдо",
              subtitle: "Создайте новую запись в дневнике",
              onTap: () => model.goAddFoodView(context),
            ),
            //const SizedBox(height: 16),
            // _NavigationCard(
            //   icon: Icons.history,
            //   title: "История калорий",
            //   subtitle: "Просмотр статистики по дням",
            //   onTap: () => model.goHistoryView(context),
            // ),
            const SizedBox(height: 16),
            _NavigationCard(
              icon: Icons.update,
              title: "История изменения веса",
              subtitle: "Просмотр статистики по изменению веса",
              onTap: () => model.goHistoryWeightView(context),
            ),
            const SizedBox(height: 16),
            _NavigationCard(
              icon: Icons.calculate,
              title: "Норма калорий",
              subtitle: "Рассчитайте вашу дневную норму",
              onTap: () => model.goCalorieCounterView(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  final String email;

  const _UserInfoCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Мой аккаунт",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
