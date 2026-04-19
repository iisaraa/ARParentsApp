import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/providers/child_provider.dart';
import '../../../../core/themes/colors/light_theme_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/child.dart';
class ChildCard extends StatelessWidget {
  final Child child;

  const ChildCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: child.gender == 'Male'.tr()
                    ? Colors.blue.shade50
                    : Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                child.gender == 'Male'.tr() ? Icons.boy : Icons.girl,
                size: 40,
                color: child.gender == 'Male'.tr()
                    ? LightThemeColors.primaryCard
                    : Colors.pink.shade700,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.cake, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${child.age} year'.tr(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        child.gender == 'Male'.tr()? Icons.male : Icons.female,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        child.gender == 'Male'.tr() ? 'Male'.tr(): 'Female'.tr(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                 PopupMenuItem(
                  value: 'delete'.tr(),
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'.tr(), style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) async {
                if (value == 'delete'.tr()) {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title:  Text('delete confirmation'.tr()),
                      content:  Text('Are you sure this child has been deleted?'.tr()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child:  Text('Cancel'.tr()),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child:  Text(
                            'Delete'.tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    final childProvider = Provider.of<ChildProvider>(
                      context,
                      listen: false,
                    );
                    final success = await childProvider.deleteChild(child.id);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success ? 'Child deleted successfully'.tr(): 'Child deletion failed'.tr(),
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}