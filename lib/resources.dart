import 'package:flutter/material.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Resources",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionTitle("Professional Support"),
          SizedBox(height: 12),
          ProfessionalCard(
            name: "Dr. Melissa Santos",
            imageUrl: "https://i.imgur.com/92a2FYO.png",
            rating: 4.9,
            experience: "12 Years Experience",
            price: "₱1,799/session",
          ),
          SizedBox(height: 20),
          ProfessionalCard(
            name: "Psychologist Alex Cruz",
            imageUrl: "https://i.imgur.com/ZSLOQkN.png",
            rating: 4.7,
            experience: "8 Years Experience",
            price: "₱1,499/session",
          ),
           ProfessionalCard(
                name: "Dr. Anya Sharma",
              
                imageUrl: "https://i.pravatar.cc/150?img=1",
                rating: 4.9,
                experience: "12 years",
                price: "₱2,500/session",
              ),
              ProfessionalCard(
                name: "Mark Chen",
                imageUrl: "https://i.pravatar.cc/150?img=12",
                rating: 4.8,
                experience: "8 years",
                price: "₱2,000/session",
              ),
              ProfessionalCard(
                name: "Sarah Lee, Psy.D.",
                imageUrl: "https://i.pravatar.cc/150?img=5",
                rating: 5.0,
                experience: "15 years",
                price: "₱3,000/session",
              ),
              ProfessionalCard(
                name: "Dr. James Rodriguez",
                imageUrl: "https://i.pravatar.cc/150?img=33",
                rating: 4.7,
                experience: "10 years",
                price: "₱3,500/session",
              ),
              ProfessionalCard(
                name: "Emily Thompson",
                imageUrl: "https://i.pravatar.cc/150?img=9",
                rating: 4.9,
                experience: "7 years",
                price: "₱2,200/session",
              ),
              ProfessionalCard(
                name: "Dr. Michael Park",
                imageUrl: "https://i.pravatar.cc/150?img=14",
                rating: 4.8,
                experience: "11 years",
                price: "₱2,800/session",
              ),
              ProfessionalCard(
                name: "Lisa Martinez",
                imageUrl: "https://i.pravatar.cc/150?img=20",
                rating: 4.9,
                experience: "9 years",
                price: "₱2,400/session",
              ),
              ProfessionalCard(
                name: "Dr. Robert Kim",
                imageUrl: "https://i.pravatar.cc/150?img=52",
                rating: 4.7,
                experience: "13 years",
                price: "₱3,200/session",
              ),
              ProfessionalCard(
                name: "Jennifer Williams",
                imageUrl: "https://i.pravatar.cc/150?img=47",
                rating: 5.0,
                experience: "10 years",
                price: "₱2,600/session",
              ),
              ProfessionalCard(
                name: "Dr. David Brown",
                imageUrl: "https://i.pravatar.cc/150?img=56",
                rating: 4.8,
                experience: "14 years",
                price: "₱2,700/session",
              ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ProfessionalCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final String experience;
  final String price;

  const ProfessionalCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.experience,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    experience,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B9BD5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
