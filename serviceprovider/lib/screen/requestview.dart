import 'package:flutter/material.dart';
import 'package:serviceprovider/main.dart';

class Requestview extends StatefulWidget {
  Requestview({super.key});

  @override
  State<Requestview> createState() => _RequestviewState();
}

class _RequestviewState extends State<Requestview> {
  String? serviceProviderId; // ID of the logged-in service provider
  List<Map<String, dynamic>> bookings = []; // List to store bookings

  @override
  void initState() {
    super.initState();
    fetchLoggedInServiceProviderId(); // Fetch the logged-in service provider's ID
  }

  // Fetch the logged-in service provider's ID
  Future<void> fetchLoggedInServiceProviderId() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        setState(() {
          serviceProviderId = user.id; // Set the serviceProviderId to the logged-in user's ID
        });
        fetchData(); // Fetch the service provider's bookings after setting the ID
      } else {
        print('Error: No user is currently logged in.');
      }
    } catch (e) {
      print('Error fetching logged-in user ID: $e');
    }
  }

  // Fetch the service provider's bookings with client details
  void fetchData() async {
    if (serviceProviderId == null) {
      print('Error: Service Provider ID is null.');
      return;
    }

    try {
      // Fetch data from Supabase with a join between tbl_request and tbl_client
      final response = await supabase
          .from('tbl_request')
          .select('''
            id, 
            description, 
            date, 
            fortime, 
            tbl_client (client_name)
          ''')
          .eq('sp_id', serviceProviderId!); // Assuming 'sp_id' is the column in tbl_request

      if (response != null && response.isNotEmpty) {
        setState(() {
          bookings = List<Map<String, dynamic>>.from(response);
        });
      } else {
        print('Error: No data found for the service provider ID: $serviceProviderId');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 234, 167, 246), Color.fromARGB(255, 194, 216, 255),Color.fromARGB(255, 253, 201, 124),],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: bookings.isEmpty
            ? const Center(
                child: Text(
                  'No bookings found.',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final clientName = booking['tbl_client']['client_name']; // Access nested client_name
                  final jobDescription = booking['description'];
                  final date = booking['date'];
                  final time = booking['fortime'];

                  return _buildBookingCard(clientName, jobDescription, date, time);
                },
              ),
      ),
    );
  }

  // Helper method to build a booking card
  Widget _buildBookingCard(String clientName, String jobDescription, String date, String time) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.deepPurple, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Client: $clientName',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.description, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Job Description: $jobDescription',
                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Date: $date',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Time: $time',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Accept Button
                ElevatedButton.icon(
                  onPressed: () {
                    _handleAccept(); // Handle accept action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 20),
                  label: const Text(
                    'Accept',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 10),
                // Reject Button
                ElevatedButton.icon(
                  onPressed: () {
                    _handleReject(); // Handle reject action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.close, size: 20),
                  label: const Text(
                    'Reject',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Handle Accept Button Press
  void _handleAccept() {
    // Add your logic for accepting the booking
    print('Booking Accepted');
    // You can update the booking status in Supabase here
  }

  // Handle Reject Button Press
  void _handleReject() {
    // Add your logic for rejecting the booking
    print('Booking Rejected');
    // You can update the booking status in Supabase here
  }
}