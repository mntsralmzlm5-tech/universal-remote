import 'package:flutter/material.dart';

void main() => runApp(const TestApp());

class TestApp extends StatelessWidget {
  const TestApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Universal Remote',
      theme: ThemeData(useMaterial3: true),
      home: const FancySplash(),
    );
  }
}

class FancySplash extends StatefulWidget {
  const FancySplash({super.key});
  @override
  State<FancySplash> createState() => _FancySplashState();
}

class _FancySplashState extends State<FancySplash>
    with TickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _btnCtrl;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);
    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    Future.delayed(const Duration(milliseconds: 600),
        () => _textCtrl.forward());
    Future.delayed(const Duration(milliseconds: 1200),
        () => _btnCtrl.forward());
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (context, _) {
          final t = _bgCtrl.value;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(const Color(0xFF0F0C29),
                      const Color(0xFF16213E), t)!,
                  Color.lerp(const Color(0xFF5B4BFF),
                      const Color(0xFF00D4B8), t)!,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: CurvedAnimation(
                            parent: _logoCtrl, curve: Curves.elasticOut),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.white, Color(0xFFE0E0FF)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.settings_remote,
                              size: 75, color: Color(0xFF5B4BFF)),
                        ),
                      ),
                      const SizedBox(height: 45),
                      FadeTransition(
                        opacity: _textCtrl,
                        child: SlideTransition(
                          position: Tween(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: _textCtrl,
                                  curve: Curves.easeOutCubic)),
                          child: Column(
                            children: const [
                              Text(
                                'أهلاً وسهلاً',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  letterSpacing: 3,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'منتصر',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 58,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'تطبيق التحكم الموحد',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 55),
                      FadeTransition(
                        opacity: _btnCtrl,
                        child: SlideTransition(
                          position: Tween(
                                  begin: const Offset(0, 0.5),
                                  end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: _btnCtrl,
                                  curve: Curves.easeOutCubic)),
                          child: Column(
                            children: [
                              _GlowButton(
                                icon: Icons.play_arrow_rounded,
                                label: 'ابدأ الآن',
                                onTap: () =>
                                    _showSnack(context, '🚀 يا هلا منتصر!'),
                              ),
                              const SizedBox(height: 14),
                              _GlowButton(
                                icon: Icons.tune,
                                label: 'الإعدادات',
                                ghost: true,
                                onTap: () =>
                                    _showSnack(context, '⚙️ الإعدادات'),
                              ),
                              const SizedBox(height: 14),
                              _GlowButton(
                                icon: Icons.info_outline,
                                label: 'عن التطبيق',
                                ghost: true,
                                onTap: () =>
                                    _showSnack(context, 'ℹ️ الإصدار 1.0.0'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      FadeTransition(
                        opacity: _btnCtrl,
                        child: const Text(
                          'الإصدار 1.0.0 — نسخة اختبار',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSnack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF5B4BFF),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _GlowButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool ghost;
  const _GlowButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.ghost = false,
  });

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 270,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: widget.ghost
                ? Colors.white.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: widget.ghost
                ? Border.all(color: Colors.white30)
                : null,
            boxShadow: widget.ghost
                ? null
                : [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.35),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon,
                  color: widget.ghost
                      ? Colors.white
                      : const Color(0xFF5B4BFF),
                  size: 22),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.ghost
                      ? Colors.white
                      : const Color(0xFF5B4BFF),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
