import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/authentication/data/auth_repository.dart';
import 'package:flutter_todo_app/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';
import 'package:flutter_todo_app/utils/size_config.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('My Account')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Account Infomation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              const Icon(Icons.account_circle, size: 100, color: Colors.green),
              Text(currentUser?.email ?? 'N/A'),
              // Text(currentUser?.uid ?? 'N/A'),
              SizedBox(height: SizeConfig.getProportionateHeight(20)),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Are you sure you want to sign out?',
                        style: Appstyles.normalTextStyle,
                      ),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 60,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: Appstyles.normalTextStyle,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // 현재 컨텍스트를 저장
                            final navigator = Navigator.of(context);
                            // repositoryProvider직접 호출대신 
                            // controllerProvider.notifier를 사용
                            await ref
                                .read(authControllerProvider.notifier)
                                .signOut();
                            // 다이얼로그 닫기
                            navigator.pop();
                          },
                          child: Text(
                            'Sign Out',
                            style:
                                Appstyles.normalTextStyle.copyWith(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: SizeConfig.getProportionateHeight(50),
                  width: SizeConfig.screenWidth * .80,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Sign Out',
                    style: Appstyles.titleTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
