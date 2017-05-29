# Octobook

Octobook is a simple [Gitbook](https://www.gitbook.com) App that offers offline/online gitbooks reading.

### Features

![screenshot1](https://github.com/KrisYu/Octobook/blob/master/screenshots/screenshot1.png?raw=true)
![screenshot2](https://github.com/KrisYu/Octobook/blob/master/screenshots/screenshot2.png?raw=true)


- check the most popular books
- online reading/check authors' other books
- download book for offline reading
- search


### Why make this

This is just an experiment learning more about iOS development and Cocopods 3rd party library usage.

All the UI related thing is done using Storyboard.

![storyboard](https://github.com/KrisYu/Octobook/blob/master/screenshots/storyboard.png?raw=true)


### Build

#### Requirements

- iOS 10.0
- Xcode 8.3.2

#### Build to your device with Xcode

`git clone` then open `Octobook.xcworkspace`

p.s. 

1. you can test iOS app on your device without paid apple developer program or jailbreak -> <https://stackoverflow.com/questions/4952820/test-ios-app-on-device-without-apple-developer-program-or-jailbreak>  
2. If anything about 3rd party libraries goes wrong, try update pod or pod (re)install, Google is your friend.

### Issues

1. not good code, mix the network model in controller.
2. didn't follow the rule - DRY(don't repeat yourself), want to seperate the network but didn't find a good way, so some code are repeated in the popular books controller and searh controller
