import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'home_screen.dart'; 

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
      if (widget.item == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Item information not available")),
        );
        return;
      }
      
      // Generate a pseudo-random transaction ID
      String transactionId = DateTime.now().millisecondsSinceEpoch.toString().substring(5);
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Processing payment..."),
                ],
              ),
            ),
          );
        },
      );
      
      // Simulate payment processing delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context); // Close loading dialog
        
        // Navigate to the confirmation screen with QR code
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentConfirmationScreen(
              item: widget.item!,
              transactionId: transactionId,
            ),
          ),
        );
      });
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
              style: TextStyle(fontSize: 18, color: Colors.green)
            ),
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

// Payment Confirmation Screen with QR Code
class PaymentConfirmationScreen extends StatelessWidget {
  final RentalItem item;
  final String transactionId;

  const PaymentConfirmationScreen({
    Key? key, 
    required this.item,
    required this.transactionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a unique data string for the QR code
    final qrData = "RentAll:${item.id}:$transactionId:${DateTime.now().millisecondsSinceEpoch}";
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Confirmation"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                "Payment Successful!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Your ${item.category} rental has been confirmed",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Scan QR Code to Confirm Pickup",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Transaction ID: $transactionId",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Item: ${item.name}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Price: ₹${item.price.toStringAsFixed(2)}/day",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Text("Back to Home"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}