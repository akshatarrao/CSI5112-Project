// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'package:image_picker/image_picker.dart';

class EditItem extends StatefulWidget {
  final String itemId;
  const EditItem(this.itemId, {Key? key}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  // static List<InventoryModel> inventory = [
  //   InventoryModel("123", "Product 1", "Electronics", "A", 3),
  //   InventoryModel("456", "Product 2", "Footwear", "A", 4),
  //   InventoryModel("dsf32", "Product 3", "Clothes", "A", 12),
  //   InventoryModel("342rfe", "Product 4", "Smartphones", "A", 33),
  // ];
  String title = 'Product';
  String description = '';
  DateTime date = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;
  // String id=;
  // String product;
  // String category;
  // String seller;
  // int stock;
  TextEditingController qualityController = TextEditingController();
  String? _dropdownvalue;

  var items = [
    'Groceries',
    'Clothes',
    'Electronics',
    'Footwear',
    'Smartphones',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(
          height: 30,
          child: Text("Edit Item"),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter Item Name...',
                            labelText: 'Item Name',
                          ),
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter Item Price...',
                            labelText: 'Price',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter a description...',
                            labelText: 'Description',
                          ),
                          onChanged: (value) {
                            description = value;
                          },
                          maxLines: 5,
                        ),
                        DropdownButton(
                          value: _dropdownvalue,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: const Text("Category"),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _dropdownvalue = newValue!;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Discount',
                                style: Theme.of(context).textTheme.bodyText1),
                            Switch(
                              value: enableFeature,
                              onChanged: (enabled) {
                                setState(() {
                                  enableFeature = enabled;
                                });
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: enableFeature,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Enter Discounted Price...',
                              labelText: 'Discounted Price',
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FloatingActionButton(
                              child: const Icon(Icons.arrow_back),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              onPressed: () => {Navigator.pop(context)},
                            ),
                            FloatingActionButton(
                              child: const Icon(Icons.check),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              onPressed: () => {},
                            ),
                          ],
                        ),
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
