import 'package:flutter/material.dart';
import '../../theme.dart';

class PostCareScreen extends StatelessWidget {
  static const route = '/post-care';
  const PostCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LOGO
              Image.asset('assets/img/logo2.png', height: 80, fit: BoxFit.contain),
              const SizedBox(height: 12),

              // CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: const [
                    Text(
                      'Cuidados Pós-Doação',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Após doar sangue, é importante seguir algumas recomendações para garantir sua saúde e bem-estar:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 14),

                    // Lista de cuidados (✅)
                    _Ok('Permaneça no local por 15 minutos após a doação'),
                    _Ok('Não dobre o braço por 10 minutos'),
                    _Ok('Mantenha o curativo por 5 horas'),
                    _Ok('Em caso de sangramento, pressione por 2–5 minutos'),
                    _Ok('Para hematoma: gelo nas primeiras 24h, compressa morna depois'),
                    _Ok('Aumente a ingestão de líquidos nas 24h seguintes'),
                    _Ok('Evite esforços físicos por 12h'),
                    _Ok('Conduza veículos apenas se estiver bem'),
                    _Ok('Aguarde 1 hora para fumar'),
                    _Ok('Evite bebidas alcoólicas no mesmo dia'),

                    SizedBox(height: 20),
                    Text(
                      'Em caso de mal-estar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),

                    _Bullet('Sente-se ou deite-se com as pernas elevadas'),
                    _Bullet('Respire profundamente'),
                    _Bullet('Peça ajuda, se necessário'),
                    _Bullet('Entre em contato com o hemocentro onde foi feita a doação'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Ok extends StatelessWidget {
  final String text;
  const _Ok(this.text);

  @override
  Widget build(BuildContext context) {
    return _EmojiLine(emoji: '✅', text: text, color: Colors.green.shade700);
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return _EmojiLine(emoji: '•', text: text, color: Colors.black87);
  }
}

class _EmojiLine extends StatelessWidget {
  final String emoji;
  final String text;
  final Color color;
  const _EmojiLine({required this.emoji, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 18, color: color)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
