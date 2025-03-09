import 'package:clients/main.dart';
import 'package:clients/screen/bookingpage.dart';
import 'package:flutter/material.dart';

class SkillScreen extends StatefulWidget {
  final int skillId;
  const SkillScreen({super.key, required this.skillId});

  @override
  State<SkillScreen> createState() => _SkillScreenState();
}

class _SkillScreenState extends State<SkillScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> spList = [];

  Future<void> fetchData(int skillId) async {
  setState(() {
    isLoading = true;
  });
  try {
    // Fetch service providers who have the selected skill
    final response = await supabase
        .from('tbl_spskills')
        .select('''
          sp_id,
          tbl_sp!inner(*)
        ''')
        .eq('skill_id', skillId);

    print("Data Fetched: $response");

    // Extract the service providers from the response
    setState(() {
      isLoading = false;
      spList = List<Map<String, dynamic>>.from(response.map((item) => item['tbl_sp']));
    });
  } catch (e) {
    print("Error: $e");
    setState(() {
      isLoading = false;
    });
  }
}

  void initState() {
    super.initState();
    fetchData(widget.skillId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Service Painters'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for painters...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            // List of Painters
            Expanded(
              child: ListView.builder(
                itemCount: spList.length,
                itemBuilder: (context, index) {
                  return PainterCard(painter: spList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PainterCard extends StatefulWidget {
  final Map<String, dynamic> painter;

  const PainterCard({super.key, required this.painter});

  @override
  State<PainterCard> createState() => _PainterCardState();
}

class _PainterCardState extends State<PainterCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Painter Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.painter['sp_photo'] ?? "https://via.placeholder.com/150",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                // errorBuilder: (context, error, stackTrace) {
                //   return const Center(child: Icon(Icons.broken_image),);
                // },
              ),
            ),
            SizedBox(width: 16),
            // Painter Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.painter['sp_name'] ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Icon(Icons.star, color: Colors.amber, size: 16),
                  //     SizedBox(width: 4),
                  //     Text(
                  //       '${painter['rating']} (${painter['reviews']} reviews)',
                  //       style: TextStyle(fontSize: 14),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 8),
                  // Text(
                  //   'Experience: ${painter['experience']}',
                  //   style: TextStyle(fontSize: 14, color: Colors.grey),
                  // ),
                  // SizedBox(height: 8),
                  // Text(
                  //   'Services: ${painter['services']}',
                  //   style: TextStyle(fontSize: 14, color: Colors.grey),
                  // ),
                ],
              ),
            ),
            // Book Now Button
            ElevatedButton(
              onPressed: () {
                // Implement booking functionality
                
               Navigator.push(context,MaterialPageRoute(builder: (context)=>Booking(id: widget.painter['id'],)));

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 72, 169, 75),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text('Book Now', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
