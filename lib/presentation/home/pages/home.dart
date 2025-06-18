import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaxpet/common/helper/navigation/app_navigation.dart';
import 'package:vaxpet/core/configs/theme/app_colors.dart';
import 'package:vaxpet/presentation/home/widgets/pets.dart';

import '../../pet/pages/create_pet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? accountId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccountId();
  }

  Future<void> _loadAccountId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getInt('accountId');
    debugPrint('Stored accountId: $storedId');
    setState(() {
      accountId = storedId;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ thú cưng'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.textBlack,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Danh sách thú cưng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                // Cho widget Pets một kích thước cố định để tránh xung đột layout
                Expanded(
                  child: accountId != null
                      ? Pets(accountId: accountId!)
                      : const Center(child: Text('Không tìm thấy account ID')),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigator.push(context, CreatePetPage());
        },
        backgroundColor: AppColors.primary,
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
