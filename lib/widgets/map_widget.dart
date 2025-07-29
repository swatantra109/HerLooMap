import 'package:flutter/material.dart';
import '../models/toilet.dart';

class MapWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final List<Toilet> toilets;
  final bool isLoading;
  final String? error;
  final Function(String) onToiletTap;
  final VoidCallback onRefresh;

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.toilets,
    required this.isLoading,
    required this.error,
    required this.onToiletTap,
    required this.onRefresh,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const double _mapCenterLat = 51.5074; // London center
  static const double _mapCenterLng = -0.1278;
  static const double _zoomLevel = 12.0;

  // Convert lat/lng to screen coordinates (simplified)
  Offset _latLngToOffset(double lat, double lng, Size mapSize) {
    // Simplified conversion for demo purposes
    final double latRange = 0.1; // Degrees
    final double lngRange = 0.15; // Degrees
    
    final double normalizedLat = (lat - (_mapCenterLat - latRange / 2)) / latRange;
    final double normalizedLng = (lng - (_mapCenterLng - lngRange / 2)) / lngRange;
    
    return Offset(
      normalizedLng * mapSize.width,
      (1 - normalizedLat) * mapSize.height, // Invert Y axis
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        color: Colors.grey[100],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading map...'),
            ],
          ),
        ),
      );
    }

    if (widget.error != null) {
      return Container(
        color: Colors.grey[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                widget.error!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.onRefresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green[100]!,
            Colors.blue[50]!,
            Colors.grey[100]!,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mapSize = Size(constraints.maxWidth, constraints.maxHeight);
          
          return Stack(
            children: [
              // Background map pattern
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                ),
                child: CustomPaint(
                  painter: MapPatternPainter(),
                ),
              ),
              
              // User location marker
              if (widget.latitude != null && widget.longitude != null)
                Positioned.fromRect(
                  rect: Rect.fromCenter(
                    center: _latLngToOffset(widget.latitude!, widget.longitude!, mapSize),
                    width: 40,
                    height: 40,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              
              // Toilet markers
              ...widget.toilets.map((toilet) {
                final position = _latLngToOffset(toilet.latitude, toilet.longitude, mapSize);
                
                return Positioned.fromRect(
                  rect: Rect.fromCenter(
                    center: position,
                    width: 40,
                    height: 40,
                  ),
                  child: GestureDetector(
                    onTap: () => widget.onToiletTap(toilet.id),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.wc,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                );
              }).toList(),
              
              // Street labels (simplified)
              Positioned(
                top: mapSize.height * 0.3,
                left: mapSize.width * 0.2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Hyde Park',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              Positioned(
                top: mapSize.height * 0.6,
                left: mapSize.width * 0.4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Thames',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              Positioned(
                top: mapSize.height * 0.1,
                right: mapSize.width * 0.2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'King\'s Cross',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw grid pattern
    for (int i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (int i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Draw some "roads"
    final roadPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 3;

    // Horizontal roads
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );
    
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      roadPaint,
    );

    // Vertical roads
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      roadPaint,
    );
    
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      roadPaint,
    );

    // Draw "river" (Thames)
    final riverPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 20;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.5,
      size.width * 0.6, size.height * 0.65,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.75,
      size.width, size.height * 0.7,
    );

    canvas.drawPath(path, riverPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}