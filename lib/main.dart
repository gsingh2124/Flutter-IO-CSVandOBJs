import 'package:csvtester/import.dart';
import 'package:flutter/material.dart';
import 'item.dart';
import 'export.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String? _selectedCategory; // Default category selection

  final List<String> categories = ['Pizza', 'Subs', 'Wings', 'Drinks'];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  List<Item> items = [];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Csv Testing'),
      ),
      // Begin main widget body-----------------------------------------------
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main widget children list ------------------------
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixText: '\$',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: _selectedCategory,
                  hint: const Text('Category'), // Displayed before selection
                  onChanged: (String? newValue) {
                    if (newValue != 'Category') {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    debugPrint('Button pressed');
                    String name = _nameController.text;
                    String price = _priceController.text;
                    String category = _selectedCategory ?? '';
                    debugPrint(
                        'Name: $name, Price: $price, Category: $category');
                    Item newItem = Item(name, price,
                        category); //Item object creation from user credentials
                    setState(() {
                      items.add(newItem); //Items being inserted into item list
                    });
                  },
                  child: const Text('Save'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    debugPrint('Export button');
                    Export.exportToCsv(items);
                  },
                  child: const Text('Export'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    debugPrint('import button');
                    Import.importFromCsv().then((value) {
                      setState(() {
                        items = value;
                      });
                    });
                  },
                  child: const Text('Import'),
                ),
                const SizedBox(height: 16),
                if (items.isNotEmpty)
                  Column(
                    children: items
                        .map(
                          (item) => ListTile(
                            title: Text('Name: ${item.name}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Price: ${item.price}'),
                                Text('Category: ${item.category}'),
                                const Divider(),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
      // End main widget body-------------------------------------------------
    );
  }
}
