import 'package:flutter/material.dart';

// --- THE RESOURCES SCREEN (Professional Directory) ---
class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  static const Color startColor = Color(0xFFC8E6F0);
  static const Color endColor = Color(0xFFE8F6D6);

  // Mock data for verified professionals
  static final List<Professional> professionals = [
    Professional(
      name: 'Dr. Anya Sharma',
      role: 'Therapist',
      specialization: 'CBT, Trauma',
      imageUrl: 'https://placehold.co/100x100/A0C0F0/000?text=AS',
    ),
    Professional(
      name: 'Mark Chen',
      role: 'Counselor',
      specialization: 'Family Conflict',
      imageUrl: 'https://placehold.co/100x100/F0A0C0/000?text=MC',
    ),
    Professional(
      name: 'Sarah Lee, Psy.D.',
      role: 'Psychologist',
      specialization: 'Anxiety, Depression',
      imageUrl: 'https://placehold.co/100x100/C0F0A0/000?text=SL',
    ),
    Professional(
      name: 'John Davis',
      role: 'Therapist',
      specialization: 'Grief Counseling',
      imageUrl: 'https://placehold.co/100x100/E0C0F8/000?text=JD',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startColor, endColor],
          ),
        ),
        child: SafeArea(
          // Ensure the entire SafeArea is the parent container for the modal look
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Container(
              // The main white card/modal that holds the content
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                // Layout FIX: Removed mainAxisSize.min so the Expanded widget can take the available space
                mainAxisAlignment: MainAxisAlignment.start, 
                children: [
                  // Header with Filter Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Find a Professional',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Filter options opened')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            child: const Icon(Icons.tune, color: Color(0xFF5B9BD5), size: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Professional List (Scrollable) - Now correctly sized by Expanded
                  Expanded(
                    child: ListView.builder(
                      itemCount: professionals.length,
                      itemBuilder: (context, index) {
                        return ProfessionalCard(professional: professionals[index]);
                      },
                    ),
                  ),
                  
                  // Book Session Button (Bottom fixed button)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Navigating to Booking Page...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9BD5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Book Session', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Professional Data Model
class Professional {
  final String name;
  final String role;
  final String specialization;
  final String imageUrl;

  Professional({required this.name, required this.role, required this.specialization, required this.imageUrl});
}

// Professional Card Widget
class ProfessionalCard extends StatelessWidget {
  final Professional professional;

  const ProfessionalCard({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    // Style matches the rounded, elevated list items from the image
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundColor: professional.role == 'Therapist' ? Colors.blue.shade100 : Colors.purple.shade100,
            backgroundImage: NetworkImage(professional.imageUrl, scale: 1.0, ), // Added scale property
            onBackgroundImageError: (exception, stackTrace) {
              // Fallback on error
              print('Image failed to load: $exception');
            },
            child: professional.imageUrl.isEmpty 
              ? Text(professional.name.substring(0, 1), style: const TextStyle(fontWeight: FontWeight.bold)) 
              : null,
          ),
          const SizedBox(width: 15),
          
          // Name and Specialization
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  professional.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                ),
                Text(
                  professional.role,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                ),
                Text(
                  'Specialization: ${professional.specialization}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}