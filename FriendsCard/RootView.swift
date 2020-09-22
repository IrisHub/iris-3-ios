//
//  RootView.swift
//  FriendsCard
//
//  Created by Shalin on 9/9/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @EnvironmentObject var screenCoordinator: ScreenCoordinator

    var body: some View {
        NavigationView {
            if !UserDefaults.standard.bool(forKey: "onboardingComplete") {
                PhoneNumberView().environmentObject(googleDelegate).environmentObject(screenCoordinator)
            } else {
                HomeView().environmentObject(googleDelegate).environmentObject(screenCoordinator)
            }
        }
        .hideNavigationBar()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
