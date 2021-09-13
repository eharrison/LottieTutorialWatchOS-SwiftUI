# Lottie Tutorial for watchOS with SwiftUI

## About

This example demonstrates the usage of Lottie animations for watchOS with SwiftUI.

Steps to add it to your project:
- Add SwiftPackage: https://github.com/SDWebImage/SDWebImageLottieCoder
- Import LottieViewModel (found in project files)
- In your SwiftUI class, add as following:

```swift
struct ContentView: View {
    @ObservedObject var viewModel: LottieViewModel = .init()
    
    var body: some View {
        Image(uiImage: viewModel.image)
            .resizable()
            .scaledToFit()
            .onAppear {
                       self.viewModel.loadAnimation(url: URL(string: "https://assets8.lottiefiles.com/packages/lf20_Zz37yH.json")!)
                   }
    }
}
```


## Requirements

- Swift 5.0
- watchOS 6.0+

Happy coding! 😀
