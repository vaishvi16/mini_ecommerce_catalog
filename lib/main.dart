import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mini_ecommerce_catalog/providers/auth_provider.dart';
import 'package:mini_ecommerce_catalog/providers/cart_provider.dart';
import 'package:mini_ecommerce_catalog/screens/auth_screens/login_screen.dart';
import 'package:mini_ecommerce_catalog/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
