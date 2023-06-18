import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'item.dart';

class Export {
  static Future<void> exportToCsv(List<Item> items) async {
    List<List<dynamic>> rows = [];

    // Add header row
    rows.add(['Name', 'Price', 'Category']);

    // Add item rows
    for (var item in items) {
      rows.add([item.name, item.price, item.category]);
    }

    // Generate CSV string
    String csvData = const ListToCsvConverter().convert(rows);

    // Get the document directory path
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/items.csv';

    // Write CSV data to file
    File file = File(filePath);
    await file.writeAsString(csvData);

    print('CSV file exported to: $filePath');
  }
}
