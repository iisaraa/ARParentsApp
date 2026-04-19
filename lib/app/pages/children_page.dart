import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/data/models/child.dart';
import '../providers/auth_provider.dart';
import '../providers/child_provider.dart';
import 'add_child_page.dart';

class ChildrenPage extends StatefulWidget {
  const ChildrenPage({super.key});

  @override
  State<ChildrenPage> createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final childProvider = Provider.of<ChildProvider>(context, listen: false);

    final parentId = authProvider.currentParent?.id;

    if (parentId != null && childProvider.children.isEmpty) {
      await childProvider.loadChildren(parentId);
    }
  }

  Future<void> _refreshChildren() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final childProvider = Provider.of<ChildProvider>(context, listen: false);

    final parentId = authProvider.currentParent?.id;

    if (parentId != null) {
      await childProvider.loadChildren(parentId, forceRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final childProvider = Provider.of<ChildProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'My Children'.tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddChildPage(),
                ),
              );

              if (result == true) {
                await _refreshChildren();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshChildren,
        child: childProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : childProvider.children.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: childProvider.children.length,
          itemBuilder: (context, index) {
            final child = childProvider.children[index];
            return _buildChildCard(child);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.child_care, size: 60),
          const SizedBox(height: 20),
           Text('No children yet'.tr()),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddChildPage(),
                ),
              );

              if (result == true) {
                await _refreshChildren();
              }
            },
            child:  Text('Add Child'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard(Child child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          child.gender == 'Male'.tr() ? Icons.boy : Icons.girl,
        ),
        title: Text(child.username),
        subtitle: Text('Age: ${child.age}'.tr()),
        trailing: Text(child.gender),
      ),
    );
  }
}