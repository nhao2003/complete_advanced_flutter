class SliderObject {
  late String title;
  late String subTitle;
  late String image;

  SliderObject({
    required this.title,
    required this.subTitle,
    required this.image,
  });
}

class Customer {
  late String id;
  late String name;
  late int numOfNotifications;

  Customer({
    required this.id,
    required this.name,
    required this.numOfNotifications,
  });
}

class Contacts {
  late String email;
  late String phone;
  late String link;

  Contacts({
    required this.email,
    required this.phone,
    required this.link,
  });
}

class Authentication {
  Customer? customer;
  Contacts? contacts;
  Authentication({required this.customer, required this.contacts});
}
