import 'package:flutter/material.dart';
import 'package:tuition_app/widgets/app_bar.dart';

import '../models/items.dart';

class ItemDetailScreen extends StatefulWidget
{
  final Items? model;
  const ItemDetailScreen({this.model});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: MyAppBar(),
    );
  }
}
