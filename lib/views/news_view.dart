import 'package:flutter/material.dart';
import 'package:semi_final_lab/view_model/Crud_News/Add_News.dart';
import 'package:semi_final_lab/view_model/Crud_News/Read_User_View.dart';

class NewsView extends StatelessWidget {
  const NewsView({Key? key, required this.role}) : super(key: key);

  final int? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InkWell(
        onTap: role != 1
            ? () {}
            : () {
                const ReadUserView();
              },
        child: const Center(child: add_news()),
      ),
    );
  }
}
