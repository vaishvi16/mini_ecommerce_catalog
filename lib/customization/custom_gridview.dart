import 'package:flutter/material.dart';

import '../screens/dashboard_screen/product_detail_screen.dart';

class CustomGridview extends StatelessWidget {
  const CustomGridview({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    List productName = [
      "Product 1",
      "Product 2",
      "Product 3",
      "Product 4",
      "Product 5",
      "Product 6",
      "Product 7",
      "Product 8",
      "Product 9",
      "Product 10",
      "Product 11",
      "Product 12",
      "Product 13",
      "Product 14",
      "Product 15",
    ];
    List price = [
      "1000",
      "800",
      "1200",
      "1500",
      "1000",
      "800",
      "1200",
      "1500",
      "1000",
      "800",
      "1200",
      "1500",
      "1000",
      "800",
      "1200",
    ];
    List<String> images = [
      "assets/images/p1.jpeg",
      "assets/images/p2.jpeg",
      "assets/images/p3.jpeg",
      "assets/images/p4.jpeg",
      "assets/images/p5.jpeg",
      "assets/images/p6.jpeg",
      "assets/images/p7.jpeg",
      "assets/images/p8.jpeg",
      "assets/images/p9.jpeg",
      "assets/images/p10.jpeg",
      "assets/images/p11.jpeg",
      "assets/images/p12.jpeg",
      "assets/images/p3.jpeg",
      "assets/images/p4.jpeg",
      "assets/images/p5.jpeg",
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
      itemCount: productName.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: screenWidth * 0.03,
        mainAxisSpacing: screenHeight * 0.02,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  name: productName[index],
                  price: price[index],
                  image: images[index],
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white60,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  height: screenWidth * 0.45,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(images[index]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 8, right: 15),
                  child: Text(
                    "${productName[index]}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, top: 8),
                  child: Text(
                    "Rs. ${price[index]}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
