import 'dart:math' as math;

import 'package:downloadsfolder/downloadsfolder.dart' show getDownloadDirectory;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../components/components.dart';
import '../../core/core.dart';
import '../../router/router.dart';

part 'header_section/home_page_header.dart';
part 'header_section/intro.dart';
part 'header_section/cta.dart';

part 'about_me_section/about_me_section.dart';
part 'about_me_section/photos.dart';
part 'about_me_section/ticket.dart';

part 'skills_section/skills_section.dart';
part 'skills_section/skills.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ValueNotifier<bool>>(
          create: (_) => ValueNotifier(false),
        ),
      ],
      builder: (context, _) => Scaffold(
        body: ListView(
          children: [
            const HomePageHeader(),
            const SkillsSection(),
            const Gap(64.0),
            const AboutMeSection(),
            const Gap(64.0),
            const _Mesh().pad24H(),
            const Gap(24.0),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                DirectionButton(
                  onPressed: () {
                    const ProjectsPageRoute().go(context);
                  },
                  title: const Text('Work'),
                  subtitle: const Text('Selected Projects'),
                  direction: AxisDirection.right,
                ).expand(),
              ],
            ).readableWidth().center(),
          ],
        ),
      ),
    );
  }
}

class _Mesh extends StatelessWidget {
  const _Mesh();
  @override
  Widget build(BuildContext context) {
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
        .withHeight(320.0)
        .animate()
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
