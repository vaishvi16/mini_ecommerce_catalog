import 'package:flutter/material.dart';
import 'package:mini_ecommerce_catalog/screens/cart_screen/add_to_cart.dart';

import '../../customization/custom_gridview.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        title: Text("Dashboard Screen"),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddToCartScreen(),));
          }, icon: Icon(Icons.shopping_cart,color: Colors.black,))
        ],
      ),
      body: SingleChildScrollView(child: CustomGridview()),
    );
  }
}
