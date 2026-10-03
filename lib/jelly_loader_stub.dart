import 'package:flutter/material.dart';

import 'main.dart' show WenhaApp;

class JellyLoader extends StatefulWidget {
  const JellyLoader({
    super.key,
    this.color = WenhaApp.burgundy,
    this.size = 40,
  });

  final Color color;
  final double size;

  @override
  State<JellyLoader> createState() => _JellyLoaderState();
}

class _JellyLoaderState extends State<JellyLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size / 2,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final p = controller.value;
          final t = p < .5 ? p * 2 : (1 - p) * 2;
          final offset = widget.size * .375 * t;
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: Offset(-offset, 0),
                child: Transform.scale(scale: .65 + .35 * (1 - t), child: _blob()),
              ),
              Transform.translate(
                offset: Offset(offset, 0),
                child: Transform.scale(scale: .65 + .35 * (1 - t), child: _blob()),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _blob() => Container(
        width: widget.size * .5,
        height: widget.size / 2,
        decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(999)),
      );
}

class WenhaNetworkLoader extends StatelessWidget {
  const WenhaNetworkLoader({
    super.key,
    this.message = 'عم نحاول نتصل...',
    this.color = WenhaApp.burgundy,
  });

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              JellyLoader(color: color),
              const SizedBox(height: 14),
              Text(
                message,
                style: const TextStyle(
                  color: WenhaApp.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
}
