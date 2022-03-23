class CreateOrder {
  String id;
  int qty;

  CreateOrder(this.id, this.qty);
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qty'] = this.qty;
    return data;
  }
  @override
  String toString() {
    return "{'id':'$id,'qty':'$qty'}";
  }
}
