import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../model_class/cart_model.dart';
import '../../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final cartProvider = context.read<CartProvider>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful! ID: ${response.paymentId}")),
    );

    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  void _startPayment(double total) {
    var options = {
      'key': 'rzp_test_SUziWlLr87FlSj',
      'amount': (total * 100).toInt(),
      'name': 'Mini E-commerce Catalog',
      'description': 'Order Payment',
      'prefill': {
        'contact': '',
        'email': '',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Payment error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double total = cartProvider.totalPrice;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        title: Text("Checkout"),
      ),
      body: cartProvider.cartItems.isEmpty
          ? Center(child: Text("Your cart is empty!"))
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Your Items",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
          ),
          SizedBox(height: 8),
          ...cartProvider.cartItems.map(
                (item) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: _checkoutItem(item),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text("Payment Method"),
              subtitle: Text("Credit / Debit Card, UPI, NetBanking"),
              trailing: Icon(Icons.payment),
              onTap: () {},
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomBar(total),
    );
  }

  Widget _checkoutItem(CartItem item) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            item.image,
            width: 70,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name),
              SizedBox(height: 6),
              Text("Rs. ${item.price} x ${item.qty}",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Text("Rs. ${int.parse(item.price) * item.qty}"),
      ],
    );
  }

  Widget _bottomBar(double total) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Total: Rs. ${total.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (total > 0) {
                _startPayment(total);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Pay Now", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}