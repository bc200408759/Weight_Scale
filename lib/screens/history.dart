import 'package:flutter/material.dart';
import '../weight_history.dart'; // Update this import to the correct path of your WeightHistory class
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class HistoryTab extends StatelessWidget {
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
              future: _fetchHistoryEntries(), // Fetch entries from WeightHistory
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No history available.'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final entry = snapshot.data![index];
                      return _buildHistoryRow(entry);
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

  // Function to fetch history entries from WeightHistory
 Future<List<HistoryEntry>> _fetchHistoryEntries() async {
  final weightHistory = WeightHistory();
  await weightHistory.init(); // Ensure SharedPreferences is initialized
  final historyData = weightHistory.getHistory();
  
  return historyData.map((data) {
    // Parse the date string and format it to "yyyy-MM-dd"
    DateTime dateTime = DateTime.parse(data['date']);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return HistoryEntry(
      date: formattedDate, // Use the formatted date
      weight: '${data['weight']} kg', // Get the weight from the history data
      change: '${data['change']} kg', // Get the change from the history data
    );
  }).toList();
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
          Text(entry.change, style: TextStyle(fontSize: 16)),
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
