import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding/cart_model.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: 
      AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 1),
              end: Offset(0, 0),
            ).animate(animation),
            child: child,
          );
        },
        child: cart.items.isEmpty
          ? Center(
              key: ValueKey('emptyCart'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Ohh tidak, keranjang Anda masih kosong nih',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Isi dulu yuks!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) {
                final cartItem = cart.items[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.network(
                      //cartItem.imageAsset,
                      cartItem.imageNetwork,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(cartItem.name),
                    subtitle: Text(
                        '${currencyFormatter.format(cartItem.price)} x ${cartItem.quantity} = ${currencyFormatter.format(cartItem.price * cartItem.quantity)}',
                      ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            cart.addItem(cartItem);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: cartItem.quantity > 1 ?
                            () {
                              cart.decreaseItemQuantity(cartItem.id);
                            }
                          : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            cart.removeItem(cartItem.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${currencyFormatter.format(cart.totalPrice)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Checkout
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Checkout Berhasil!')),
                        );
                        cart.clearCart(); // Clear the cart after checkout
                      },
                      child: Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
