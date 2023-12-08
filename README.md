# flutter_external_packages

## flutter_ume: 1.1.2

* https://github.com/bytedance/flutter_ume
    * device_info -> device_info_plus
    * share -> share_plus
    * fix compile issues on flutter 3.16.3

```yaml
  flutter_ume:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/flutter_ume
      ref: flutter_3.16.3
  flutter_ume_kit_channel_monitor:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/flutter_ume/kits/flutter_ume_kit_channel_monitor
      ref: flutter_3.16.3
  flutter_ume_kit_console:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/flutter_ume/kits/flutter_ume_kit_console
      ref: flutter_3.16.3
  flutter_ume_kit_device:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/flutter_ume/kits/flutter_ume_kit_device
      ref: flutter_3.16.3
  flutter_ume_kit_dio:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/flutter_ume/kits/flutter_ume_kit_dio
      ref: flutter_3.16.3
  flutter_ume_kit_perf:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/flutter_ume/kits/flutter_ume_kit_perf
      ref: flutter_3.16.3
  flutter_ume_kit_show_code:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/flutter_ume/kits/flutter_ume_kit_show_code
      ref: flutter_3.16.3
  flutter_ume_kit_ui:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/flutter_ume/kits/flutter_ume_kit_ui
      ref: flutter_3.16.3
```

## fluwx: 4.4.3

* https://github.com/OpenFlutter/fluwx
    * Remove useless import  `BuildConfig` in `WXAPiHandler` which cause `BuildConfig not found` on flutter 3.16.3

```yaml
  fluwx:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/fluwx
      ref: flutter_3.16.3
```

## wakelock: 0.6.2

* https://github.com/creativecreatorormaybenot/wakelock
    * Upgrade windows deps

```yaml
  wakelock:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/wakelock
      ref: flutter_3.16.3
```

## webview_jsbridge_x 1.0.5

* https://github.com/KouYiGuo/webview_jsbridge_x
    * ~~https://github.com/netvue/webview_jsbridge_x~~
    * Upgrade flutter_webview deps (WebView -> WebViewWidget)
    * Refactor jsbridge implementation

```yaml
  webview_jsbridge_x:
    git:
      url: https://github.com/netvue/flutter_external_packages
      path: packages/webview_jsbridge_x
      ref: flutter_3.16.3
```
