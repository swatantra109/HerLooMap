import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/location_provider.dart';
import '../../widgets/map_widget.dart';
import '../../widgets/toilet_info_card.dart';
import '../auth/login_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selectedToiletId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().initialize();
    });
  }

  void _onToiletTap(String toiletId) {
    setState(() {
      _selectedToiletId = toiletId;
    });
  }

  void _onCloseInfoCard() {
    setState(() {
      _selectedToiletId = null;
    });
  }

  Future<void> _onRefresh() async {
    await context.read<LocationProvider>().refresh();
  }

  Future<void> _onSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await context.read<AuthProvider>().signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          Consumer<LocationProvider>(
            builder: (context, locationProvider, child) {
              return MapWidget(
                latitude: locationProvider.latitude,
                longitude: locationProvider.longitude,
                toilets: locationProvider.toilets,
                isLoading: locationProvider.isLoading,
                error: locationProvider.error,
                onToiletTap: _onToiletTap,
                onRefresh: _onRefresh,
              );
            },
          ),
          
          // Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // App logo and title
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wc,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'HerLooMap',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // User menu
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: PopupMenuButton(
                              icon: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: Text(
                                  authProvider.user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: const Icon(Icons.person_outline),
                                    title: Text(authProvider.user?.name ?? 'User'),
                                    subtitle: Text(authProvider.user?.phoneNumber ?? ''),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  onTap: _onSignOut,
                                  child: const ListTile(
                                    leading: Icon(Icons.logout, color: Colors.red),
                                    title: Text('Sign Out', style: TextStyle(color: Colors.red)),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Floating action buttons
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                // Refresh button
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: _onRefresh,
                  heroTag: 'refresh',
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(height: 8),
                // Center on user location button
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    // This would center the map on user location
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Centered on your location'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  heroTag: 'center',
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
          
          // Legend
          Positioned(
            left: 16,
            bottom: 100,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Legend',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'You',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Toilets',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Toilet info card
          if (_selectedToiletId != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  final toilet = locationProvider.getToiletById(_selectedToiletId!);
                  if (toilet == null) return const SizedBox.shrink();
                  
                  return ToiletInfoCard(
                    toilet: toilet,
                    onClose: _onCloseInfoCard,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}