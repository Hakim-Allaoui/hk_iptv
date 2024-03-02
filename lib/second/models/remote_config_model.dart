class RemoteConfigModel{
  String? buttonText;
  String? appColor;
  String? link;
  String? bg_image;
  String? logo;
  bool? showAds;
  bool? approved;
  String? appName;

  RemoteConfigModel({
    this.buttonText,
    this.appColor,
    this.link,
    this.bg_image,
    this.logo,
    this.showAds,
    this.approved,
    this.appName,
  });

  RemoteConfigModel.fromJson(Map<String, dynamic> json) {
    buttonText = json['button_text'];
    appColor = json['app_color'];
    link = json['link'];
    bg_image = json['bg_image'];
    logo = json['logo'];
    showAds = json['show_ads'];
    approved = json['approved'];
    appName = json['app_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['button_text'] = buttonText;
    data['app_color'] = appColor;
    data['link'] = link;
    data['bg_image'] = bg_image;
    data['logo'] = logo;
    data['show_ads'] = showAds;
    data['approved'] = approved;
    data['app_name'] = appName;
    return data;
  }
}