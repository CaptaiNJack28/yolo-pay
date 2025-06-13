import 'dart:math';
import 'dart:ui'; // For ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:faker/faker.dart' as faker;
import 'package:google_fonts/google_fonts.dart';

import '../widgets/bottom_navigator.dart'; // Make sure this exists in your project

class YoloPayScreen extends StatefulWidget {
  const YoloPayScreen({Key? key}) : super(key: key);

  @override
  State<YoloPayScreen> createState() => _YoloPayScreenState();
}

class _YoloPayScreenState extends State<YoloPayScreen> {
  bool isFrozen = true;
  bool showCvv = false;
  late String cardNumber;
  late String expiry;
  late String cvv;
  int currentIndex = 1;
  int selectedMode = 1; // 0: pay, 1: card

  @override
  void initState() {
    super.initState();
    _generateCardDetails();
  }

  void _generateCardDetails() {
    final fake = faker.Faker();
    List<String> groups =
    List.generate(4, (_) => fake.randomGenerator.numbers(9, 4).join());
    cardNumber = groups.join(' ');
    expiry = "0${Random().nextInt(9) + 1}/2${Random().nextInt(3) + 5}";
    cvv = "${Random().nextInt(900) + 100}";
  }

  void _toggleFreeze() {
    setState(() => isFrozen = !isFrozen);
  }

  void _toggleCvvVisibility() {
    setState(() => showCvv = !showCvv);
  }

  void _copyCardDetails() {
    final allDetails = "Card Number: $cardNumber\nExpiry: $expiry\nCVV: $cvv";
    Clipboard.setData(ClipboardData(text: allDetails));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Card details copied")),
    );
  }

  void _onModeSelected(int index) {
    setState(() {
      selectedMode = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'select payment mode',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'choose your preferred payment method to make payment.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            _buildToggleButtons(),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 24.0, bottom: 10),
              child: Text(
                'YOUR DIGITAL DEBIT CARD',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 1.2,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildCardRow(screenWidth),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(child: _buildGradientButton('pay', 0)),
          const SizedBox(width: 10),
          Expanded(child: _buildGradientButton('card', 1)),
        ],
      ),
    );
  }

  Widget _buildGradientButton(String label, int index) {
    bool isSelected = selectedMode == index;

    final Gradient payGradient = const LinearGradient(
      colors: [Colors.grey, Colors.blueGrey],
    );
    final Gradient cardGradient = const LinearGradient(
      colors: [Colors.redAccent, Colors.red],
    );

    final Gradient gradient = index == 0 ? payGradient : cardGradient;

    return GestureDetector(
      onTap: () => _onModeSelected(index),
      child: Container(
        padding: const EdgeInsets.all(2), // Border thickness
        decoration: BoxDecoration(
          gradient: isSelected ? gradient : null,
          borderRadius: BorderRadius.circular(50),
          border: isSelected ? null : Border.all(color: Colors.grey.shade700, width: 1.5),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey.shade900,
            borderRadius: BorderRadius.circular(50),
          ),
          alignment: Alignment.center,
          child: ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade500,
              ),
            ),
            blendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }


  Widget _buildCardRow(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard(screenWidth),
          const SizedBox(width: 16),
          _buildFreezeButton(),
        ],
      ),
    );
  }

  Widget _buildFreezeButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleFreeze,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white10,
              border: Border.all(
                color: isFrozen ? Colors.redAccent : Colors.white24,
              ),
            ),
            child: Icon(
              Icons.ac_unit,
              color: isFrozen ? Colors.redAccent : Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isFrozen ? 'frozen' : 'freeze',
          style: TextStyle(
            color: isFrozen ? Colors.redAccent : Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(double screenWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            width: 200,
            height: 320,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'YOLO',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/images/yesbanklogo.png',
                        height: screenWidth * 0.06,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: cardNumber
                            .split(' ')
                            .map(
                              (group) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              group,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'expiry',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            expiry,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'cvv',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: _toggleCvvVisibility,
                                child: Icon(
                                  showCvv
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.redAccent,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                showCvv ? cvv : '••••',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _copyCardDetails,
                    child: Row(
                      children: [
                        const Icon(Icons.copy, size: 18, color: Colors.redAccent),
                        const SizedBox(width: 6),
                        Text(
                          "copy details",
                          style: GoogleFonts.poppins(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/rupaylogo.png',
                    height: screenWidth * 0.08,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),

          // Blur Overlay when card is frozen
          if (isFrozen)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
