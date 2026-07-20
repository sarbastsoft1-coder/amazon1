class PaymentMethod {
  final int? id;
  final String type;
  final String lastFour;
  final bool isDefault;

  PaymentMethod({this.id, required this.type, required this.lastFour, this.isDefault = false});
}
