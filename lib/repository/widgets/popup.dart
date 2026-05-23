import 'package:flutter/material.dart';
import 'package:grofix/provider/cartProvider.dart';
import 'package:grofix/repository/screens/cart/cartScreen.dart';
import 'package:provider/provider.dart';


class ViewCartPopup extends StatelessWidget {
  const ViewCartPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cartprovider>(
      builder: (context, cart, child) {

        if (!cart.showPopup) {
          return SizedBox();
        }

        return AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          bottom: cart.showPopup ? 20 : -100,
          left: 80,
          right: 80,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => cartScreen(),
                ),
              );
            },
            child: Container(
              height: 50,
              
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // 🔹 Items
                  Text(
                    "${cart.totalItems} item${cart.totalItems > 1 ? 's' : ''}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // 🔹 Price
                 

                  // 🔹 Button
                  Row(
                    children: [
                      Text(
                        "View Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward, color: Colors.white)
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


