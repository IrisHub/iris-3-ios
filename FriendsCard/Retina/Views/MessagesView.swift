//
//  MessagesView.swift
//  FriendsCard
//
//  Created by Shalin on 9/22/20.
//  Copyright © 2020 Shalin. All rights reserved.
//

import SwiftUI
import UIKit
import MessageUI

struct MessageView: UIViewControllerRepresentable {

    @Binding var isShowing: Bool
    @Binding var result: Result<MessageComposeResult, Error>?

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var result: Result<MessageComposeResult, Error>?

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MessageComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
                defer {
                    isShowing = false
                }

                switch (result) {
                case .cancelled:
                    print("Message was cancelled")
                case .failed:
                    print("Message failed")
                case .sent:
                    print("Message was sent")
                default:
                    return
                }
                self.result = .success(result)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MessageView>) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController,
                                context: UIViewControllerRepresentableContext<MessageView>) {

    }
}
