import 'package:flutter/material.dart';

class DashboardOverviewGrid extends StatelessWidget {
  final List<Widget> children;

  const DashboardOverviewGrid({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: children,
    );
  }
}
