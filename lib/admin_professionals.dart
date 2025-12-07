import 'package:flutter/material.dart';
import 'professionals_details_dialog.dart';

class AdminProfessionals extends StatefulWidget {
  const AdminProfessionals({super.key});

  @override
  State<AdminProfessionals> createState() => _AdminProfessionalsState();
}

class _AdminProfessionalsState extends State<AdminProfessionals> {
  final List<Map<String, dynamic>> _allProfessionals = [
    {
      'name': 'Dr. Anya Sharma',
      'role': 'Therapist',
      'specialization': 'CBT, Trauma',
      'rating': 4.9,
      'experience': '12 years exp',
      'status': 'Active',
      'color': Colors.blue,
      'price': '₱2,500/session',
    },
    {
      'name': 'Mark Chen',
      'role': 'Counselor',
      'specialization': 'Family Conflict, Relationships',
      'rating': 4.8,
      'experience': '8 years exp',
      'status': 'Active',
      'color': Colors.green,
      'price': '₱2,000/session',
    },
    {
      'name': 'Sarah Lee, Psy.D.',
      'role': 'Psychologist',
      'specialization': 'Anxiety, Depression',
      'rating': 5.0,
      'experience': '15 years exp',
      'status': 'Active',
      'color': Colors.purple,
      'price': '₱3,000/session',
    },
    {
      'name': 'Dr. James Rodriguez',
      'role': 'Psychiatrist',
      'specialization': 'Medication Management, ADHD',
      'rating': 4.7,
      'experience': '10 years exp',
      'status': 'On Leave',
      'color': Colors.orange,
      'price': '₱3,500/session',
    },
    {
      'name': 'Emily Thompson',
      'role': 'Licensed Counselor',
      'specialization': 'Grief, Loss, Life Transitions',
      'rating': 4.9,
      'experience': '7 years exp',
      'status': 'Active',
      'color': Colors.teal,
      'price': '₱2,200/session',
    },
    // Additional professionals from your client side
    {
      'name': 'Dr. Michael Park',
      'role': 'Clinical Psychologist',
      'specialization': 'OCD, Panic Disorders',
      'rating': 4.8,
      'experience': '11 years exp',
      'status': 'Active',
      'color': Colors.indigo,
      'price': '₱2,800/session',
    },
    {
      'name': 'Lisa Martinez',
      'role': 'Therapist',
      'specialization': 'PTSD, Stress Management',
      'rating': 4.9,
      'experience': '9 years exp',
      'status': 'Active',
      'color': Colors.pink,
      'price': '₱2,400/session',
    },
    {
      'name': 'Dr. Robert Kim',
      'role': 'Marriage Counselor',
      'specialization': 'Couples Therapy, Communication',
      'rating': 4.7,
      'experience': '13 years exp',
      'status': 'Active',
      'color': Colors.amber,
      'price': '₱3,200/session',
    },
    {
      'name': 'Jennifer Williams',
      'role': 'Child Psychologist',
      'specialization': 'Children & Adolescents',
      'rating': 5.0,
      'experience': '10 years exp',
      'status': 'Active',
      'color': Colors.cyan,
      'price': '₱2,600/session',
    },
    {
      'name': 'Dr. David Brown',
      'role': 'Therapist',
      'specialization': 'Addiction, Substance Abuse',
      'rating': 4.8,
      'experience': '14 years exp',
      'status': 'Active',
      'color': Colors.deepOrange,
      'price': '₱2,700/session',
    },
  ];

  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filters = [
    'All',
    'Therapist',
    'Counselor',
    'Psychologist',
    'Psychiatrist',
    'Clinical Psychologist',
    'Marriage Counselor',
    'Child Psychologist',
    'Licensed Counselor',
    'Active',
    'On Leave',
  ];

  List<Map<String, dynamic>> get _filteredProfessionals {
    List<Map<String, dynamic>> result = _allProfessionals;

    // Apply filter
    if (_selectedFilter != 'All') {
      if (_selectedFilter == 'Active' || _selectedFilter == 'On Leave') {
        result = result.where((p) => p['status'] == _selectedFilter).toList();
      } else {
        result = result.where((p) => p['role'] == _selectedFilter).toList();
      }
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((professional) {
        return professional['name'].toLowerCase().contains(query) ||
            professional['role'].toLowerCase().contains(query) ||
            professional['specialization'].toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Manage Professionals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              _showAddProfessionalDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar (now working!)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search professionals...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filter Tabs with Scroll
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue[50],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey[600],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? Colors.blue : Colors.grey[300]!,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Results Counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(
                  '${_filteredProfessionals.length} professional${_filteredProfessionals.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (_searchQuery.isNotEmpty || _selectedFilter != 'All')
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _selectedFilter = 'All';
                      });
                    },
                    child: const Text(
                      'Clear filters',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Professionals List
          Expanded(
            child: _filteredProfessionals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No professionals found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try a different search term'
                              : 'Try a different filter',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (_searchQuery.isNotEmpty || _selectedFilter != 'All')
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _selectedFilter = 'All';
                                });
                              },
                              child: const Text(
                                'Clear all filters',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredProfessionals.length,
                    itemBuilder: (context, index) {
                      final professional = _filteredProfessionals[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[50],
                            child: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            professional['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                professional['role'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${professional['rating']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '• ${professional['experience']}',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: professional['status'] == 'Active'
                                  ? Colors.green[50]
                                  : Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              professional['status'],
                              style: TextStyle(
                                color: professional['status'] == 'Active'
                                    ? Colors.green[700]
                                    : Colors.orange[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          onTap: () {
                            ProfessionalDetailsDialog.show(
                              context: context,
                              name: professional['name'],
                              role: professional['role'],
                              specialization: professional['specialization'],
                              imageUrl: 'https://i.pravatar.cc/150?img=${index + 1}',
                              rating: professional['rating'],
                              experience: professional['experience'],
                              price: professional['price'],
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddProfessionalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Professional'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Specialization'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'License Number'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Hourly Rate (₱)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Professional added successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Add Professional'),
          ),
        ],
      ),
    );
  }
}