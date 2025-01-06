import 'package:flutter/material.dart';
import 'package:dicoding/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:dicoding/cart_screen.dart';
import 'package:intl/intl.dart';

var informationTextStyle = const TextStyle(fontFamily: 'Oxygen');

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 800) {
          return DetailWebPage(product: product);
        } else {
          return DetailMobilePage(product: product);
        }
      },
    );
  }
}

class DetailMobilePage extends StatelessWidget {
  final Map<String, dynamic> product;

  const DetailMobilePage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    int totalQuantity = cart.items.fold(0, (sum, cartItem) => sum + cartItem.quantity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$totalQuantity',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.network(
                  //product['imageAsset'],
                  product['imageNetwork'],
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product['category'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Oxygen',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: Text(
                product['name'],
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Staatliches',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                product['description'],
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Oxygen',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 8.0),
                      Text(
                        currencyFormatter.format(product['price']),
                        style: informationTextStyle,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    final cartItem = CartItem(
                      id: product['id'],
                      //imageAsset: product['imageAsset'],
                      imageNetwork: product['imageNetwork'],
                      name: product['name'],
                      price: product['price'],
                    );
                    cart.addItem(cartItem);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product["name"]} ditambahkan ke keranjang!'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Tambah ke Keranjang'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailWebPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const DetailWebPage({super.key, required this.product});

  @override
  _DetailWebPageState createState() => _DetailWebPageState();
}

class _DetailWebPageState extends State<DetailWebPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cart = Provider.of<CartProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    int totalQuantity = cart.items.fold(0, (sum, cartItem) => sum + cartItem.quantity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$totalQuantity',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 64,
        ),
        child: Center(
          child: SizedBox(
            width: screenWidth <= 1200 ? 800 : 1200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              //widget.product['imageAsset'],
                              widget.product['imageNetwork'],
                              height: screenWidth <= 1200 ? 300 : 400,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                widget.product['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 30.0,
                                  fontFamily: 'Staatliches',
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  widget.product['category'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Oxygen',
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  widget.product['description'],
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Oxygen',
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  const SizedBox(width: 8.0),
                                  Text(
                                  currencyFormatter.format(widget.product['price']),
                                    style: informationTextStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Card(
                        child:
                        ElevatedButton(
                          onPressed: () {
                            final cartItem = CartItem(
                              id: widget.product['id'],
                              //imageAsset: widget.product['imageAsset'],
                              imageNetwork: widget.product['imageNetwork'],
                              name: widget.product['name'],
                              price: widget.product['price'],
                            );
                            cart.addItem(cartItem);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${widget.product['name']} ditambahkan ke keranjang!'),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text('Tambah ke Keranjang'),
                        ),
                      ) 
                    ),
                  ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}