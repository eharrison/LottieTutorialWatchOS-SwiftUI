//
//  ContentView.swift
//  LottieTutorialWatchOS-SwiftUI WatchKit Extension
//
//  Created by Evandro Harrison Hoffmann on 13/09/2021.
//

import SwiftUI

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
