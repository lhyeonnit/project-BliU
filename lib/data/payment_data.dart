class PaymentData {
  final String customerKey;
  final String orderId;
  final int amount;
  final int taxFreeAmount;
  final String orderName;
  final String customerName;

  PaymentData({
    required this.customerKey,
    required this.orderId,
    required this.amount,
    required this.taxFreeAmount,
    required this.orderName,
    required this.customerName
  });

  PaymentData.fromJson(Map<String, dynamic> json):
        customerKey = json['customerKey'],
        orderId = json['orderId'],
        amount = json['amount'],
        taxFreeAmount = json['taxFreeAmount'],
        orderName = json['orderName'],
        customerName = json['customerName'];

  Map<String, dynamic> toJson() => {
    'customerKey' : customerKey,
    'orderId' : orderId,
    'amount' : amount,
    'taxFreeAmount' : taxFreeAmount,
    'orderName' : orderName,
    'customerName' : customerName,
  };
}