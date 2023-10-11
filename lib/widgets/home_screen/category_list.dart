import 'package:flutter/material.dart';
import 'package:pet/models/database_provider.dart';
import 'package:pet/widgets/home_screen/category_card.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.categories;

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) => CategoryCard(list[i]),
        );
      },
    );
  }
}
