import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:local_hero/local_hero.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../core/core.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LocalHeroScope(
      curve: PEffects.playfulCurve,
      duration: PEffects.shortDuration,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ValueNotifier<bool>>(
            create: (_) => ValueNotifier(false),
          ),
        ],
        builder: (context, _) => Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(
                  color: theme.resolveColor(
                    PColors.offWhite,
                    const Color(0xff222222),
                  ),
                ),
              ),
              const _Mesh().center(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Mesh extends StatelessWidget {
  const _Mesh();
  @override
  Widget build(BuildContext context) {
    if (context.watch<ValueNotifier<bool>>().value) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return ClipPath(
      clipper: const ShapeBorderClipper(shape: PDecors.border16),
      child: AnimatedMeshGradient(
        colors: PColors.basicColors
            .map((color) => theme.resolveColor(color.tint50, color.shade30))
            .toList(),
        options: AnimatedMeshGradientOptions(
          speed: 1,
          frequency: 2,
          grain: 0.1,
        ),
        child: const SizedBox.expand(),
      ),
    )
        .withSize(160.0, 80.0)
        .animate(
          onComplete: (_) => context.read<ValueNotifier<bool>>().value = true,
        )
        .fadeIn(duration: PEffects.shortDuration)
        .scaleXY(
          delay: PEffects.veryShortDuration,
          duration: PEffects.mediumDuration,
          curve: Curves.easeInOut,
          begin: 0.0,
          end: 1.0,
        )
        .saturate(
          delay: PEffects.mediumDuration,
          duration: PEffects.mediumDuration,
        );
  }
}
