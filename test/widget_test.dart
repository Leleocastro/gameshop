import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gameshop_supera/main.dart';
import 'package:gameshop_supera/providers/products.dart';
import 'package:gameshop_supera/views/productsOverviewScreen.dart';
import 'package:gameshop_supera/widgets/productGrid.dart';
import 'package:provider/provider.dart';

Widget createProductGridScreen() => ChangeNotifierProvider<Products>(
      create: (context) => Products(),
      child: MaterialApp(
        home: ProductGrid(),
      ),
    );

void main() {
  testWidgets('Title should be visible', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Supera GameShop'), findsOneWidget);
  });

  testWidgets('Product list should be visible', (tester) async {
    await tester.pumpWidget(createProductGridScreen());
    expect(find.byType(GridView), findsOneWidget);
  });
}
