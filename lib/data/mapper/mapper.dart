//TO CONVERT RESPONSE TO NON NULLABLE OBJECT :))
import 'package:complete_advanced_flutter/app/extensions.dart';
import 'package:complete_advanced_flutter/data/responses/responses.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
      id: this?.id?.orEmpty() ?? EMPTY,
      name: this?.name?.orEmpty() ?? EMPTY,
      numOfNotifications: this?.numOfNotifications?.orZero() ?? ZERO,
    );
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
      phone: this?.phone?.orEmpty() ?? EMPTY,
      link: this?.link?.orEmpty() ?? EMPTY,
      email: this?.email?.orEmpty() ?? EMPTY,
    );
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(
      customer: this?.customer?.toDomain(),
      contacts: this?.contacts?.toDomain(),
    );
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse? {
  String toDomain() {
    return this?.support?.orEmpty() ?? EMPTY;
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(
        id: this?.id?.orZero() ?? ZERO,
        title: this?.title?.orEmpty() ?? EMPTY,
        image: this?.image?.orEmpty() ?? EMPTY);
  }
}

extension StoreResponseMapper on StoreResponse? {
  Store toDomain() {
    return Store(
        id: this?.id?.orZero() ?? ZERO,
        title: this?.title?.orEmpty() ?? EMPTY,
        image: this?.image?.orEmpty() ?? EMPTY);
  }
}

extension BannerResponseMapper on BannerResponse? {
  BannerAd toDomain() {
    return BannerAd(
        id: this?.id?.orZero() ?? ZERO,
        title: this?.title?.orEmpty() ?? EMPTY,
        image: this?.image?.orEmpty() ?? EMPTY,
        link: this?.link?.orEmpty() ?? EMPTY);
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Service> mappedServices =
        (this?.data?.services?.map((service) => service.toDomain()) ??
                Iterable.empty())
            .cast<Service>()
            .toList();

    List<Store> mappedStores =
        (this?.data?.stores?.map((store) => store.toDomain()) ??
                Iterable.empty())
            .cast<Store>()
            .toList();

    List<BannerAd> mappedBanners =
        (this?.data?.banners?.map((bannerAd) => bannerAd.toDomain()) ??
                Iterable.empty())
            .cast<BannerAd>()
            .toList();

    var data = HomeData(
        services: mappedServices, stores: mappedStores, banners: mappedBanners);
    return HomeObject(data: data);
  }
}

extension StoreDetailsResponseMapper on StoreDetailsResponse? {
  StoreDetails toDomain() {
    return StoreDetails(
        id: this?.id?.orZero() ?? ZERO,
        title: this?.title?.orEmpty() ?? EMPTY,
        image: this?.image?.orEmpty() ?? EMPTY,
        details: this?.details?.orEmpty() ?? EMPTY,
        services: this?.services?.orEmpty() ?? EMPTY,
        about: this?.about?.orEmpty() ?? EMPTY);
  }
}
