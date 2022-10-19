import 'package:flutter/material.dart';

class NewsView extends StatelessWidget {
  const NewsView({Key? key, required this.role}) : super(key: key);

  final int? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InkWell(
        onTap: role != 1
            ? null
            : () {
                print('ok');
              },
        child: const Center(
          child: Text('test'),
        ),
      ),
    );
  }
}
