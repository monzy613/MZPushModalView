# MZPushModalView

[![CI Status](http://img.shields.io/travis/monzy613/MZPushModalView.svg?style=flat)](https://travis-ci.org/monzy613/MZPushModalView)
[![Version](https://img.shields.io/cocoapods/v/MZPushModalView.svg?style=flat)](http://cocoapods.org/pods/MZPushModalView)
[![License](https://img.shields.io/cocoapods/l/MZPushModalView.svg?style=flat)](http://cocoapods.org/pods/MZPushModalView)
[![Platform](https://img.shields.io/cocoapods/p/MZPushModalView.svg?style=flat)](http://cocoapods.org/pods/MZPushModalView)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Quick use
###Objc
```objc
    #import <MZPushModalView/MZPushModalView.h>
    //...
    [MZPushModalView showModalView:modalView rootView:nil direction:MZPushModalViewShowFromTop];
    //or
    [MZPushModalView showModalView:modalView rootView:nil];//MZPushModalViewShowFromBottom by default
```
###Swift
```swift
    import MZPushModalView
    MZPushModalView.showModalView(modalView, rootView: nil, direction: .FromTop)
    //or
    MZPushModalView(modalView: modalView, rootView: nil)//.FromBottom by default
```
## snapshots

![img](https://github.com/monzy613/MZPushModalView/blob/master/snapshots/1.jpg?raw=true)
![img](https://github.com/monzy613/MZPushModalView/blob/master/snapshots/2.jpg?raw=true)
![img](https://github.com/monzy613/MZPushModalView/blob/master/snapshots/3.jpg?raw=true)

## Requirements

## Installation

To install
it, simply add the following line to your Podfile:

```ruby
pod "MZPushModalView"
```

## Author

monzy613, monzy613@gmail.com

## License

MZPushModalView is available under the MIT license. See the LICENSE file for more info.
