import 'package:flutter/material.dart';
import 'package:pet/models/database_provider.dart';
import 'package:pet/widgets/home_screen/category_list.dart';
import 'package:pet/widgets/home_screen/pie_graph.dart';
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
            return const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: PieGraph(),
                  ),
                  Expanded(
                    child: CategoryList(),
                  ),
                ],
              ),
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
