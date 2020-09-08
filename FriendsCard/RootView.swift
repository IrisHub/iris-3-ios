//
//  RootView.swift
//  FriendsCard
//
//  Created by Shalin on 9/7/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import NavigationStack

struct RootView: View {
    // important for the first time -> create an account
    @EnvironmentObject var googleDelegate: GoogleDelegate

    var body: some View {
        NavigationStackView {
            if !UserDefaults.standard.bool(forKey: "onboardingComplete") {
                PhoneNumberView().environmentObject(googleDelegate)
            } else {
                HomeView().environmentObject(googleDelegate)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
