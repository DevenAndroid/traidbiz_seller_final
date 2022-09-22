import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:traidbiz_seller/constraints/colors.dart';

import '../../../data/models/report/monthly_report.dart';

class ReportGridWidget extends StatelessWidget {
  final int index;
  final MonthlyReport? report;
  const ReportGridWidget({Key? key, this.report, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  // child: const Icon(
                  //   PhosphorIcons.percent,
                  //   color: Colors.white,
                  // ),
                  backgroundColor: report?.color,
                  // child: const Icon(
                  //   PhosphorIcons.percent,
                  //   color: Colors.white,
                  // ),
                  child: Image.asset(
                    'assets/icons/discount.png',
                    height: 24,
                    width: 24,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
            FittedBox(
              child: Text(
                index == 3
                    ? '${report?.value}'
                    : index == 2
                        ? '${report?.value}'
                        : '\$ ${report?.value}',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: report?.color,
                    ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${report?.title}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
