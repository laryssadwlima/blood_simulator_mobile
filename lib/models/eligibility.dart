class EligibilityInput {
  final int age;
  final double weight;
  final String gender;
  final bool pregnantOrBreastfeeding;
  final bool sickLast7Days;
  final bool tattooLast12Months;
  final bool surgeryLast6Months;
  final bool vaccineLast30Days;
  final bool alcoholLast12Hours;
  final bool sleptLessThan6h;
  final bool alreadyDonatedLast60DaysForMen90DaysForWomen;

  EligibilityInput({
    required this.age,
    required this.weight,
    required this.gender,
    required this.pregnantOrBreastfeeding,
    required this.sickLast7Days,
    required this.tattooLast12Months,
    required this.surgeryLast6Months,
    required this.vaccineLast30Days,
    required this.alcoholLast12Hours,
    required this.sleptLessThan6h,
    required this.alreadyDonatedLast60DaysForMen90DaysForWomen,
  });
}

class EligibilityResult {
  final bool eligible;
  final List<String> reasons;
  EligibilityResult({required this.eligible, required this.reasons});
}

class EligibilityEngine {
  static EligibilityResult evaluate(EligibilityInput i) {
    final reasons = <String>[];

    if (i.age < 18 || i.age > 69) reasons.add('Idade fora da faixa (18 a 69 anos).');
    if (i.weight < 50) reasons.add('Peso abaixo de 50 kg.');
    if (i.pregnantOrBreastfeeding) reasons.add('Gestantes ou lactantes não podem doar.');
    if (i.sickLast7Days) reasons.add('Doenças/infecções nos últimos 7 dias.');
    if (i.tattooLast12Months) reasons.add('Tatuagem nos últimos 12 meses.');
    if (i.surgeryLast6Months) reasons.add('Cirurgia recente (≤ 6 meses).');
    if (i.vaccineLast30Days) reasons.add('Vacinação nos últimos 30 dias.');
    if (i.alcoholLast12Hours) reasons.add('Ingestão de álcool nas últimas 12 horas.');
    if (i.sleptLessThan6h) reasons.add('Dormiu menos de 6 horas nas últimas 24 horas.');
    if (i.alreadyDonatedLast60DaysForMen90DaysForWomen) reasons.add('Intervalo mínimo entre doações não respeitado.');

    return EligibilityResult(eligible: reasons.isEmpty, reasons: reasons);
  }
}
