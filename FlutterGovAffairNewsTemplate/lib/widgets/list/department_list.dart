import 'package:flutter/material.dart';
import '../../models/account_model.dart';
import '../cards/department_card.dart';

class DepartmentList extends StatelessWidget {
  final List<AccountModel> accounts;
  final VoidCallback onMorePressed;

  const DepartmentList({
    super.key,
    required this.accounts,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '政务号',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  onMorePressed();
                },
                child: const Row(
                  children: [
                    Text('更多',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Icon(Icons.chevron_right, color: Colors.grey, size: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: accounts.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              return DepartmentCard(department: accounts[index]);
            },
          ),
        ),
      ],
    );
  }
}
