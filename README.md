# NEvent

[![CI Status](http://img.shields.io/travis/Naithar/NEvent.svg?style=flat)](https://travis-ci.org/Naithar/NEvent)
[![Version](https://img.shields.io/cocoapods/v/NEvent.svg?style=flat)](http://cocoapods.org/pods/NEvent)
[![Coverage Status](https://coveralls.io/repos/Naithar/NEvent/badge.svg?branch=master)](https://coveralls.io/r/Naithar/NEvent?branch=master)

## Author

Naithar, devias.naith@gmail.com

## Setup
* Add ```pod 'NEvent', :git => 'https://github.com/naithar/NEvent.git'``` to your [Podfile](http://cocoapods.org/)
* Run ```pod install```
* Open created ```.xcworkspace``` file
* Add ```#import <NHEventListner.h>``` in your source code

## Usage
```objc
[[NHEvent eventWithName:nil block:^(NHEvent *event, NSDictionary *data) {
    ...your code...
}] performWithData:@{ ... }];
```

```objc
NHEventListener *listener = [NHEventListener listener];
[listener addEvent:@"event" withAction:^(NHEvent *event, NSDictionary *data) {
    ...your code...
}];

[listener performEvent:@"event" withData:@{ ... }];
```

## License

NEvent is available under the MIT license. See the LICENSE file for more info.
