import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding/cart_model.dart';
import 'package:intl/intl.dart';

class FeaturedProduct extends StatelessWidget {
  final String id;
  final String category;
  final String name;
  final String description;
  final double price;
  //final String imageAsset;
  final String imageNetwork;

  const FeaturedProduct({
    super.key,
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.price,
    //required this.imageAsset,
    required this.imageNetwork,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
            //  imageAsset,
              imageNetwork,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              currencyFormatter.format(price),
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {

                    Provider.of<CartProvider>(context, listen: false).addItem(
                      CartItem(
                        id: id,
                        //imageAsset: imageAsset,
                        imageNetwork: imageNetwork,
                        name: name,
                        price: price,
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$name ditambahkan ke keranjang!'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
