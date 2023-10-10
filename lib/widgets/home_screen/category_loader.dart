import 'package:flutter/material.dart';
import 'package:pet/models/database_provider.dart';
import 'package:provider/provider.dart';

class CategoryLoader extends StatefulWidget {
  const CategoryLoader({super.key});

  @override
  State<CategoryLoader> createState() => _CategoryLoaderState();
}

class _CategoryLoaderState extends State<CategoryLoader> {
  late Future _categoryList;

  Future _getCategoryList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.getExpenseCategories();
  }

  @override
  void initState() {
    super.initState();
    _categoryList = _getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categoryList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Consumer<DatabaseProvider>(
              builder: (_, db, __) {
                var list = db.categories;

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(list[i].icon),
                    ),
                    title: Text(list[i].title),
                    subtitle: Text('entries:${list[i].entries.toString()}'),
                    trailing: Text('\$ ${list[i].totalAmount.toString()}'),
                  ),
                );
              },
            );
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
