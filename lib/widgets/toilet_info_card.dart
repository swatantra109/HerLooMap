import 'package:flutter/material.dart';
import '../models/toilet.dart';

class ToiletInfoCard extends StatelessWidget {
  final Toilet toilet;
  final VoidCallback onClose;

  const ToiletInfoCard({
    super.key,
    required this.toilet,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              splashRadius: 20,
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                toilet.name,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                toilet.address,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                toilet.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Review count and hours
                    Row(
                      children: [
                        Text(
                          '${toilet.reviewCount} reviews',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          toilet.hours,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Amenities
                    Text(
                      'Amenities',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: toilet.amenities.map((amenity) {
                        IconData icon;
                        Color color;
                        
                        switch (amenity.toLowerCase()) {
                          case 'free':
                            icon = Icons.money_off;
                            color = Colors.green;
                            break;
                          case 'accessible':
                            icon = Icons.accessible;
                            color = Colors.blue;
                            break;
                          case 'baby changing':
                            icon = Icons.baby_changing_station;
                            color = Colors.purple;
                            break;
                          case 'hand dryer':
                            icon = Icons.air;
                            color = Colors.orange;
                            break;
                          case 'hand sanitizer':
                            icon = Icons.sanitizer;
                            color = Colors.red;
                            break;
                          case 'shower facilities':
                            icon = Icons.shower;
                            color = Colors.cyan;
                            break;
                          case 'open 24/7':
                            icon = Icons.schedule;
                            color = Colors.indigo;
                            break;
                          case 'art gallery':
                            icon = Icons.palette;
                            color = Colors.pink;
                            break;
                          default:
                            icon = Icons.check_circle;
                            color = Colors.grey;
                        }
                        
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: color.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 16,
                                color: color,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                amenity,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    
                    if (toilet.description != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        toilet.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 20),
                    
                    // Status indicators
                    Row(
                      children: [
                        _buildStatusChip(
                          label: toilet.isFree ? 'Free' : 'Paid',
                          color: toilet.isFree ? Colors.green : Colors.orange,
                          icon: toilet.isFree ? Icons.money_off : Icons.attach_money,
                        ),
                        const SizedBox(width: 8),
                        _buildStatusChip(
                          label: toilet.isAccessible ? 'Accessible' : 'Not Accessible',
                          color: toilet.isAccessible ? Colors.blue : Colors.grey,
                          icon: Icons.accessible,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Directions feature coming soon!'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.directions),
                            label: const Text('Directions'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('More info feature coming soon!'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.info_outline),
                            label: const Text('More Info'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}