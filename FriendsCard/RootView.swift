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

    var body: some View {
        NavigationView {
            if !UserDefaults.standard.bool(forKey: "onboardingComplete") {
                PhoneNumberView().environmentObject(googleDelegate)
            } else {
                HomeView().environmentObject(googleDelegate)
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
