class IamportPayData {
  final String name;
  final String merchantUid;
  final int amount;
  final String? buyerName;
  final String? buyerTel;
  final String? buyerEmail;
  final String? buyerAddr;
  final String? buyerPostcode;

  IamportPayData({
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
        name = json['name'],
        merchantUid = json['merchantUid'],
        amount = json['amount'],
        buyerName = json['buyerName'],
        buyerTel = json['buyerTel'],
        buyerEmail = json['buyerEmail'],
        buyerAddr = json['buyerAddr'],
        buyerPostcode = json['buyerPostcode'];

  Map<String, dynamic> toJson() => {
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