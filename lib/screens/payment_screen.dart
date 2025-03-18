import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart'; // Import your home screen to use RentalItem

class PaymentScreen extends StatefulWidget {
  final RentalItem? item; // Make 'item' nullable

  const PaymentScreen({Key? key, this.item}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}


class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  String cardHolder = '';

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment successful for ${widget.item?.name ?? 'Unknown Item'}")),

      );
      Navigator.pop(context); // Close payment screen after success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
  "${widget.item?.name ?? 'Unknown Item'}",
  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
),

            SizedBox(height: 8),
            Text(
  "Price: ₹${widget.item?.price.toStringAsFixed(2) ?? '0.00'}/day",
  style: TextStyle(fontSize: 18, color: Colors.green)),

SizedBox(height: 20),

            
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Card Holder Name"),
                    validator: (value) => value!.isEmpty ? 'Enter cardholder name' : null,
                    onChanged: (value) => cardHolder = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Card Number"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => value!.length != 16 ? 'Enter a valid 16-digit card number' : null,
                    onChanged: (value) => cardNumber = value,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Expiry Date (MM/YY)"),
                          keyboardType: TextInputType.datetime,
                          validator: (value) => value!.isEmpty ? 'Enter expiry date' : null,
                          onChanged: (value) => expiryDate = value,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "CVV"),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) => value!.length != 3 ? 'Enter a valid CVV' : null,
                          onChanged: (value) => cvv = value,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processPayment,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text("Pay ₹${widget.item?.price.toStringAsFixed(2) ?? '0.00'}"),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
