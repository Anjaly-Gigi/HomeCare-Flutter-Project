import 'package:flutter/material.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Client Name
                    const Text(
                      "Hai, John doe", // Replace with dynamic data
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Client Details
                    const Text(
                      "Email: john.doe@example.com", // Replace with dynamic data
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Phone: +1234567890", // Replace with dynamic data
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Location: New York, USA", // Replace with dynamic data
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Skills GridView
              const Text(
                "Choose a Skill",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  SkillCard(
                    skill: "Painter",
                    image: "assets/pain.png", //painter
                    onTap: () {
                      print("Painter tapped");
                    },
                  ),
                  SkillCard(
                    skill: "Plumber",
                    image: "assets/plu.webp", // Replace with your image
                    onTap: () {
                      print("Plumber tapped");
                    },
                  ),

                  SkillCard(
                    skill: "Electrician",
                    image: "assets/elec.png", // Replace with your image
                    onTap: () {
                      print("Electrician tapped");
                    },
                  ),

                  SkillCard(
                    skill: "Carpenter",
                    image: "assets/carp.png", // Replace with your image
                    onTap: () {
                      print("Carpenter tapped");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Skill Card Widget
class SkillCard extends StatelessWidget {
  final String skill;
  final String image;
  final VoidCallback onTap;

  const SkillCard({
    required this.skill,
    required this.image,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              skill,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


