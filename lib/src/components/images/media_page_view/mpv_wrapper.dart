part of 'media_page_view.dart';

class _MPVWrapper extends StatelessWidget {
  const _MPVWrapper({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Padding(
          padding: EdgeInsetsDirectional.only(
            top: 4.0,
            start: 22.0,
          ),
          child: MaybeBackButton.elevated(),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: child,
      bottomNavigationBar: const SafeArea(child: _MPVSwitcher()),
    );
  }
}
