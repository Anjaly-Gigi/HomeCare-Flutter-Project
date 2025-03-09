import 'package:clients/main.dart';
import 'package:clients/screen/bookDetails.dart';
import 'package:clients/screen/changePassword.dart';
import 'package:clients/screen/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientProfile extends StatefulWidget {
  const ClientProfile({super.key});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  bool isLoading = true;
  Map<String, dynamic> clientData = {};

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase
          .from('tbl_client')
          .select("*,tbl_place(*, tbl_district(*))")
          .eq('id', supabase.auth.currentUser!.id)
          .single();
      print("Data Fetched Successfully");
      setState(() {
        clientData = response;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Profile',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),),),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 123, 105, 153) ,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              height: 150,
            
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 123, 105, 153),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromARGB(255, 188, 83, 54),
                      child: Text(
                        clientData['client_name'][0],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Client Name
                    Text(
                      clientData.isNotEmpty
                          ? clientData['client_name']
                          : 'No Name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Client Details Section

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 123, 105, 153),  
                        foregroundColor: Colors.white,
                      ),
                      
                      onPressed: () {
                         Navigator.push(context,MaterialPageRoute(builder: (context)=> Editpro()));
                      },
                      child: Text('Edit Profile')),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 123, 105, 153),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> MyBooking()));
                      },
                      child: Text('My Booking')),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 123, 105, 153),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> passwordChange()));
                      },
                      child: Text('Change Password')),
                ],
              ),
            ),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          // Email
                          _buildDetailRow(Icons.email, 'Email',
                              clientData['client_email'] ?? 'No Email'),
                          const SizedBox(height: 10),
                          // Address
                          _buildDetailRow(Icons.location_on, 'Address',
                              clientData['client-address'] ?? 'No Address'),
                          const SizedBox(height: 10),
                          // Contact
                          _buildDetailRow(
                            Icons.phone,
                            'Contact',
                            clientData['client_contact'].toString() ??
                                'No Contact',
                          ),
                          const SizedBox(height: 10),
                          // Place ID
                          _buildDetailRow(
                              Icons.place,
                              'Place',
                              clientData['tbl_place']['place_name'] ??
                                  'No Place ID'),
                          const SizedBox(height: 20),
                          //district
                          const SizedBox(height: 10),
                          // Place ID
                          _buildDetailRow(
                              Icons.place,
                              'District',
                              clientData['tbl_place']['tbl_district']
                                      ['district_name'] ??
                                  'No Place ID'),
                          const SizedBox(height: 20),
                          // Divider
                          Divider(color: Colors.grey.withOpacity(0.3)),
                          const SizedBox(height: 20),
                          // About Section
                          const Text(
                            'About',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'This client is a valued member with a long history of collaboration.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            // My Bookings Button

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build a detail row
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
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
