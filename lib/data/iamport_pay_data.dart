class IamportPayData {
  final String payMethod;
  final String name;
  final String merchantUid;
  final int amount;
  final String? buyerName;
  final String? buyerTel;
  final String? buyerEmail;
  final String? buyerAddr;
  final String? buyerPostcode;

  IamportPayData({
    required this.payMethod,
    required this.name,
    required this.merchantUid,
    required this.amount,
    required this.buyerName,
    required this.buyerTel,
    required this.buyerEmail,
    required this.buyerAddr,
    required this.buyerPostcode
  });

  IamportPayData.fromJson(Map<String, dynamic> json):
        payMethod = json['payMethod'],
        name = json['name'],
        merchantUid = json['merchantUid'],
        amount = json['amount'],
        buyerName = json['buyerName'],
        buyerTel = json['buyerTel'],
        buyerEmail = json['buyerEmail'],
        buyerAddr = json['buyerAddr'],
        buyerPostcode = json['buyerPostcode'];

  Map<String, dynamic> toJson() => {
    'payMethod' : payMethod,
    'name' : name,
    'merchantUid' : merchantUid,
    'amount' : amount,
    'buyerName' : buyerName,
    'buyerTel' : buyerTel,
    'buyerEmail' : buyerEmail,
    'buyerAddr' : buyerAddr,
    'buyerPostcode' : buyerPostcode
  };
}