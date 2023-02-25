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

class DeviceInfo {
  late String name;
  late String identifier;
  late String version;

  DeviceInfo({
    required this.name,
    required this.identifier,
    required this.version,
  });
}

class Service {
  int id;
  String title;
  String image;

  Service({required this.id, required this.title, required this.image});
}

class Store {
  int id;
  String title;
  String image;

  Store({required this.id, required this.title, required this.image});
}

class BannerAd {
  int id;
  String title;
  String image;
  String link;

  BannerAd(
      {required this.id,
      required this.title,
      required this.image,
      required this.link});
}

class HomeData {
  List<Service> services;
  List<Store> stores;
  List<BannerAd> banners;

  HomeData(
      {required this.services, required this.stores, required this.banners});
}

class HomeObject {
  HomeData data;

  HomeObject({required this.data});
}

class StoreDetails {
  int id;
  String title;
  String image;
  String details;
  String services;
  String about;

  StoreDetails({
    required this.id,
    required this.title,
    required this.image,
    required this.details,
    required this.services,
    required this.about,
  });
}
