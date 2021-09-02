class OrderModel {
  String dateTime;
  String ownerName;

  String totalPrice;

  String deliveryTime;

  String street;

  String city;

  String state;

  String country;

  OrderModel(
      {this.state,
      this.totalPrice,
      this.country,
      this.city,
      this.street,
      this.dateTime,
      this.deliveryTime,
      this.ownerName});

  OrderModel.FromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    ownerName = json['ownerName'];
    totalPrice = json['totalPrice'];
    deliveryTime = json['deliveryTime'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime':dateTime,
      'ownerName':ownerName,
      'totalPrice':totalPrice,
      'deliveryTime':deliveryTime,
      'street':street,
      'city':city,
      'state':state,
      'country':country,
    };
  }
}
