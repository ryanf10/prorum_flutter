import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';
import 'package:prorum_flutter/models/detail_category.dart';
import 'package:prorum_flutter/screens/home/components/list_detail_categories.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({Key? key}) : super(key: key);

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  bool isLoading = true;
  List<DetailCategory> detailCategories = [];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    final response = await FetchApi.get(baseApiUrl + '/forum/categories');
    final body = jsonDecode(response.body);

    List<DetailCategory> temp = [];
    for (int i = 0; i < body['data'].length; i++) {
      temp.add(DetailCategory.fromJson(body['data'][i]));
    }

    for (int i = 0; i < temp.length; i++) {
      temp[i].image = Image.network(
          baseApiUrl + "/forum/categories/${temp[i].categoryId}/image");
    }
    setState(() {
      detailCategories = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Column(
            children: [
              ListDetailCategories(
                detailCategories: detailCategories,
                whenComplete: () async{

                },
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
  }
}
