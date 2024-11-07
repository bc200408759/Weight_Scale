import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../weight_history.dart';

class HistoryTab extends StatefulWidget {
  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final WeightHistory weightHistory = WeightHistory();

  @override
  void initState() {
    super.initState();
    weightHistory.init(); // Initialize SharedPreferences
    // print('Initialized WeightHistory');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            FutureBuilder<List<HistoryEntry>>(
              future: _fetchHistoryEntries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error loading history: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print('No history available');
                  return Center(child: Text('No history available.'));
                } else {
                print('History loaded: ${snapshot.data}');
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final entry = snapshot.data![index];
                      return _buildHistoryRow(context, entry);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<HistoryEntry>> _fetchHistoryEntries() async {
    final historyData = weightHistory.getHistory();
    // print('Fetched history data: $historyData');

    return historyData.map((data) {
      DateTime dateTime = DateTime.parse(data['date']);
     String rawDate = data['date'];

      return HistoryEntry(
        date: rawDate,
        weight: '${data['weight'].toStringAsFixed(1)} kg',
        change: '${data['change'].toStringAsFixed(1)} kg',
      );
    }).toList();
  }

  Widget _buildHistoryRow(BuildContext context, HistoryEntry entry) {
   // Format the date as yyyy/mm/dd
  DateTime dateTime = DateTime.parse(entry.date);
  String formattedDate = DateFormat('yyyy/MM/dd').format(dateTime);

    return GestureDetector(
      onTap: () => _showUpdateWeightDialog(context, entry),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formattedDate, style: TextStyle(fontSize: 16)),
            Text(entry.weight, style: TextStyle(fontSize: 16)),
            Text(entry.change, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showUpdateWeightDialog(BuildContext context, HistoryEntry entry) {
    final TextEditingController weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Weight'),
          content: TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter new weight (kg)'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newWeight = double.tryParse(weightController.text);
                if (newWeight != null) {
                  // print('Updating weight for ${entry.date} to $newWeight');
                  await weightHistory.updateWeightEntry(entry.date, newWeight);
                  // print('Weight updated in history');
                  setState(() {
                    print('Calling setState to refresh UI');
                  }); // Refresh UI
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  print('Invalid weight entered: ${weightController.text}');
                  // Show error if input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid weight.')),
                  );
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
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

  @override
  String toString() {
    return 'HistoryEntry(date: $date, weight: $weight, change: $change)';
  }
}



