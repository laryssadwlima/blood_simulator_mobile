import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../models/eligibility.dart';
import 'result_screen.dart';

class SimulatorScreen extends StatefulWidget {
  static const route = '/simulator';
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final ageCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  String? gender; // 'M' | 'F' | 'O'
  bool? sickLast7Days; // “Você está doente ou teve febre/gripe nos últimos 7 dias?”
  bool? pregnantOrBreastfeeding; // “Você está grávida ou amamentando?”
  bool? tattooPiercingAcupuncture12m; // “Fez tatuagem/piercing/acupuntura nos últimos 12 meses?”
  bool? surgeryLast6m; // “Teve cirurgia nos últimos 6 meses?”
  bool? vaccineLast30d; // “Tomou alguma vacina nos últimos 30 dias?”
  bool? alcoholLast12h; // “Ingeriu bebida alcoólica nas últimas 12 horas?”
  bool? sleptAtLeast6h; // “Dormiu pelo menos 6 horas nas últimas 24 horas?”
  bool? donatedRecently; // “Você já doou sangue?” (assumiremos doação recente: ≤60d H / ≤90d M)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO NO TOPO
              Center(
                child: Image.asset(
                  'assets/img/logo2.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Simulador de Doação de Sangue',
                        style: TextStyle(
                          color: Color(0xFFBC2239),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Veja se você está apto para doar sangue!',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      _label('Idade:'),
                      TextFormField(
                        controller: ageCtrl,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe sua idade' : null,
                      ),
                      const SizedBox(height: 12),

                      _label('Peso (kg):'),
                      TextFormField(
                        controller: weightCtrl,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe seu peso' : null,
                      ),
                      const SizedBox(height: 12),

                      _label('Gênero:'),
                      DropdownButtonFormField<String>(
                        value: gender,
                        items: const [
                          DropdownMenuItem(value: 'M', child: Text('Masculino')),
                          DropdownMenuItem(value: 'F', child: Text('Feminino')),
                          DropdownMenuItem(value: 'O', child: Text('Outro')),
                        ],
                        decoration: _selectDecoration(),
                        hint: const Text('Selecione'),
                        validator: (v) => v == null ? 'Selecione o gênero' : null,
                        onChanged: (v) => setState(() => gender = v),
                      ),
                      const SizedBox(height: 12),

                      _yesNo(
                        'Você está doente ou teve febre/gripe nos últimos 7 dias?',
                        sickLast7Days,
                        (v) => setState(() => sickLast7Days = v),
                      ),
                      _yesNo(
                        'Você está grávida ou amamentando?',
                        pregnantOrBreastfeeding,
                        (v) => setState(() => pregnantOrBreastfeeding = v),
                      ),
                      _yesNo(
                        'Fez tatuagem, piercing ou acupuntura nos últimos 12 meses?',
                        tattooPiercingAcupuncture12m,
                        (v) => setState(() => tattooPiercingAcupuncture12m = v),
                      ),
                      _yesNo(
                        'Teve cirurgia nos últimos 6 meses?',
                        surgeryLast6m,
                        (v) => setState(() => surgeryLast6m = v),
                      ),
                      _yesNo(
                        'Tomou alguma vacina nos últimos 30 dias?',
                        vaccineLast30d,
                        (v) => setState(() => vaccineLast30d = v),
                      ),
                      _yesNo(
                        'Ingeriu bebida alcoólica nas últimas 12 horas?',
                        alcoholLast12h,
                        (v) => setState(() => alcoholLast12h = v),
                      ),
                      _yesNo(
                        'Dormiu pelo menos 6 horas nas últimas 24 horas?',
                        sleptAtLeast6h,
                        (v) => setState(() => sleptAtLeast6h = v),
                      ),
                      _yesNo(
                        'Você já doou sangue?',
                        donatedRecently,
                        (v) => setState(() => donatedRecently = v),
                      ),

                      const SizedBox(height: 18),
                      PrimaryButton(
                        label: 'Ver Resultado',
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // valida seleção de todos os “Selecione”
    final selects = [
      sickLast7Days,
      pregnantOrBreastfeeding,
      tattooPiercingAcupuncture12m,
      surgeryLast6m,
      vaccineLast30d,
      alcoholLast12h,
      sleptAtLeast6h,
      donatedRecently,
    ];
    if (selects.any((v) => v == null) || gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todas as seleções.')),
      );
      return;
    }

    final model = EligibilityInput(
      age: int.parse(ageCtrl.text),
      weight: double.parse(weightCtrl.text.replaceAll(',', '.')),
      gender: gender!, // 'M' | 'F' | 'O'
      pregnantOrBreastfeeding: pregnantOrBreastfeeding!,
      sickLast7Days: sickLast7Days!,
      tattooLast12Months: tattooPiercingAcupuncture12m!,
      surgeryLast6Months: surgeryLast6m!,
      vaccineLast30Days: vaccineLast30d!,
      alcoholLast12Hours: alcoholLast12h!,
      // pergunta é “Dormiu pelo menos 6h?” -> engine espera “dormiu menos de 6h”
      sleptLessThan6h: !(sleptAtLeast6h!),
      // pergunta é “Você já doou sangue?” -> consideramos “doou recentemente”
      alreadyDonatedLast60DaysForMen90DaysForWomen: donatedRecently!,
    );

    final res = EligibilityEngine.evaluate(model);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResultScreen(result: res)),
    );
  }

  // Widgets auxiliares
  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        ),
      );

  InputDecoration _selectDecoration() => InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );

  Widget _yesNo(String label, bool? value, ValueChanged<bool?> onChanged,
      {String? helper}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          DropdownButtonFormField<bool>(
            value: value,
            hint: const Text('Selecione'),
            decoration: _selectDecoration(),
            validator: (v) => v == null ? 'Selecione uma opção' : null,
            items: const [
              DropdownMenuItem(value: true, child: Text('Sim')),
              DropdownMenuItem(value: false, child: Text('Não')),
            ],
            onChanged: onChanged,
          ),
          if (helper != null) ...[
            const SizedBox(height: 6),
            Text(helper,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ],
      ),
    );
  }
}
