import 'package:clients/main.dart';
import 'package:flutter/material.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  String? clientId;
  List<Map<String, dynamic>> bookings = []; // List to store bookings

  @override
  void initState() {
    super.initState();
    fetchLoggedInClientId(); // Fetch the logged-in client's ID
  }

  // Fetch the logged-in client's ID
  Future<void> fetchLoggedInClientId() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        setState(() {
          clientId = user.id; // Set the clientId to the logged-in user's ID
        });
        fetchData(); // Fetch the client's bookings after setting the ID
      } else {
        print('Error: No user is currently logged in.');
      }
    } catch (e) {
      print('Error fetching logged-in user ID: $e');
    }
  }

  // Fetch the client's bookings
  void fetchData() async {
    if (clientId == null) {
      print('Error: Client ID is null.');
      return;
    }

    try {
      // Fetch data from Supabase
      final response = await supabase
          .from('tbl_request')
          .select()
          .eq('client_id', clientId!);

     if (response!= null) {
      setState(() {
        bookings = List<Map<String, dynamic>>.from(response);
      });
    } else {
      print('Error: No data found for the client ID: $clientId');
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
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: bookings.isEmpty
          ? const Center(
              child: Text(
                'No bookings found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return _buildBookingCard(booking);
              },
            ),
    );
  }

  // Build a booking card
  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Description
            _buildDetailRow(Icons.work, 'Job Description', booking['description'] ?? "N/A"),
            const SizedBox(height: 16),

            // Date
            _buildDetailRow(Icons.calendar_today, 'Date', booking['fordate'] ?? "N/A"),
            const SizedBox(height: 16),

            // Time
            _buildDetailRow(Icons.access_time, 'Time', booking['fortime'] ?? "N/A"),
            const SizedBox(height: 16),

            // Status
            _buildDetailRow(Icons.info, 'Status', 'Confirmed', statusColor: Colors.green),
          ],
        ),
      ),
    );
  }

  // Helper method to build a detail row
  Widget _buildDetailRow(IconData icon, String label, String value, {Color? statusColor}) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: statusColor ?? Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}