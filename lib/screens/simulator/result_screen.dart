import 'package:flutter/material.dart';
import '../../models/eligibility.dart';
import '../../theme.dart';

class ResultScreen extends StatelessWidget {
  final EligibilityResult result;
  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                Image.asset(
                  'assets/img/logo2.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),

                // Ícone principal
                Icon(
                  result.eligible ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: result.eligible ? Colors.green : Colors.red,
                  size: 96,
                ),
                const SizedBox(height: 20),

                // Título
                Text(
                  result.eligible
                      ? 'Você está apto(a) para doar sangue! 🎉'
                      : 'Você NÃO está apto(a) para doar sangue no momento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: result.eligible ? Colors.green.shade700 : kPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                // Mensagem de orientação
                Text(
                  result.eligible
                      ? 'Parabéns! Procure um hemocentro mais próximo para realizar a doação e salvar vidas. ❤️'
                      : 'Confira abaixo os motivos da inaptidão e procure um hemocentro para mais orientações.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 24),

                // Motivos de inaptidão
                if (!result.eligible && result.reasons.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Motivos:',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...result.reasons.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('❌ ',
                                    style: TextStyle(fontSize: 16, color: Colors.red)),
                                Expanded(
                                  child: Text(
                                    r,
                                    style: const TextStyle(fontSize: 15, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

                // Botão Voltar
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
