import 'package:flutter/material.dart';
import 'package:serviceprovider/main.dart';

class RequestView extends StatefulWidget {
  const RequestView({super.key});

  @override
  _RequestViewState createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> with SingleTickerProviderStateMixin {
  String? serviceProviderId;
  List<Map<String, dynamic>> bookings = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchLoggedInServiceProviderId();
  }

  Future<void> fetchLoggedInServiceProviderId() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        serviceProviderId = user.id;
      });
      fetchData();
    }
  }

  Future<void> fetchData() async {
    if (serviceProviderId == null) return;
    try {
      final response = await supabase
          .from('tbl_request')
          .select('id, description, date, status, starttime, endtime, charge, sp_id, tbl_client (client_name)')
          .eq('sp_id', serviceProviderId!);

      setState(() {
        bookings = response.isNotEmpty ? List<Map<String, dynamic>>.from(response) : [];
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'New Requests'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(0),
          _buildBookingList(1),
          _buildBookingList(2),
          _buildBookingList(6),
        ],
      ),
    );
  }

  Widget _buildBookingList(int status) {
    List<int> statuses;
    if (status == 1) {
      statuses = [1, 3];  // Approved: includes "Approved" and "In Progress"
    } else if (status == 6) {
      statuses = [4, 5];  // Completed: includes "Job Completed" and "Payment Completed"
    } else {
      statuses = [status];
    }

    final filteredBookings = bookings.where((b) => statuses.contains(b['status'])).toList();

    return filteredBookings.isEmpty
        ? Center(child: Text('No bookings found'))
        : ListView.builder(
            itemCount: filteredBookings.length,
            itemBuilder: (context, index) {
              return _buildBookingCard(filteredBookings[index]);
            },
          );
  }

 Widget _buildBookingCard(Map<String, dynamic> booking) {
  return Card(
    margin: const EdgeInsets.all(12),
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Client: ${booking['tbl_client']['client_name'] ?? 'Unknown'}'),
          Text('Job: ${booking['description'] ?? 'N/A'}'),
          Text('Date: ${booking['date'] ?? 'N/A'}'),
          booking['status'] >=3 ? Text('Start Time: ${booking['starttime'] ?? 'N/A'}') : SizedBox(),
          booking['status'] >=4 ? Text('End Time: ${booking['endtime'] ?? 'N/A'}'): SizedBox(),
          booking['status'] >=4 ? Text('Charge: \$${booking['charge'] != null ? booking['charge'].toString(): 'N/A' }') : SizedBox(),
          
          const SizedBox(height: 10),
          _buildActionButtons(booking),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> booking) {
    switch (booking['status']) {
      case 0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () => _updateStatus(booking['id'], 1),
                child: Text('Accept')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white),
                onPressed: () => _updateStatus(booking['id'], 2),
                child: Text('Reject')),
          ],
        );
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () => _startJob(booking['id']),
                child: Text('Start Job')),
          ],
        );
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white),
                onPressed: () => _showEndJobDialog(booking['id']),
                child: Text('End Job')),
          ],
        );
      case 5:
        return ElevatedButton(
            onPressed: () => _markPaymentCompleted(booking['id']),
            child: Text('Complete Payment'));
      default:
        return SizedBox();
    }
  }

  void _showEndJobDialog(int bookingId) {
    TextEditingController chargeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('End Job'),
          content: TextField(
            controller: chargeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter Job Amount'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                double charge = double.tryParse(chargeController.text) ?? 0.0;
                _endJob(bookingId, charge);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateStatus(int bookingId, int status) async {
    await supabase.from('tbl_request').update({'status': status}).match({'id': bookingId});
    fetchData();
  }

  void _startJob(int bookingId) async {
    String startTime = DateTime.now().toIso8601String();
    await supabase.from('tbl_request').update({'starttime': startTime, 'status': 3}).match({'id': bookingId});
    fetchData();
  }

  void _endJob(int bookingId, double charge) async {
    DateTime end = DateTime.now();
    await supabase.from('tbl_request').update({'endtime': end.toIso8601String(), 'charge': charge, 'status': 5}).match({'id': bookingId});
    fetchData();
  }

  void _markPaymentCompleted(int bookingId) async {
    await supabase.from('tbl_request').update({'status': 6}).match({'id': bookingId});
    fetchData();
  }
}
