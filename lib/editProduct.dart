import 'package:flutter/material.dart';

void main() {
  // Use the global product data list
  runApp(const MyApp());
}

// Global list of products for easy access in navigation/alerts
final List<Product> _allProductsData = [
  Product(
    name: 'Organic Compost',
    image: '🌱',
    price: 150,
    status: 'In Stock',
    stock: 25,
    category: 'Compost',
  ),
  Product(
    name: 'Bio Fertilizer Liquid',
    image: '🌿',
    price: 299,
    status: 'Low Stock', 
    stock: 3,
    category: 'Bio Fertilizer',
  ),
  Product(
    name: 'Recycled Planters',
    image: '🪴',
    price: 450,
    status: 'In Stock',
    stock: 15,
    category: 'Recycled Item',
  ),
  Product(
    name: 'Bamboo Toothbrush',
    image: '🎋',
    price: 199,
    status: 'Out of Stock',
    stock: 0,
    category: 'Eco-Friendly Product',
  ),
  Product(
    name: 'Organic Vegetable Seeds',
    image: '🌾',
    price: 89,
    status: 'Low Stock', 
    stock: 1,
    category: 'Eco-Friendly Product',
  ),
  Product(
    name: 'Reusable Water Bottle',
    image: '💧',
    price: 399,
    status: 'In Stock',
    stock: 20,
    category: 'Eco-Friendly Product',
  ),
  Product(
    name: 'Solar Garden Lights',
    image: '☀️',
    price: 599,
    status: 'In Stock',
    stock: 12,
    category: 'Solar Product',
  ),
  Product(
    name: 'Organic Cotton Bags',
    image: '👜',
    price: 249,
    status: 'Low Stock', 
    stock: 4,
    category: 'Recycled Item',
  ),
  Product(
    name: 'Biodegradable Plates',
    image: '🍽️',
    price: 179,
    status: 'Out of Stock',
    stock: 0,
    category: 'Eco-Friendly Product',
  ),
  Product(
    name: 'Natural Soap Bars',
    image: '🧼',
    price: 129,
    status: 'In Stock',
    stock: 30,
    category: 'Eco-Friendly Product',
  ),
  Product(
    name: 'Jute Plant Holders',
    image: '🌸',
    price: 349,
    status: 'Low Stock', 
    stock: 2,
    category: 'Recycled Item',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Products',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFE8F5E9),
      ),
      home: ProductsScreen(
        allProducts: _allProductsData,
      ),
    );
  }
}

class Product {
  final String name;
  final String image;
  final double price;
  final String status;
  final int stock;
  final String category;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.status,
    required this.stock,
    required this.category,
  });
}

// ----------------------------------------------------
// Alerts Screen
// ----------------------------------------------------
class AlertsScreen extends StatelessWidget {
  final List<Product> lowStockProducts;
  final Product? highlightedProduct;

  const AlertsScreen({
    super.key,
    required this.lowStockProducts,
    this.highlightedProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Stock Alerts ⚠️'),
        backgroundColor: Colors.red.shade100,
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: lowStockProducts.isEmpty
          ? const Center(
              child: Text(
                'No low stock alerts currently.',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (highlightedProduct != null)
                  _buildHighlightedCard(highlightedProduct!),
                if (highlightedProduct != null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'All Low Stock Items:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ...lowStockProducts.map((product) {
                  // Only show if it's not the highlighted one, or if there is no highlighted one
                  if (product.name != highlightedProduct?.name) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildAlertProductCard(product, context),
                    );
                  }
                  return const SizedBox.shrink(); // Hide the duplicate
                }),
              ],
            ),
    );
  }

  Widget _buildHighlightedCard(Product product) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚠️ ITEM TAPPED: Action Required ⚠️',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Divider(height: 16, color: Colors.redAccent),
          _buildAlertProductCard(product, null),
        ],
      ),
    );
  }

  Widget _buildAlertProductCard(Product product, BuildContext? context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            product.image,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Stock: ${product.stock} | Price: ₹${product.price.toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.orange.shade800),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// ProductsScreen (Main Screen)
// ----------------------------------------------------
class ProductsScreen extends StatefulWidget {
  final List<Product> allProducts;
  const ProductsScreen({super.key, required this.allProducts});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All Products';
  String _searchQuery = '';
  int _selectedIndex = 1; // Start on Products tab
  // NEW: State to track the low stock count the user last saw
  int _lastViewedLowStockCount = 0; 

  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  late AnimationController _floatController;
  late Animation<Offset> _floatAnimation;

  List<Product> get _allProducts => widget.allProducts;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
    _fabController.forward();

    // Floating animation for FAB
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.1),
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    List<Product> products = _allProducts;

    if (_searchQuery.isNotEmpty) {
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedFilter == 'In Stock') {
      products = products
          .where((p) => p.status == 'In Stock' && p.stock > 5)
          .toList();
    } else if (_selectedFilter == 'Low Stock') {
      products = products
          .where((p) => p.status == 'Low Stock' || (p.stock > 0 && p.stock <= 5))
          .toList();
    } else if (_selectedFilter == 'Out of Stock') {
      products = products
          .where((p) => p.status == 'Out of Stock' || p.stock == 0)
          .toList();
    }

    return products;
  }

  int get _totalProducts => _allProducts.length;
  // This getter calculates the CURRENT number of low stock items
  int get _lowStockCount => _allProducts
      .where((p) => p.status == 'Low Stock' || (p.stock > 0 && p.stock <= 5))
      .length;
      
  int get _outOfStockCount =>
      _allProducts.where((p) => p.status == 'Out of Stock').length;
  
  List<Product> get _lowStockItems => _allProducts
      .where((p) => p.status == 'Low Stock' || (p.stock > 0 && p.stock <= 5))
      .toList();


  // UPDATED: Manages the last viewed count for the badge logic
  void _onItemTapped(int index) {
    // 1. Visually update the index first
    setState(() {
      _selectedIndex = index;
    });

    // 2. Handle navigation for the Alerts tab (index 3)
    if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AlertsScreen(
            lowStockProducts: _lowStockItems,
          ),
        ),
      ).then((_) {
        // 3. IMPORTANT: When the user returns from AlertsScreen, 
        // update the last viewed count to the CURRENT total.
        setState(() {
          _lastViewedLowStockCount = _lowStockCount;
          _selectedIndex = 1; // Reset to Products tab
        });
      });
    } else if (index == 1) { // Products tab
      _selectedFilter = 'All Products';
      _searchQuery = '';
      _searchController.clear();
    }  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsCards(),
            _buildFilterChips(),
            Expanded(child: _buildProductsList()),
          ],
        ),
      ),
      floatingActionButton: SlideTransition(
        position: _floatAnimation,
        child: ScaleTransition(
          scale: _fabAnimation,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.green.shade600,
            elevation: 8,
            child: const Icon(Icons.add, size: 32),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Products',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Manage your eco-friendly products',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.grid_view),
                onPressed: () {},
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => _showSearchDialog(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildStatCard(
            '$_totalProducts',
            'Total Products',
            Colors.green.shade600,
            Icons.inventory_2,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            '$_lowStockCount',
            'Low Stock',
            Colors.orange.shade600,
            Icons.warning_amber_rounded,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            '$_outOfStockCount',
            'Out of Stock',
            Colors.red.shade600,
            Icons.remove_shopping_cart,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color, IconData icon) {
    return Expanded(
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double opacity, child) {
          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: opacity,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.9),
                      blurRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(icon, color: color, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All Products', Colors.green.shade600),
            const SizedBox(width: 8),
            _buildFilterChip('In Stock', Colors.blue.shade600),
            const SizedBox(width: 8),
            _buildFilterChip('Low Stock', Colors.orange.shade600),
            const SizedBox(width: 8),
            _buildFilterChip('Out of Stock', Colors.red.shade600), 
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, Color color) {
    final isSelected = _selectedFilter == label;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = label),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildProductCard(products[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    Color statusColor;
    List<BoxShadow> shadows;

    if (product.status == 'In Stock') {
      statusColor = Colors.green.shade600;
      shadows = [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];
    } else if (product.status == 'Low Stock') {
      statusColor = Colors.orange.shade600;
      shadows = [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];
    } else {
      statusColor = Colors.red.shade600;
      // Original Out of Stock shadow animation restored
      shadows = [
        BoxShadow(
          color: Colors.red.withOpacity(0.5),
          blurRadius: 5,
          spreadRadius: 6,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.red.withOpacity(0.2),
          blurRadius: 30,
          spreadRadius: 6,
          offset: const Offset(0, 6),
        ),
      ];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigation logic for tapping a low stock product
            if (product.status == 'Low Stock') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AlertsScreen(
                    lowStockProducts: _lowStockItems,
                    highlightedProduct: product, // Highlight the tapped product
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Hero(
                  tag: product.name,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade100,
                          Colors.green.shade200,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        product.image,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue.shade600),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red.shade600),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Category: ${product.category}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${product.status} ${product.stock > 0 ? '(${product.stock})' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 60, left: 16, right: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Search Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter product name...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {}); // Rebuilds product list with latest _searchQuery
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    // CONDITION: Badge is visible if the CURRENT low stock count is GREATER than 
    // the count the user last saw.
    final showBadge = _lowStockCount > _lastViewedLowStockCount;
    final alertIcon = Icon(
      Icons.notifications,
      color: _selectedIndex == 3 ? Colors.green.shade600 : Colors.grey.shade400,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green.shade600,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: _selectedIndex, 
        elevation: 0,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          // Alert Item with simple Red Dot Indicator
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                alertIcon,
                if (showBadge) // Use the new logic here
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  )
              ],
            ),
            label: 'Alerts',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}