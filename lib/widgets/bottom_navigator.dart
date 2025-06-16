import 'package:flutter/material.dart';

class BottomNavigator extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigator({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 100, // Increase total height slightly
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background curve
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: Size(width, 100),
              painter: CurveFillPainter(),
            ),
          ),

          // Navigation items slightly lifted from bottom
          Positioned(
            bottom: 9, // <-- Key change: lift nav items above curve line
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.home_outlined, "home", 0),
                _navItem(Icons.qr_code, "yolo pay", 1),
                _navItem(Icons.settings_outlined, "ginie", 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    final color = isSelected ? Colors.white : Colors.grey[600];
    final borderColor = isSelected ? Colors.white : Colors.white24;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(
                color: borderColor!,
                width: 2,
              ),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class CurveFillPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    // Start slightly lower on the sides, higher peak in center
    path.moveTo(0, size.height * 0.4);

    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.005,   // first control point
      size.width * 0.5, size.height * 0.02,    // peak
    );

    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.005,   // second control point
      size.width, size.height * 0.4,           // end of curve
    );

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.grey.shade600,
          Colors.white,
          Colors.grey.shade600,
        ],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(path, borderPaint);



}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

