import 'package:firebase_admob/firebase_admob.dart';

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['social', 'game', 'music'],
  childDirected: false,
  testDevices: <String>["1934bbc94ba81e49"],
);

BannerAd myBanner = BannerAd(
  adUnitId: "ca-app-pub-2362392610669971/9288079691",
  //adUnitId: BannerAd.testAdUnitId,
  size: AdSize.fullBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    //print("BannerAd event is $event");
  },
);

InterstitialAd myInterstitial = InterstitialAd(
  adUnitId: "ca-app-pub-2362392610669971/8135366858",
  //adUnitId: InterstitialAd.testAdUnitId,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    //print("InterstitialAd event is $event");
  },
);
