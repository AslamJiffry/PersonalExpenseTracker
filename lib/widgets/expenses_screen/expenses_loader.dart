import 'package:flutter/material.dart';
import 'package:pet/models/database_provider.dart';
import 'package:pet/widgets/expenses_screen/expenses_list.dart';
import 'package:provider/provider.dart';

class ExpencesLoader extends StatefulWidget {
  final String category;
  const ExpencesLoader(this.category, {super.key});

  @override
  State<ExpencesLoader> createState() => _ExpencesLoaderState();
}

class _ExpencesLoaderState extends State<ExpencesLoader> {
  late Future _expenceList;
  Future _getExpenceList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.loadExpences(widget.category);
  }

  @override
  void initState() {
    super.initState();
    _expenceList = _getExpenceList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _expenceList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else {
            return const ExpencesList();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
