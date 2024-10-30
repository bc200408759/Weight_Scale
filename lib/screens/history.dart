import 'package:flutter/material.dart';

class HistoryTab extends StatelessWidget {
  // Sample data for history entries
  final List<HistoryEntry> entries = List.generate(
    20,
    (index) => HistoryEntry(
      date: '${index + 1}/10/2024',
      weight: '${90.5 - (index * 0.1)} kg', // Simulated weight
      change: '0 kg', // Render dummy value
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling for inner ListView
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _buildHistoryRow(entry);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each history row
  Widget _buildHistoryRow(HistoryEntry entry) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
       
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(entry.date, style: TextStyle(fontSize: 16)),
          Text(entry.weight, style: TextStyle(fontSize: 16)),
          Text(entry.change, style: TextStyle(fontSize: 16)), // Dummy value of 0 kg
        ],
      ),
    );
  }
}

// Model class for history entry
class HistoryEntry {
  final String date;
  final String weight;
  final String change;

  HistoryEntry({
    required this.date,
    required this.weight,
    required this.change,
  });
}
