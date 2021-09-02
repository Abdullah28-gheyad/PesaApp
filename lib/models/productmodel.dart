class ProductModel
{
  String name ;
  String price ;
  String description ;
  String categoryName ;
  String image ;
  String id ;
  ProductModel({this.name,this.image,this.price,this.categoryName,this.description,this.id}) ;
  ProductModel.FromJson(Map<String,dynamic>json)
  {
    name=  json['name'];
    price=  json['price'];
    description=  json['description'];
    categoryName=  json['categoryName'];
    image=  json['image'];
    id=  json['id'];
  }

  Map <String,dynamic> toMap()
  {
    return {
      'name':name,
      'price':price,
      'description':description,
      'categoryName':categoryName,
      'image':image,
      'id':id,
    };
  }

}