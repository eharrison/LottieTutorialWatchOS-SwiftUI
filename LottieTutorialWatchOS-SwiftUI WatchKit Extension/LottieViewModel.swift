//
//  LottieView.swift
//  LottieTutorialWatchOS-SwiftUI WatchKit Extension
//
//  Created by Evandro Harrison Hoffmann on 13/09/2021.
//

import SwiftUI
import UIKit
import SDWebImageLottieCoder

class LottieViewModel: ObservableObject {
    @Published private(set) var image: UIImage = UIImage(named: "defaultIcon")!
    
    /// Set false to disable looping the animation
    var loop: Bool = true

    // MARK: - Animation
    
    private var coder: SDImageLottieCoder?
    private var animationTimer: Timer?
    private var currentFrame: UInt = 0
    private var playing: Bool = false
    private var speed: Double = 1.0
    
    /// Loads animation data
    /// - Parameter url: url of animation JSON
    func loadAnimation(url: URL) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.setupAnimation(with: data)
            }
        }
        dataTask.resume()
    }
    
    /// Loads animation data from local file
    /// - Parameter filename: name of the local Lottie file
    func loadAnimationFromFile(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        DispatchQueue.main.async {
            self.setupAnimation(with: data)
        }
    }

    /// Start playing animation
    func play() {
        playing = true

        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05/speed, repeats: true, block: { (timer) in
            guard self.playing else {
                timer.invalidate()
                return
            }
            self.nextFrame()
        })
    }
    
    /// Pauses animation
    func pause() {
        playing = false
        animationTimer?.invalidate()
    }
    
    /// Decodify animation with given data
    /// - Parameter data: data of animation
    private func setupAnimation(with data: Data) {
        coder = SDImageLottieCoder(animatedImageData: data, options: [SDImageCoderOption.decodeLottieResourcePath: Bundle.main.resourcePath!])
        
        // resets to first frame
        currentFrame = 0
        setImage(frame: currentFrame)
        
        play()
    }
    
    /// Set current animation
    /// - Parameter frame: Set image for given frame
    private func setImage(frame: UInt) {
        guard let coder = coder,
              let uiImage = coder.animatedImageFrame(at: frame) else { return }
        self.image = uiImage
    }
    
    /// Replace current frame with next one
    private func nextFrame() {
        guard let coder = coder else { return }

        currentFrame += 1
        // make sure that current frame is within frame count
        // if reaches the end, we set it back to 0 so it loops
        if currentFrame >= coder.animatedImageFrameCount {
            // check if we are looping, set to 0 if so
            if self.loop == true {
                currentFrame = 0
            } else {
                // if we are playing once, basically reset everything
                playing = false
                animationTimer?.invalidate()
            }
        }
        
        setImage(frame: currentFrame)
    }
}
