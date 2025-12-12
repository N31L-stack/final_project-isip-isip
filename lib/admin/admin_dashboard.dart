// lib/admin/admin_dashboard_complete.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ============================================================================
// --- ADMIN DASHBOARD WITH APPOINTMENT MANAGEMENT ---
// ============================================================================

class AdminDashboardComplete extends StatefulWidget {
  const AdminDashboardComplete({super.key});

  @override
  State<AdminDashboardComplete> createState() => _AdminDashboardCompleteState();
}

class _AdminDashboardCompleteState extends State<AdminDashboardComplete> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminMetricsPage(),
    const AdminAppointmentsPage(),
    const AdminProfessionalsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF5B9BD5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Metrics'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Professionals'),
        ],
      ),
    );
  }
}

// ============================================================================
// --- METRICS PAGE ---
// ============================================================================

class AdminMetricsPage extends StatelessWidget {
  const AdminMetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard Metrics',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5B9BD5)),
          ),
          const Divider(),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildMetricCard('Total Users', 'users', Icons.people, Colors.blue),
              _buildMetricCard('Professionals', 'professionals', Icons.person_4, Colors.green),
              _buildMetricCard('Pending Requests', 'professional_requests', Icons.hourglass_bottom, Colors.orange),
              _buildMetricCard('Appointments', 'appointments', Icons.calendar_today, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String collection, IconData icon, Color color) {
    return FutureBuilder<AggregateQuerySnapshot>(
      future: FirebaseFirestore.instance.collection(collection).count().get(),
      builder: (context, snapshot) {
        String count = '...';
        if (snapshot.hasData) {
          count = (snapshot.data!.count ?? 0).toString();
        }
        return Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 8),
                Text(count, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// --- APPOINTMENTS MANAGEMENT PAGE ---
// ============================================================================

class AdminAppointmentsPage extends StatefulWidget {
  const AdminAppointmentsPage({super.key});

  @override
  State<AdminAppointmentsPage> createState() => _AdminAppointmentsPageState();
}

class _AdminAppointmentsPageState extends State<AdminAppointmentsPage> {
  String _filterStatus = 'all'; // all, pending, accepted, rejected
  final Map<String, int> _statusCounts = {'pending': 0, 'accepted': 0, 'rejected': 0};

  @override
  void initState() {
    super.initState();
    _loadStatusCounts();
  }

  Future<void> _loadStatusCounts() async {
    try {
      for (String status in ['pending', 'accepted', 'rejected']) {
        final count = await FirebaseFirestore.instance
            .collection('professional_requests')
            .where('status', isEqualTo: status)
            .count()
            .get();
        if (mounted) {
          setState(() => _statusCounts[status] = count.count ?? 0);
        }
      }
    } catch (e) {
      debugPrint('Error loading counts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manage Appointments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Filter chips
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _filterStatus == 'all',
                  onSelected: (selected) => setState(() => _filterStatus = 'all'),
                ),
                ...['pending', 'accepted', 'rejected'].map((status) {
                  final isSelected = _filterStatus == status;
                  return FilterChip(
                    label: Text('${status.toUpperCase()} (${_statusCounts[status] ?? 0})'),
                    selected: isSelected,
                    onSelected: (selected) => setState(() => _filterStatus = status),
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 16),

            _filterStatus == 'all' 
                ? _buildAllAppointmentsView()
                : _buildFilteredAppointmentsView(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllAppointmentsView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('professional_requests')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('No appointments', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        final requests = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final data = requests[index].data() as Map<String, dynamic>?;
            final requestId = requests[index].id;

            if (data == null) return const SizedBox.shrink();

            return _buildAppointmentCard(
              requestId: requestId,
              clientName: data['clientName'] as String? ?? 'Unknown',
              clientId: data['clientId'] as String? ?? '',
              professionalName: data['professionalName'] as String? ?? 'Unknown',
              professionalId: data['professionalId'] as String? ?? '',
              status: data['status'] as String? ?? 'pending',
              appointmentData: data['appointmentData'] as Map<String, dynamic>? ?? {},
              onStatusChanged: () {
                setState(() {});
                _loadStatusCounts();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFilteredAppointmentsView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('professional_requests')
          .where('status', isEqualTo: _filterStatus)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text('No $_filterStatus appointments', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        final requests = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final data = requests[index].data() as Map<String, dynamic>?;
            final requestId = requests[index].id;

            if (data == null) return const SizedBox.shrink();

            return _buildAppointmentCard(
              requestId: requestId,
              clientName: data['clientName'] as String? ?? 'Unknown',
              clientId: data['clientId'] as String? ?? '',
              professionalName: data['professionalName'] as String? ?? 'Unknown',
              professionalId: data['professionalId'] as String? ?? '',
              status: data['status'] as String? ?? 'pending',
              appointmentData: data['appointmentData'] as Map<String, dynamic>? ?? {},
              onStatusChanged: () {
                setState(() {});
                _loadStatusCounts();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAppointmentCard({
    required String requestId,
    required String clientName,
    required String clientId,
    required String professionalName,
    required String professionalId,
    required String status,
    required Map<String, dynamic> appointmentData,
    required VoidCallback onStatusChanged,
  }) {
    final hasAppointment = appointmentData.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$clientName → $professionalName', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        hasAppointment
                            ? 'Session: ${appointmentData['date']} at ${appointmentData['time']} (${appointmentData['mode']})'
                            : 'No appointment scheduled',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(status.toUpperCase()),
                  backgroundColor: _getStatusColor(status),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasAppointment && appointmentData['adminMessage'] != null && (appointmentData['adminMessage'] as String).isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Admin Message:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(appointmentData['adminMessage'] as String? ?? '', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (status == 'pending')
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminHandleAppointmentPage(
                      requestId: requestId,
                      clientName: clientName,
                      clientId: clientId,
                      professionalName: professionalName,
                      professionalId: professionalId,
                    ),
                  ),
                ).then((_) => onStatusChanged()),
                icon: const Icon(Icons.edit),
                label: const Text('Handle Request'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green.shade100;
      case 'rejected':
        return Colors.red.shade100;
      default:
        return Colors.orange.shade100;
    }
  }
}

// ============================================================================
// --- ADMIN HANDLE APPOINTMENT PAGE ---
// ============================================================================

class AdminHandleAppointmentPage extends StatefulWidget {
  final String requestId;
  final String clientName;
  final String clientId;
  final String professionalName;
  final String professionalId;

  const AdminHandleAppointmentPage({
    super.key,
    required this.requestId,
    required this.clientName,
    required this.clientId,
    required this.professionalName,
    required this.professionalId,
  });

  @override
  State<AdminHandleAppointmentPage> createState() => _AdminHandleAppointmentPageState();
}

class _AdminHandleAppointmentPageState extends State<AdminHandleAppointmentPage> {
  DateTime? _selectedDate;
  String? _selectedTime;
  String _selectedMode = 'In-Person';
  final _messageController = TextEditingController();
  bool _isLoading = false;

  final List<String> _availableTimes = [
    '9:00 AM', '10:00 AM', '11:00 AM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM',
  ];

  final List<String> _modes = ['In-Person', 'Video Call', 'Audio Call'];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _acceptAppointment() async {
    if (_selectedDate == null || _selectedTime == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select date and time')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('professional_requests').doc(widget.requestId).update({
        'status': 'accepted',
        'appointmentData': {
          'date': '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
          'time': _selectedTime,
          'mode': _selectedMode,
          'adminMessage': _messageController.text,
          'createdAt': FieldValue.serverTimestamp(),
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment accepted'), backgroundColor: Colors.green));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _rejectAppointment() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('professional_requests').doc(widget.requestId).update({
        'status': 'rejected',
        'rejectionMessage': _messageController.text.isEmpty ? 'Request rejected by admin' : _messageController.text,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment rejected'), backgroundColor: Colors.red));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Handle Appointment'), backgroundColor: const Color(0xFF5B9BD5)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.clientName} → ${widget.professionalName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Client ID: ${widget.clientId}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Select Meeting Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _modes.map((mode) {
                final isSelected = _selectedMode == mode;
                return ChoiceChip(
                  label: Text(mode),
                  selected: isSelected,
                  onSelected: (selected) => setState(() => _selectedMode = mode),
                  selectedColor: const Color(0xFF5B9BD5),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            const Text('Select Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF5B9BD5)),
                    const SizedBox(width: 12),
                    Text(_selectedDate == null ? 'Choose a date' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Select Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: _availableTimes.length,
              itemBuilder: (context, index) {
                final time = _availableTimes[index];
                final isSelected = _selectedTime == time;
                return InkWell(
                  onTap: () => setState(() => _selectedTime = time),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF5B9BD5) : Colors.white,
                      border: Border.all(color: isSelected ? const Color(0xFF5B9BD5) : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(time, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            const Text('Message to Client (Optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add any details about the session, platform link, or instructions...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _rejectAppointment,
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _acceptAppointment,
                    icon: const Icon(Icons.check),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

// ============================================================================
// --- PROFESSIONALS MANAGEMENT PAGE ---
// ============================================================================

class AdminProfessionalsPage extends StatefulWidget {
  const AdminProfessionalsPage({super.key});

  @override
  State<AdminProfessionalsPage> createState() => _AdminProfessionalsPageState();
}

class _AdminProfessionalsPageState extends State<AdminProfessionalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All Professionals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddProfessionalPage()),
                  ).then((_) => setState(() {})),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('professionals').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No professionals added'));
                }

                final professionals = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: professionals.length,
                  itemBuilder: (context, index) {
                    final data = professionals[index].data() as Map<String, dynamic>?;
                    final docId = professionals[index].id;

                    if (data == null) return const SizedBox.shrink();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['imageUrl'] as String? ?? 'https://via.placeholder.com/150'),
                          onBackgroundImageError: (exception, stackTrace) {},
                        ),
                        title: Text(data['name'] as String? ?? 'Unknown'),
                        subtitle: Text(data['specialization'] as String? ?? 'N/A'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProfessional(docId),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteProfessional(String docId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Professional?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('professionals').doc(docId).delete();
              if (mounted) Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// --- ADD PROFESSIONAL PAGE ---
// ============================================================================

class AddProfessionalPage extends StatefulWidget {
  const AddProfessionalPage({super.key});

  @override
  State<AddProfessionalPage> createState() => _AddProfessionalPageState();
}

class _AddProfessionalPageState extends State<AddProfessionalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _priceController = TextEditingController();
  final _aboutController = TextEditingController();
  final _imageUrlController = TextEditingController();

  double _rating = 4.5;
  bool _isLoading = false;

  Future<void> _saveProfessional() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('professionals').add({
        'name': _nameController.text.trim(),
        'role': _roleController.text.trim(),
        'specialization': _specializationController.text.trim(),
        'experience': _experienceController.text.trim(),
        'price': _priceController.text.trim(),
        'about': _aboutController.text.trim(),
        'imageUrl': _imageUrlController.text.trim().isEmpty ? 'https://via.placeholder.com/150' : _imageUrlController.text.trim(),
        'rating': _rating,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Professional added!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Professional'), backgroundColor: const Color(0xFF5B9BD5)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name *', border: OutlineInputBorder()),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role *', border: OutlineInputBorder()),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'Specialization *', border: OutlineInputBorder()),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: 'Experience *', border: OutlineInputBorder()),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price *', border: OutlineInputBorder()),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL', border: OutlineInputBorder(), hintText: 'Optional'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _aboutController,
                decoration: const InputDecoration(labelText: 'About *', border: OutlineInputBorder()),
                maxLines: 4,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Slider(
                value: _rating,
                min: 0,
                max: 5,
                divisions: 10,
                label: _rating.toStringAsFixed(1),
                onChanged: (v) => setState(() => _rating = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfessional,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5)),
                  child: Text(_isLoading ? 'Saving...' : 'Save Professional'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _priceController.dispose();
    _aboutController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}