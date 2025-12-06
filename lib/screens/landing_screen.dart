import 'dart:ui'; // Needed for ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FeatureCardData {
  final IconData icon;
  final String title;
  final String description;
  FeatureCardData(this.icon, this.title, this.description);
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleScale;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;

  // cards list for landing
  final List<FeatureCardData> features = [
    FeatureCardData(
      LucideIcons.shuffle,
      "True Random",
      "Fisher-Yates algorithm for genuine shuffle",
    ),
    FeatureCardData(
      LucideIcons.music,
      "Queue Control",
      "Manage your playback queue directly",
    ),
    FeatureCardData(
      LucideIcons.sparkles,
      "Smart Features",
      "Enhanced controls for Spotify",
    ),
  ];

  // animation controllers stuff
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _circleScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
          ),
        );

    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
      ),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.99), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // green and purple blobs in the background
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 1200,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x993333FF),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 1200,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x9933FF33),
              ),
            ),
          ),

          //stack a blur over the blobs
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
            child: Container(color: const Color.fromARGB(40, 65, 61, 61)),
          ),

          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 200),

                  //shuffle icon
                  ScaleTransition(
                    scale: _circleScale,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC084FC), Color(0xFF4ADE80)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow:
                            // glow
                            [
                              BoxShadow(
                                color: const Color(0x80C084FC),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.shuffle,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  //title text
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors:
                              //need to experiment to see if gradient title is overkill
                              [
                                Color(0xFFFFFFFF),
                                Color(0xFFE9D5FF),
                                Color(0xFFD1FAE5),
                              ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: const Text(
                          'True Shuffle',
                          style: TextStyle(
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  //description under title
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFFE9D5FF),
                              Color(0xFFD1FAE5),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: const Text(
                            'Take control of your Spotify experience with genuine randomization and advanced playback features',
                            style: TextStyle(
                              fontFamily: 'SegoeUI',
                              fontWeight: FontWeight.w100,
                              fontSize: 14,
                              color: Color(0x99FFFFFF),
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  // cards
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: GridView.builder(
                        shrinkWrap: true, //only occupy space it needs
                        physics:
                            NeverScrollableScrollPhysics(), //doesnt scroll independently
                        itemCount: features.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.1,
                            ),
                        itemBuilder: (context, index) {
                          //loops to itemCount

                          final double start = index * 0.1; //0.0, 0.1, 0.2
                          final double end =
                              start + 0.3; //cards should go up in 0.3, 0.4, 0.5

                          final fade = Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                0.45 + start,
                                0.45 + end,
                                curve: Curves.easeIn,
                              ),
                            ),
                          );

                          final slide =
                              Tween<Offset>(
                                begin: const Offset(0, 0.2),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: Interval(
                                    0.45 + start,
                                    0.45 + end,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              );

                          return FadeTransition(
                            opacity: fade,
                            child: SlideTransition(
                              position: slide,
                              child: FeatureCard(
                                icon: features[index].icon,
                                title: features[index].title,
                                description: features[index].description,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  //connect button
                  SlideTransition(
                    position: _buttonSlide,
                    child: FadeTransition(
                      opacity: _buttonFade,
                      child: SizedBox(
                        width: 220,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/auth-callback');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFC084FC), Color(0xFF4ADE80)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFC084FC,
                                  ).withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Connect to Spotify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//card widget
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //gradient background
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0x55C084FC), Color(0x554ADE80)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'SegoeUI',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontFamily: 'SegoeUI',
              fontWeight: FontWeight.w100,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
