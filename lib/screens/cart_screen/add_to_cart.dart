import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model_class/cart_model.dart';
import '../../providers/cart_provider.dart';
import '../checkout_screen/checkout_screen.dart';

class AddToCartScreen extends StatelessWidget {
  const AddToCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text("Your Cart"),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          final cartItems = cartProvider.cartItems;

          return ListView(
            padding: EdgeInsets.all(12),
            children: [
              SizedBox(height: screenHeight * 0.02),

              if (cartItems.isEmpty)
                Center(child: Text("Your cart is empty!"))
              else
                ...cartItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  CartItem item = entry.value;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: _cartItem(context, item),
                  );
                }),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(top: false, child: _bottomCheckoutBar()),
    );
  }

  Widget _cartItem(BuildContext context, CartItem item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.image,
              height: 80,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                SizedBox(height: 6),
                Text(
                  "Rs. ${item.price}",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _qtyBtn(Icons.remove, () => cartProvider.decreaseQty(item)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(item.qty.toString()),
              ),
              _qtyBtn(Icons.add, () => cartProvider.increaseQty(item)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _bottomCheckoutBar() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        double total = cartProvider.totalPrice;

        return Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Total Rs. $total",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(),));
                },
                child: Text("Checkout", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
