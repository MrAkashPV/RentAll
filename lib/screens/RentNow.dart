import 'package:flutter/material.dart';
import 'RentNowScreen.dart';

class RentalItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  final String description;
  final double rating;

  RentalItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  final List<RentalItem> rentalItems = [
    RentalItem(
      id: '1',
      name: 'Premium SUV',
      imageUrl: 'https://via.placeholder.com/150',
      price: 85.00,
      category: 'Cars',
      description: 'Spacious 7-seater SUV perfect for family trips.',
      rating: 4.7,
    ),
    RentalItem(
      id: '2',
      name: 'Power Drill Set',
      imageUrl: 'https://via.placeholder.com/150',
      price: 25.50,
      category: 'Tools',
      description: 'Professional-grade power drill with multiple attachments.',
      rating: 4.5,
    ),
    RentalItem(
      id: '3',
      name: 'Luxury Apartment',
      imageUrl: 'https://via.placeholder.com/150',
      price: 150.00,
      category: 'Properties',
      description: '2-bedroom luxury apartment with stunning city views.',
      rating: 4.8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RentAll'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: rentalItems.length,
        itemBuilder: (context, index) {
          final item = rentalItems[index];
          return _buildRentalItemCard(item);
        },
      ),
    );
  }

  Widget _buildRentalItemCard(RentalItem item) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${item.price.toStringAsFixed(2)}/day',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RentNowScreen(
                        itemName: item.name,
                        price: item.price,
                        imageUrl: item.imageUrl,
                      ),
                    ),
                  ),
                  child: Text('Rent Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
