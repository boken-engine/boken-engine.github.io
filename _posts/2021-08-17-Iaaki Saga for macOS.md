---
layout: post
title: Iakkai Saga for macOS
subtitle: Running Iakkai on your macOS by Jose Celano
cover-img: /assets/img/macos-cover.jpg
thumbnail-img: /assets/img/iakkai-macos-thumbnail.png
share-img: /assets/img/iakkai-title-screen.png
tags: [iakkai,demo,macOS]
---

Although you can easily build and run the [Iakkai demo project](https://github.com/boken-engine/iakkai-saga-the-curse-of-blood) on your macOS, we wanted to have a simpler way to execute it. We wanted to show what you can build using Boken Engine even before knowing how to do it.

That's why we decided to build a macOS version. If you have an iOS device the simplest way is to install the Iakkai iOS App from the Apple App Store: [Iakkai](https://apps.apple.com/app/id1580924283#?platform=ipad).

If you do not have an iOS device you can [download Iakkai](https://github.com/boken-engine/iakkai-saga-the-curse-of-blood/releases/download/1.0/iakkai-1.0.zip) and install it as a simple macOS app. You only need to double click to uncompress the file and copy the app to you `Application` folder.

[![Iakkai Saga - Download version 1.0](/assets/img/download-button.png)](https://github.com/boken-engine/iakkai-saga-the-curse-of-blood/releases/download/1.0/iakkai-1.0.zip)

We tried to publish it on the Mac App Store but it was rejected by Apple reviewers. The reason was:

**"Guideline 4.2 - Design - Minimum Functionality"**

They argued that the app was primarly a book.

In order to build the application for macOS we faced mainly 2 issues:

1. Generate a build for macOS.
2. Generate a distributable app outside the Mac App Store.

## Generating a macOS distributable

This task was surprisingly easy. We started reading Apple documentation about [running iOS apps on macOS](https://developer.apple.com/documentation/apple-silicon/running-your-ios-apps-on-macos). Since Boken Engine does not have any special dependency on phone features we only had to add some new xcode settings and build for macOS.

![Deployment Info configuration for macOS on xcode](/assets/img/deployment-info-macos.png)

Apple has develop a project called the [Mac Catalyst](https://developer.apple.com/design/human-interface-guidelines/mac-catalyst/overview/introduction/). As they promise "you can make a Mac version of your iPad app". Basically they use the same libraries under the hood whether you build for iOS or macOS.

![Mac Catalyst stack](/assets/img/mac-catalyst-stack.png)

Once we changed the settings, we tried to build for macOS. We had a build error in one of the methods we used to detect the device's orientation. We solved it with build conditions, making ladscape the only orientation available for macOS.

```javascript
func getDeviceOrientation() -> DeviceOrientation {
    #if targetEnvironment(macCatalyst)
        return DeviceOrientation.horizontal
    #else
    if UIApplication.shared.statusBarOrientation.isLandscape {
        return DeviceOrientation.horizontal
    } else {
        return DeviceOrientation.vertical
    }
    #endif
}
```

After fixing that build error we could run the app for macOS. So we tried to publish it on the Mac App Store. We followed the stardard process to publish directly using xcode but we got this error in the final step while we were uploading the app to the store:

![Universal binary needed upload error](/assets/img/error-universal-binary-needed.png)

The problem here, was that we were building Boken Engine only for arm64 architecture.

![Universal binary needed upload error](/assets/img/error-boken-engine-only-for-arm64.png)

We had to change xcode settings in order to build Boken Engine for both architectures. After doing that we were able to submit the macOS app for review. Unfortunately the application was rejected as we mentioned before.

## Generate a distributable app outside the Mac App Store

Since we could not publish the app using the Mac App Store we decided to distribute it directly. After researching for different ways to do it, we decided to go for the simplest one. You can also use xcode and `archive` a build for macOS. You have to the do the same process you normally do when you upload the application build to the Store. But you have to choose the second option:

![Distribute app with Developer ID](/assets/img/distribute-app-with-developer-id.png)

xcode will magically handle all the process related to signing with your certificates. At the end of the process you have to submit the app to be [notarized](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution). As Apple says:

> Notarization gives users more confidence that the Developer ID-signed software you distribute has been checked by Apple for malicious components.

After some minutes (less than 10) you will receive an email and you can continue the process. Once done you can then export the application distributable and run it on any macOS. The distributable is an [macOS bundle](https://en.wikipedia.org/wiki/Bundle_(macOS)) (folder).

We wanted to generate a single file; however, keeping a simple installation package. Finally we decided to generate a zip file using the command `ditto`:

```
% ditto -c -k --keepParent DDD ZZZ
```

Where DDD is the path to the directory containing the app you have exported in the previous step and and ZZZ is the path where ditto creates the zip archive. That's the app you can download above at the beginning of this post.

I hope this post will help you to build and distribute your Boken Engine based macOS apps and generate a distributable app outside the Mac App Store.

## Conclusion

As you can see you can build your apps using Boken Engine and easily publish them for macOS. If you are planning to build for macOS we recommend you to integrate that version in your pipeline, so you do not get any surprises when you try to build the macOS version.

## Links

Links about generating a macOS app from an iOS project:

* [Running you iOS app on macOS](https://developer.apple.com/documentation/apple-silicon/running-your-ios-apps-on-macos)
* [Creating a Mac Version of Your iPad App](https://developer.apple.com/documentation/uikit/mac_catalyst/creating_a_mac_version_of_your_ipad_app)

Links about distributing outside the Mac App Store:

* [Distributing apps outside the Mac App Store](https://developer.apple.com/developer-id/)
* [Notarizing macOS software before distribution](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
* [Beyond the Sandbox: Signing and distributing macOS apps outside of the Mac App Store](https://www.appcoda.com/distribute-macos-apps/)
* [Create dmg distribution file](https://developer.apple.com/library/archive/documentation/Porting/Conceptual/PortingUnix/distributing/distibuting.html)
* [3 options for distributing macOS apps](https://developer.apple.com/forums/thread/128166)
*[Signing a Mac Product For Distribution](https://developer.apple.com/forums/thread/128166)
