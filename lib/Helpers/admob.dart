import 'package:firebase_admob/firebase_admob.dart';

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['social', 'game', 'music'],
  childDirected: false,
  testDevices: <String>["1934bbc94ba81e49"],
);

BannerAd myBanner = BannerAd(
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    //print("BannerAd event is $event");
  },
);

InterstitialAd myInterstitial = InterstitialAd(
  adUnitId: InterstitialAd.testAdUnitId,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    //print("InterstitialAd event is $event");
  },
);
