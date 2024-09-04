class PaymentData {
  final String clientKey;
  final String secretKey;
  final String customerKey;
  final String orderId;
  final int amount;
  final int taxFreeAmount;
  final String orderName;
  final String customerName;
  final String successUrl;
  final String failUrl;

  PaymentData({
    required this.clientKey,
    required this.secretKey,
    required this.customerKey,
    required this.orderId,
    required this.amount,
    required this.taxFreeAmount,
    required this.orderName,
    required this.customerName,
    required this.successUrl,
    required this.failUrl,
  });

  PaymentData.fromJson(Map<String, dynamic> json):
        clientKey = json['clientKey'],
        secretKey = json['secretKey'],
        customerKey = json['customerKey'],
        orderId = json['orderId'],
        amount = json['amount'],
        taxFreeAmount = json['taxFreeAmount'],
        orderName = json['orderName'],
        customerName = json['customerName'],
        successUrl = json['successUrl'],
        failUrl = json['failUrl'];

  Map<String, dynamic> toJson() => {
    'clientKey' : clientKey,
    'secretKey' : secretKey,
    'customerKey' : customerKey,
    'orderId' : orderId,
    'amount' : amount,
    'taxFreeAmount' : taxFreeAmount,
    'orderName' : orderName,
    'customerName' : customerName,
    'successUrl' : successUrl,
    'failUrl' : failUrl
  };
}