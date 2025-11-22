import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/app_bottom_nav.dart';
import 'simulator/simulator_screen.dart';
import 'info/who_can_donate_screen.dart';
import 'info/post_care_screen.dart';
import 'hemocenters/hemocenter_search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  late final pages = <Widget>[
    _HomeTab(
      onGoSimulator: () => setState(() => index = 1),
      onGoHemocenters: () => setState(() => index = 4),
    ),
    const SimulatorScreen(),
    const WhoCanDonateScreen(),
    const PostCareScreen(),
    const HemocenterSearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // mantém estado de cada aba
      body: IndexedStack(index: index, children: pages),

      // barra inferior customizada (igual ao protótipo)
      bottomNavigationBar: AppBottomNav(
        currentIndex: index,
        onChanged: (i) => setState(() => index = i),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final VoidCallback onGoSimulator;
  final VoidCallback onGoHemocenters;
  const _HomeTab({required this.onGoSimulator, required this.onGoHemocenters});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LOGO NO TOPO
            Image.asset('assets/img/logo2.png', height: 80, fit: BoxFit.contain),
              const SizedBox(height: 12),

          // CARD 1 - Simulador
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🩸 Doe Vida. Seja um Herói.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Este simulador foi criado para conscientizar a população sobre a importância da doação de sangue e verificar se uma pessoa está temporariamente ou permanentemente inapta para doar.',
                  style: TextStyle(height: 1.4),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Milhares de pessoas precisam de sangue todos os dias. Sua doação pode salvar até quatro vidas!',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                // Imagem doe.png
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/img/doe.png'),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: onGoSimulator, // troca para aba 1
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Simular',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // CARD 2 - Mapa de locais
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Encontre um Local para Doar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Descubra os hemocentros e postos de coleta mais próximos de você.',
                  style: TextStyle(height: 1.4),
                ),
                const SizedBox(height: 10),

                // Imagem map.png
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/img/map.png'),
                ),
                const SizedBox(height: 12),

                const SizedBox(height: 6),
                const Text(
                  'Encontre o local de doação mais próximo da sua casa e ajude a salvar vidas!',
                  style: TextStyle(height: 1.4),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: onGoHemocenters, // troca para aba 4
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Buscar Locais',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
