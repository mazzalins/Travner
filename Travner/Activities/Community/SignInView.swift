//
//  SignInView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 07/05/22.
//

import AuthenticationServices
import SwiftUI

struct SignInView: View {
    enum SignInStatus {
        case unknown
        case authorized
        case failure(Error?)
    }

    @State private var status = SignInStatus.unknown
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            Group {
                switch status {
                case .unknown:
                    VStack(alignment: .leading) {
                        ScrollView {
                            Text("""
                            In order to keep our community safe, we ask that you sign in before commenting on a guide.

                            We don't track your personal information; your name is used only for display purposes.

                            Please note: we reserve the right to remove messages that are inappropriate or offensive.
                            """)
                        }

                        Spacer()

                        SignInWithAppleButton(onRequest: configureSignIn, onCompletion: completeSignIn)
                            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                            .frame(height: 44)
                    }
                case .authorized:
                    Text("You're all set!")
                case .failure(let error):
                    if let error = error {
                        Text("Sorry, there was an error: \(error.localizedDescription)")
                    } else {
                        Text("Sorry, there was an error.")
                    }
                }
            }
            .padding()
            .toolbar {
                Button(action: dismiss, label: {
                    Circle()
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .heavy, design: .rounded))
                                .foregroundColor(.secondary)
                        )
                })
            }
            .navigationTitle("Please sign in")
        }
    }

    func configureSignIn(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName]
    }

    func completeSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let appleID = auth.credential as? ASAuthorizationAppleIDCredential {
                if let fullName = appleID.fullName {
                    let formatter = PersonNameComponentsFormatter()
                    var username = formatter.string(from: fullName).trimmingCharacters(in: .whitespacesAndNewlines)

                    if username.isEmpty {
                        // Refuse to allow empty string names
                        username = "User-\(Int.random(in: 1001...9999))"
                    }

                    UserDefaults.standard.set(username, forKey: "username")
                    NSUbiquitousKeyValueStore.default.set(username, forKey: "username")
                    status = .authorized
                    dismiss()
                    return
                }
            }

            status = .failure(nil)

        case .failure(let error):
            if let error = error as? ASAuthorizationError {
                if error.errorCode == ASAuthorizationError.canceled.rawValue {
                    status = .unknown
                    return
                }
            }

            status = .failure(error)
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
