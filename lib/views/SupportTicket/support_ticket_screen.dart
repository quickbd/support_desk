import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:support_desk/providers/auth_provider.dart';
import 'package:support_desk/providers/tickets_provider.dart';
import 'package:support_desk/views/SupportTicket/ticket_form.dart';
import 'package:support_desk/views/Tickets/ticket_details_screen.dart';
import '../../global_widgets/custom_list_tile.dart';
import '../../utils/colors.dart';

class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({super.key});

  @override
  SupportTicketScreenState createState() => SupportTicketScreenState();
}

class SupportTicketScreenState extends State<SupportTicketScreen> {
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final ticketsProvider = Provider.of<TicketsProvider>(context, listen: false);

    final isLoggedIn = await authProvider.checkLoginStatus();
    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      await authProvider.loadUserDetails();
      await ticketsProvider.fetchTickets();
      setState(() {
        _isLoading = false; // Data is loaded, update the loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final ticketsProvider = Provider.of<TicketsProvider>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: MediaQuery.of(context).size.height * .20,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Logo & Profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/favicon.png'),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 4,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/avater_img.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Name
                  Text(
                    'Hello, ${authProvider.name ?? ''}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                  : ticketsProvider.tickets.isEmpty
                  ? const Center(child: Text("No tickets available"))
                  : ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: ticketsProvider.tickets.length,
                itemBuilder: (context, index) {
                  final ticket = ticketsProvider.tickets[index];

                  final subject = ticket.containsKey('subject') && ticket['subject'] != null
                      ? ticket['subject'].toString()
                      : 'No Title';
                  final department = ticket.containsKey('department') && ticket['department'] != null
                      ? ticket['department'].toString()
                      : 'No Department';
                  final status = ticket.containsKey('status') && ticket['status'] != null
                      ? ticket['status'].toString()
                      : 'No Status';

                  final ticketToken = ticket['token']?.toString() ?? ''; // Ensure ticketToken is a String
                  final ticketId = ticket['id']?.toString() ?? ''; // Ensure ticketId is a String

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailsScreen(
                            ticketToken: ticketToken,
                            ticketId: ticketId, // Pass the ticket Id
                          ),
                        ),
                      );
                    },
                    child: CustomListTile(
                      title: subject,
                      subtitle: department,
                      trailing: status,
                      titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TicketFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
