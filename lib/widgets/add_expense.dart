import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet/constants/icons.dart';
import 'package:pet/models/database_provider.dart';
import 'package:pet/models/expense.dart';
import 'package:provider/provider.dart';

class AddExpence extends StatefulWidget {
  const AddExpence({super.key});

  @override
  State<AddExpence> createState() => _AddExpenceState();
}

class _AddExpenceState extends State<AddExpence> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _date;
  String _intialCategoryValue = 'Other';

  _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _date = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title Of Expense',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_date != null
                      ? DateFormat("MMMM dd,yyyy").format(_date!)
                      : 'Select Date'),
                ),
                IconButton(
                  onPressed: () => _selectDate(),
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Expanded(
                  child: Text('Category'),
                ),
                Expanded(
                  child: DropdownButton(
                    items: icons.keys
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    value: _intialCategoryValue,
                    onChanged: (newValue) {
                      setState(() {
                        _intialCategoryValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (_title.text != '' && _amount.text != '') {
                  var expense = Expense(
                    id: 0,
                    title: _title.text,
                    amount: double.parse(_amount.text),
                    date: _date != null ? _date! : DateTime.now(),
                    category: _intialCategoryValue,
                  );

                  provider.addExpense(expense);

                  //close the bottom sheet
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
