# auth

A Flutter project with exmple of sign in with google.

## Getting Started

create app in https://console.cloud.google.com/

setup consent screen scopes and add test users ![/docs/consent.png](/docs/consent.png)

create credentials oauth client id for android
![/docs/cred.png](/docs/cred.png)

update `android/app/build.gradle` and add manifestPlaceholders with your CLIENT_ID

```
defaultConfig {
        ...

        manifestPlaceholders += [
            'appAuthRedirectScheme': 'com.googleusercontent.apps.<CLIENT_ID>'
        ]
    }
```

update `lib/screen1.dart` and update ANDROID_CLIENT_ID
![/docs/clienId.png](/docs/clientId.png)