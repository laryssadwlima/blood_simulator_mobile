import 'package:flutter/material.dart';
import '../../theme.dart';

class WhoCanDonateScreen extends StatelessWidget {
  static const route = '/who-can-donate';
  const WhoCanDonateScreen({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _SectionTitle('Quem Pode Doar Sangue?'),
                    _Ok('Estar bem de saúde'),
                    _Ok('Ter entre 18 e 69 anos'),
                    _Ok('Jovens a partir de 16 anos podem doar com autorização do responsável legal'),
                    _Ok('Pesar mais de 50kg'),
                    _Ok('Ter dormido pelo menos 6 horas nas últimas 24h'),
                    _Ok('Não estar em jejum'),
                    _Ok('Apresentar documento oficial com foto'),

                    SizedBox(height: 16),
                    _SectionTitle('Quem Não Pode Doar Sangue'),
                    _No('Febre, gripe ou infecção nos últimos 7 dias'),
                    _No('Diabetes não controlada, cardiopatia ou hepatite após os 11 anos'),
                    _No('Grávidas ou mães amamentando crianças menores de 12 meses'),
                    _No('Após parto normal: aguardar 3 meses'),
                    _No('Após cesariana: aguardar 6 meses'),
                    _No('Ingestão de bebida alcoólica nas últimas 12 horas'),
                    _No('Homens: doação há menos de 60 dias'),
                    _No('Mulheres: doação há menos de 90 dias'),
                    _No('Cirurgia de grande porte há menos de 6 meses'),
                    _No('Cirurgia de pequeno porte há menos de 3 meses'),
                    _No('Tratamento dentário há menos de 7 dias'),
                    _No('Vacina contra gripe: aguardar 48h'),
                    _No('Vacinas com vírus vivos: aguardar 4 semanas'),
                    _No('Endoscopia ou colonoscopia nos últimos 6 meses'),
                    _No('Piercing, tatuagem ou acupuntura há menos de 12 meses'),
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: kPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
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

class _No extends StatelessWidget {
  final String text;
  const _No(this.text);

  @override
  Widget build(BuildContext context) {
    return _EmojiLine(emoji: '❌', text: text, color: Colors.red.shade700);
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
