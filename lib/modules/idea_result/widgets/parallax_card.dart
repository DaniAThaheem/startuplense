import 'package:flutter/material.dart';

class ParallaxCard extends StatefulWidget {
  final Widget child;

  const ParallaxCard({super.key, required this.child});

  @override
  State<ParallaxCard> createState() => _ParallaxCardState();
}

class _ParallaxCardState extends State<ParallaxCard> {
  double _dx = 0;
  double _dy = 0;
  bool _isTouching = false;

  void _update(Offset localPosition, Size size) {
    final x = (localPosition.dx - size.width / 2) / (size.width / 2);
    final y = (localPosition.dy - size.height / 2) / (size.height / 2);

    setState(() {
      _dx = x.clamp(-1, 1);
      _dy = y.clamp(-1, 1);
    });
  }

  void _reset() {
    setState(() {
      _dx = 0;
      _dy = 0;
      _isTouching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanStart: (_) {
            setState(() => _isTouching = true);
          },
          onPanUpdate: (details) {
            _update(details.localPosition, constraints.biggest);
          },
          onPanEnd: (_) => _reset(),
          onPanCancel: _reset,

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,

            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002) // 🔥 PERSPECTIVE (KEY UPGRADE)
              ..rotateX(_dy * 0.45)   // 🔥 STRONGER TILT
              ..rotateY(-_dx * 0.45)
              ..scale(_isTouching ? 1.02 : 1.0), // 🔥 SUBTLE POP

            child: Stack(
              children: [

                // 🔥 CARD CONTENT
                widget.child,

                // 🔥 DYNAMIC LIGHT / GLARE
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: _isTouching ? 0.25 : 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment(-_dx, -_dy),
                            end: Alignment(_dx, _dy),
                            colors: const [
                              Colors.white,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
