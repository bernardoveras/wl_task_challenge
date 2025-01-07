import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TaskSkeletonCard extends StatelessWidget {
  const TaskSkeletonCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.blueGrey.shade100,
            highlightColor: Colors.blueGrey.shade50,
            child: Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.blueGrey.shade100,
                        highlightColor: Colors.blueGrey.shade50,
                        child: Container(
                          height: 20,
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.blueGrey.shade100,
                        highlightColor: Colors.blueGrey.shade50,
                        child: Container(
                          height: 20,
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.blueGrey.shade100,
                  highlightColor: Colors.blueGrey.shade50,
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
