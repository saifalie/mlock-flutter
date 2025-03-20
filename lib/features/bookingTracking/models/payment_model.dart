enum Currency { INR }

class PaymentModel {
  final String orderId;
  final String paymentId;
  final String signature;
  final double amount;
  final Currency currency;
  final String status;
  final String method;
  final String? cardId;
  final String? bank;
  final String? wallet;

  PaymentModel({
    required this.orderId,
    required this.paymentId,
    required this.signature,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    this.cardId,
    this.bank,
    this.wallet,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      orderId: json['orderId'] as String,
      paymentId: json['paymentId'] as String,
      signature: json['signature'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: Currency.values.firstWhere(
        (e) =>
            e.name.toUpperCase() == (json['currency'] as String).toUpperCase(),
        orElse: () => Currency.INR,
      ),
      status: json['status'] as String,
      method: json['method'] as String,
      cardId: json['cardId'] as String?,
      bank: json['bank'] as String?,
      wallet: json['wallet'] as String?,
    );
  }
}
