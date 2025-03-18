import 'package:flutter/material.dart';
import 'package:app/screens/payment_screen.dart'; 


// Rental item model
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
  bool isDarkMode = false; // Track theme mode
  String selectedCategory = 'All';
  
  // Sample data - replace with your real data
  final List<RentalItem> rentalItems = [
    RentalItem(
      id: '1',
      name: 'Kia Seltos',
      imageUrl: 'assets/Kia_Seltos.jpeg',
      price: 85.00,
      category: 'Cars',
      description: 'Spacious 5-seater SUV perfect for family trips. Includes GPS, Bluetooth, and backup camera.',
      rating: 4.7,
    ),
    RentalItem(
      id: '2',
      name: 'Power Drill Set',
      imageUrl: 'assets/Drill.jpg',
      price: 25.50,
      category: 'Tools',
      description: 'Professional-grade power drill with multiple attachments and variable speed control.',
      rating: 4.5,
    ),
    RentalItem(
      id: '3',
      name: 'Luxury Apartment at Kochi',
      imageUrl: 'assets/Appartment.jpg',
      price: 150.00,
      category: 'Properties',
      description: '3-bedroom luxury apartment with modern amenities, central location and stunning city views.',
      rating: 4.8,
    ),
    RentalItem(
      id: '4',
      name: 'Alto K10',
      imageUrl: 'assets/Alto.webp',
      price: 35.00,
      category: 'Automobiles',
      description: 'Budget friendly for short rides.Offers good millage.',
      rating: 4.6,
    ),
    RentalItem(
      id: '5',
      name: 'DSLR Camera',
      imageUrl: 'assets/Dslr.webp',
      price: 45.00,
      category: 'Electronics',
      description: 'Professional DSLR camera with 24.2MP sensor and 4K video recording capability.',
      rating: 4.9,
    ),
    RentalItem(
      id: '6',
      name: 'BMW 3 Series',
      imageUrl: 'assets/Bmw.jpg',
      price: 65.00,
      category: 'Cars',
      description: 'Fuel-efficient sedan with smooth ride and ample trunk space.',
      rating: 4.3,
    ),
  ];

  List<String> get categories {
    final cats = rentalItems.map((item) => item.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  List<RentalItem> get filteredItems {
    if (selectedCategory == 'All') {
      return rentalItems;
    }
    return rentalItems.where((item) => item.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RentAll"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Search feature coming soon!")),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'support') {
                _showSupportDialog();
              } else if (value == 'settings') {
                _showSettingsDialog();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'support', child: Text("Customer Support")),
              PopupMenuItem(value: 'settings', child: Text("Settings")),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Akash PV"),
              accountEmail: Text("akashpv11c@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/head.png'),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Wishlist'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Wishlist feature coming soon!")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Rental History'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Rental History feature coming soon!")),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Sign-out disabled for now")),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              children: categories.map((category) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Rental items grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _buildRentalItemCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentalItemCard(RentalItem item) {
    return GestureDetector(
      onTap: () => _navigateToItemDetails(item),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Image.asset(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        getIconForCategory(item.category),
                        size: 64,
                        color: Colors.grey[400],
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Item details
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  
                  // Name
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  
                  // Price and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item.price.toStringAsFixed(2)}/day',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          Text(
                            '${item.rating}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToItemDetails(RentalItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsScreen(item: item),
      ),
    );
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case 'Cars':
        return Icons.directions_car;
      case 'Tools':
        return Icons.build;
      case 'Properties':
        return Icons.home;
      case 'Sports':
        return Icons.sports;
      case 'Electronics':
        return Icons.camera_alt;
      default:
        return Icons.category;
    }
  }

  // Show support email dialog
  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Customer Support"),
        content: Text("Email: abhinavelavanz2023@gmail.com"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
        ],
      ),
    );
  }

  // Show settings dialog (Light/Dark mode toggle)
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Settings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("App Theme"),
            SwitchListTile(
              title: Text(isDarkMode ? "Dark Mode" : "Light Mode"),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
                Navigator.pop(context); // Close dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Item details screen
class ItemDetailsScreen extends StatelessWidget {
  final RentalItem item;

  const ItemDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Added to wishlist")),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Share feature coming soon!")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.grey[200],
                child: Center(
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        _getIconForCategory(item.category),
                        size: 100,
                        color: Colors.grey[400],
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and category
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Row(
                        children: [
                          Icon(Icons.star, size: 18, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            '${item.rating}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  // Name
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Price
                  Text(
                    '\$${item.price.toStringAsFixed(2)} / day',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Description heading
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Description
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Features (placeholder)
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildFeaturesList(item.category),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
  child: BottomAppBar(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Contact feature coming soon!")),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Contact Owner'),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(item: item),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text('RENT NOW'),
            ),
          ),
        ],
      ),
    ),
  ),
)



            
          
        
      
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Cars':
        return Icons.directions_car;
      case 'Tools':
        return Icons.build;
      case 'Properties':
        return Icons.home;
      case 'Sports':
        return Icons.sports;
      case 'Electronics':
        return Icons.camera_alt;
      default:
        return Icons.category;
    }
  }

  Widget _buildFeaturesList(String category) {
    List<String> features = [];
    
    // Sample features based on category
    switch (category) {
      case 'Cars':
        features = ['Automatic Transmission', 'GPS Navigation', 'Bluetooth', 'Backup Camera', 'Fuel Efficient'];
        break;
      case 'Tools':
        features = ['Professional Grade', 'Battery Included', 'Case Included', 'Multiple Attachments', 'Variable Speed'];
        break;
      case 'Properties':
        features = ['WiFi', 'Air Conditioning', 'Heating', 'Kitchen', 'Washer & Dryer'];
        break;
      case 'Sports':
        features = ['Lightweight', 'High Performance', 'All Sizes Available', 'Safety Equipment Included'];
        break;
      case 'Electronics':
        features = ['4K Video', 'High Resolution', 'Memory Card Included', 'Extra Battery', 'Carrying Case'];
        break;
      default:
        features = ['Feature 1', 'Feature 2', 'Feature 3', 'Feature 4', 'Feature 5'];
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 16),
            SizedBox(width: 8),
            Text(feature),
          ],
        ),
      )).toList(),
    );
  }
}