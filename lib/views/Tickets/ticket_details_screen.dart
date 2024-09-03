import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:support_desk/providers/tickets_provider.dart';
import '../SupportTicket/ticket_reply_form.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String ticketToken;
  final String ticketId;

  const TicketDetailsScreen({Key? key, required this.ticketToken, required this.ticketId}) : super(key: key);

  @override
  TicketDetailsScreenState createState() => TicketDetailsScreenState();
}

class TicketDetailsScreenState extends State<TicketDetailsScreen> {
  late Future<List<Map<String, dynamic>>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = Provider.of<TicketsProvider>(context, listen: false)
        .fetchTicketMessages(widget.ticketToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket# ${widget.ticketId}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: Provider.of<TicketsProvider>(context, listen: false)
                .fetchTicketDetails(widget.ticketToken),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                final ticket = snapshot.data!;
                final title = (ticket['subject'] ?? 'No Title').toString();
                final subtitle = (ticket['department'] ?? 'No Department').toString();
                final trailing = (ticket['status'] ?? 'No Status').toString();

                return SizedBox(
                  width: double.infinity,
                  child: Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          trailing,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages available'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final dateTime = message['dateTime'];
                      final author = message['author'];
                      final content = message['message'];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0), // Optional margin
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0), // Border radius of 8
                          color: Colors.white, // Optional background color
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Optional shadow
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(content, textAlign: TextAlign.left),
                          subtitle: Text('By $author \n$dateTime', textAlign: TextAlign.left),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketReplyFormScreen(ticketId: widget.ticketId),
            ),
          );
        },
        child: const Icon(Icons.reply),
      ),
    );
  }
}
