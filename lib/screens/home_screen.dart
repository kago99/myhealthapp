import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String displayName;
  late String email;

  @override
  void initState() {
    super.initState();
    email = user?.email ?? 'user@example.com';
    displayName = user?.displayName ?? email.split('@')[0];
    displayName = displayName.split(' ').map((s) => s[0].toUpperCase() + s.substring(1)).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text("Hi $displayName", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {})],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(email, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFFF4511E)),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            const ListTile(leading: Icon(Icons.group, color: Color(0xFFF4511E)), title: Text('MyHealth Team')),
            const ListTile(leading: Icon(Icons.medication, color: Color(0xFFF4511E)), title: Text('Medications')),
            const ListTile(leading: Icon(Icons.local_hospital, color: Color(0xFFF4511E)), title: Text('Diagnosis')),
            const ListTile(leading: Icon(Icons.directions_run, color: Color(0xFFF4511E)), title: Text('Activities')),
            const ListTile(leading: Icon(Icons.history, color: Color(0xFFF4511E)), title: Text('Visit History')),
            const ListTile(leading: Icon(Icons.calendar_today, color: Color(0xFFF4511E)), title: Text('Appointment Booking')),
            const ListTile(leading: Icon(Icons.show_chart, color: Color(0xFFF4511E)), title: Text('Readings')),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('Version 3.0.12(23)', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFF4511E).withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text("You need to enroll into services to have full access to MyHealthApp features"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Enroll >>", style: TextStyle(color: Color(0xFFF4511E), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://as1.ftcdn.net/v2/jpg/03/91/09/98/1000_F_391099881_9iasCFHRjYQXBsEyJwvRxxHvGIHS2vu2.jpg',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    "Manage your health from the\ncomfort of your home",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 10, color: Colors.black54)]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Connect", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _buildConnectCard(Icons.videocam, "Doctor"),
              _buildConnectCard(Icons.psychology, "Psychologist"),
              _buildConnectCard(Icons.restaurant, "Nutritionist"),
              _buildConnectCard(Icons.headset_mic, "Support"),
            ]),
            const SizedBox(height: 30),
            const Text("My Health", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildHealthCard(Icons.medication, "My Medications"),
              _buildHealthCard(Icons.show_chart, "My Readings"),
              _buildHealthCard(Icons.folder_open, "My Files"),
            ]),
            const SizedBox(height: 30),
            const Text("Readings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _buildReadingCard("Systolic BP", "--/- mmHg")),
              const SizedBox(width: 12),
              Expanded(child: _buildReadingCard("Diastolic BP", "--/- mmHg")),
            ]),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.call)),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 22,
                    color: Colors.deepOrange,
                    icon: const Icon(Icons.home),
                    padding: const EdgeInsets.only(top: 5, bottom: 0),
                    onPressed: () {},
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10, top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 22,
                    color: Colors.deepOrange,
                    icon: const Icon(Icons.list_rounded),
                    padding: const EdgeInsets.only(top: 5, bottom: 0),
                    onPressed: () {}
                  ),
                  const Text(
                    'Bookings',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10, top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 22,
                    color: Colors.deepOrange,
                    icon: const Icon(Icons.person_outline),
                    padding: const EdgeInsets.only(top: 5, bottom: 0),
                    onPressed: () {},
                  ),
                  const Text(
                    'Doctors',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10, top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 20,
                    color: Colors.deepOrange,
                    icon: const Icon(Icons.chat_bubble_outline),
                    padding: const EdgeInsets.only(top: 5, bottom: 0),
                    onPressed: () {},
                  ),
                  const Text(
                    'Chats',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectCard(IconData icon, String label) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF4511E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF4511E)),
            ),
            child: Icon(icon, size: 32, color: const Color(0xFFF4511E)),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      );

  Widget _buildHealthCard(IconData icon, String label) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: const Color(0xFFF4511E), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, size: 36, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(label),
        ],
      );

  Widget _buildReadingCard(String title, String value) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(color: const Color(0xFFB5651D).withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}