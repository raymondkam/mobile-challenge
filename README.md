# Mobile Developer Coding Challenge

This is a coding challenge for prospective mobile developer applicants applying through https://about.500px.com/jobs/

### Instructions:

1. Clone the master branch of the repository
2. Open project workspace file with Xcode
3. Compile and build
4. If it does not compile and build, navigate to the project directory containing the Podfile and use 'pod install'

## Goal:

#### Develop a simple app that allows viewing and interacting with a grid of currently popular 500px photos

- [x] Fork this repo. Keep it public until we have been able to review it.
- [x] Android: _Java_ | iOS: _Swift 3_
- [x] 500px API docs are here: https://github.com/500px/api-documentation. Please don't use **deprecated** [iOS](https://github.com/500px/500px-iOS-api) and [Android](https://github.com/500px/500px-android-sdk) SDKs.
- [x] Grid of photos should preserve the aspect ratio of the photos it's displaying. Optionally: exclude nude images.
- [x] Grid should work in both portrait and landscape orientations of the device.
- [x] Grid should support pagination, i.e. you can scroll on grid of photos infinitely.
- [x] When user taps on a photo on the grid she should show the photo in full screen with more information about the photo.
- [x] When user swipes on a photo in full screen, preserve it's location on the grid, so when she dismisses the full screen, grid of photos should contain the last photo she saw.

### Evaluation:
- [ ] Solution compiles. If there are necessary steps required to get it to compile, those should be covered in README.md.
- [ ] No crashes, bugs, compiler warnings
- [ ] App operates as intended
- [ ] Conforms to SOLID principles
- [ ] Code is easily understood and communicative
- [ ] Commit history is consistent, easy to follow and understand
