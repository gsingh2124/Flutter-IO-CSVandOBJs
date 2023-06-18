import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'item.dart';

class Import {
  static Future<List<Item>> importFromCsv() async {
    List<Item> items = [];

    // Get the document directory path
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/items.csv';

    // Read CSV file
    String csvData = await File(filePath).readAsString();

    // Convert CSV string to List<List<dynamic>>
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csvData);

    // Remove header row
    rowsAsListOfValues.removeAt(0);

    // Convert List<List<dynamic>> to List<Item>
    for (var row in rowsAsListOfValues) {
      String price = row[1].toString();
      items.add(Item(row[0], price, row[2]));
    }

    return items;
  }
}
