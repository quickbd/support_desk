import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:support_desk/providers/auth_provider.dart';
import 'package:support_desk/providers/services_provider.dart'; // Import ServicesProvider
import '../../global_widgets/custom_home_item.dart';
import '../../global_widgets/custom_list_tile.dart';
import '../../utils/colors.dart';
import '../MyServices/service_details_screen.dart';
import '../activity/activity.dart';
import '../MyServices/my_services_screen.dart';
import '../MyInvoice/my_invoice_screen.dart';
import '../SupportTicket/support_ticket_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final servicesProvider = Provider.of<ServicesProvider>(context, listen: false);

    final isLoggedIn = await authProvider.checkLoginStatus();
    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      // Load user details and services
      await authProvider.loadUserDetails();
      await servicesProvider.fetchServices();
      setState(() {
        _isLoading = false; // Data is loaded, update the loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final servicesProvider = Provider.of<ServicesProvider>(context); // Use ServicesProvider
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: size.height * .20,
            width: size.width,
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
                    'Hello, ${authProvider.name ?? ''}', // Accessing name directly from AuthProvider
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: CustomHomeItem(
                            title: 'My\nServices',
                            icon: Icons.send,
                            onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MyServicesScreen()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: CustomHomeItem(
                            title: 'My\nInvoice',
                            icon: Icons.wallet,
                            backgroundColor: Colors.white,
                            itemColor: AppColors.primary,
                            onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MyInvoiceScreen()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: CustomHomeItem(
                            title: 'Support\nTicket',
                            icon: Icons.support_agent,
                            backgroundColor: Colors.white,
                            itemColor: AppColors.primary,
                            onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SupportTicketScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    // Activities
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Get.to(() => const ActivityView()),
                          child: const Text('Activity'),
                        ),
                        InkWell(
                          onTap: () => Get.to(() => const ActivityView()),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    // Services
                    _isLoading
                        ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                        : servicesProvider.activities.isEmpty
                        ? const Center(child: Text("No Service available"))
                        : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: servicesProvider.activities.length,
                      itemBuilder: (context, index) {
                        final service = servicesProvider.activities[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceDetailsScreen(
                                  title: service['title'] ?? 'No Title',
                                  subtitle: service['subtitle'] ?? 'No Subtitle',
                                  trailing: service['trailing'] ?? 'No Trailing',
                                ),
                              ),
                            );
                          },
                          child: CustomListTile(
                            title: service['title'] ?? 'No Title',
                            subtitle: service['subtitle'] ?? 'No Subtitle',
                            trailing: service['trailing'] ?? 'No Trailing',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
