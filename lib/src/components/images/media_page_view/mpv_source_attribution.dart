part of 'media_page_view.dart';

class SourceAttribution extends StatefulWidget {
  const SourceAttribution({
    required this.sourceUrl,
    super.key,
  });

  final String sourceUrl;

  @override
  State<SourceAttribution> createState() => _SourceAttributionState();
}

class _SourceAttributionState extends State<SourceAttribution> {
  late Uri _sourceUrl = Uri.parse(widget.sourceUrl);

  @override
  void didUpdateWidget(SourceAttribution oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sourceUrl != widget.sourceUrl) {
      setState(() {
        _sourceUrl = Uri.parse(widget.sourceUrl);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CButton(
      tooltip: 'Open source image',
      onTap: () => launchUrlString(widget.sourceUrl),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: theme.gray,
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceIn,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.link,
                size: 16,
              ),
              const Gap(4.0),
              Text(
                _sourceUrl.authority,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
