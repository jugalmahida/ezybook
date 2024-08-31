import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchQuery;
  late List<Map<String, String>> _filteredShops;
  late List<Map<String, String>> _allShops;
  String _selectedCategory = 'All'; // Variable to track the selected category

  @override
  void initState() {
    super.initState();
    _searchQuery = TextEditingController();
    _searchQuery.addListener(_filterShops);

    // Get the arguments from the route settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _selectedCategory = arguments?['category'] ?? 'All';
      _allShops = arguments?['shopDetails'] ?? [];
      _filterShops(); // Initial filter with the passed category
    });

    _filteredShops = [];
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_filterShops);
    _searchQuery.dispose();
    super.dispose();
  }

  void _filterShops() {
    setState(() {
      _filteredShops = _getFilteredShops();
    });
  }

  List<Map<String, String>> _getFilteredShops() {
    final searchText = _searchQuery.text.toLowerCase();

    return _allShops.where((shop) {
      final nameMatches = shop['name']!.toLowerCase().contains(searchText);
      final locationMatches =
          shop['location']!.toLowerCase().contains(searchText);
      final priceMatches = shop['price']!.toLowerCase().contains(searchText);
      final categoryMatches =
          _selectedCategory == 'All' || shop['category'] == _selectedCategory;

      return (nameMatches || locationMatches || priceMatches) &&
          categoryMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Shops"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: _searchQuery,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 242, 242, 247),
                hintText: "Search shops by name, location, or price",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchQuery.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Filter by category:", style: TextStyle(fontSize: 16)),
            Wrap(
              spacing: 10, // Space between chips horizontally
              children: [
                _buildChips(category: "All"),
                _buildChips(category: "HairSalons"),
                _buildChips(category: "Clinic"),
                _buildChips(category: "Restaurant"),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredShops.isEmpty
                  ? const Center(
                      child: Text(
                      'No shops found related your search',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))
                  : ListView.builder(
                      itemCount: _filteredShops.length,
                      itemBuilder: (context, index) {
                        final shop = _filteredShops[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/shop_details_screen",
                              arguments: {
                                'name': shop['name'],
                                'charge': "₹${shop['price']}",
                                'location': shop['location'],
                                'image': shop['mainimage'],
                                'aboutshop': shop['aboutshop'],
                              },
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      shop['mainimage']!,
                                      width: 100,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                shop['name']!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                "₹${shop['price']}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          shop['location']!,
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChips({required String category}) {
    return ChoiceChip(
      label: Text(category),
      selected: _selectedCategory == category,
      onSelected: (bool selected) {
        setState(() {
          _selectedCategory = category;
          _filterShops();
        });
      },
    );
  }
}
