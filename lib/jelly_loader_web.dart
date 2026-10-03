import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import 'main.dart' show WenhaApp;

int _jellyViewId = 0;

class JellyLoader extends StatelessWidget {
  const JellyLoader({
    super.key,
    this.color = WenhaApp.burgundy,
    this.size = 40,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final id = 'wenha-jelly-${_jellyViewId++}';
    ui_web.platformViewRegistry.registerViewFactory(id, (_) {
      final el = html.DivElement()
        ..style.width = '${size}px'
        ..style.height = '${size / 2}px'
        ..innerHtml = '''
<style>
.jelly {
 --uib-size: ${size}px;
 --uib-speed: .8s;
 --uib-color: ${_hex(color)};
 position: relative;
 height: calc(var(--uib-size) / 2);
 width: var(--uib-size);
 filter: url('#uib-jelly-ooze');
 animation: rotate72317 calc(var(--uib-speed) * 2) linear infinite;
}
.jelly::before,
.jelly::after {
 content: '';
 position: absolute;
 top: 0%;
 left: 25%;
 width: 50%;
 height: 100%;
 background: var(--uib-color);
 border-radius: 100%;
}
.jelly::before { animation: shift-left var(--uib-speed) ease infinite; }
.jelly::after { animation: shift-right var(--uib-speed) ease infinite; }
.jelly-maker { width: 0; height: 0; position: absolute; }
@keyframes rotate72317 {
 0%, 49.999%, 100% { transform: none; }
 50%, 99.999% { transform: rotate(90deg); }
}
@keyframes shift-left {
 0%,100% { transform: translateX(0%); }
 50% { transform: scale(0.65) translateX(-75%); }
}
@keyframes shift-right {
 0%,100% { transform: translateX(0%); }
 50% { transform: scale(0.65) translateX(75%); }
}
</style>
<div class="jelly"></div>
<svg width="0" height="0" class="jelly-maker">
  <defs>
    <filter id="uib-jelly-ooze">
      <feGaussianBlur in="SourceGraphic" stdDeviation="6.25" result="blur"></feGaussianBlur>
      <feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7" result="ooze"></feColorMatrix>
      <feBlend in="SourceGraphic" in2="ooze"></feBlend>
    </filter>
  </defs>
</svg>
''';
      return el;
    });
    return SizedBox(
      width: size,
      height: size / 2,
      child: HtmlElementView(viewType: id),
    );
  }

  String _hex(Color c) {
    final r = (c.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (c.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (c.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b';
  }
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
