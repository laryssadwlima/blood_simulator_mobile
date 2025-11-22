import 'package:flutter/material.dart';
import '../theme.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  const AppBottomNav({super.key, required this.currentIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      _NavItem('Início', 'assets/icons/home.png', Icons.home_rounded),
      _NavItem('Simulador', 'assets/icons/simulator.png', Icons.bloodtype_rounded),
      _NavItem('Quem pode doar', 'assets/icons/whocan.png', Icons.groups_rounded),
      _NavItem('Cuidados', 'assets/icons/care.png', Icons.volunteer_activism_rounded),
      _NavItem('Hemocentros', 'assets/icons/hemocenters.png', Icons.map_rounded),
    ];

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: kPrimary, // #BC2239
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final it = items[i];
            final selected = i == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onChanged(i),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _IconOrFallback(assetPath: it.asset, fallback: it.fallback),
                      const SizedBox(height: 6),
                      Text(
                        it.label.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String asset;
  final IconData fallback;
  _NavItem(this.label, this.asset, this.fallback);
}

class _IconOrFallback extends StatelessWidget {
  final String assetPath;
  final IconData fallback;
  const _IconOrFallback({required this.assetPath, required this.fallback});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      height: 26,
      color: Colors.white,
      errorBuilder: (_, __, ___) => Icon(fallback, color: Colors.white, size: 26),
    );
  }
}
