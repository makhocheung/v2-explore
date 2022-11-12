//
//  LoginView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/11/11.
//

import SwiftUI
import V2EXClient

struct SignInView: View {
    @State var username = ""
    @State var password = ""
    @State var captcha = ""
    @State var captchaUrl: URL?
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismissAction
    @State var isSignIning = false
    var body: some View {
        Grid {
            GridRow {
                HStack {
                    Image("signInIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
                .gridCellColumns(2)
            }
            GridRow {
                Text("common.username")
                    .gridColumnAlignment(.leading)
                TextField("info.usernameOrEmail", text: $username)
                    .frame(width: 221)
            }
            GridRow {
                Text("common.password")
                    .gridColumnAlignment(.leading)
                SecureField("", text: $password)
                    .frame(width: 221)
            }
            GridRow {
                Text("info.areYouRobot")
                    .gridColumnAlignment(.leading)
                AsyncImage(url: captchaUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                        .scaleEffect(0.5)
                }
                .frame(height: 55)
                .onTapGesture {
                    captchaUrl = V2EXClient.shared.getCaptchaUrl()
                }
            }
            GridRow {
                Text("common.captcha")
                    .gridColumnAlignment(.leading)
                TextField("info.enterCaptchaAndClickToChangePicture", text: $captcha)
                    .frame(width: 221)
            }
            GridRow {
                HStack {
                    Button {
                        dismissAction()
                    } label: {
                        Label("common.cancel", systemImage: "xmark.circle")
                            .frame(width: 55)
                    }
                    Button {
                        Task {
                            isSignIning = true
                            let signIn = SignIn(usernameKey: appState.preSignIn.usernameKey, passwordKey: appState.preSignIn.passwordKey, captchaKey: appState.preSignIn.captchaKey, username: username, password: password, captcha: captcha, once: appState.preSignIn.once)
                            do {
                                let user = try await V2EXClient.shared.signIn(signIn: signIn)
                                appState.upateUser(user: user)
                            } catch {
                                print(error)
                            }
                            isSignIning = false
                            dismissAction()
                        }
                    } label: {
                        Label("common.signIn", systemImage: "arrow.up.circle")
                            .frame(width: 55)
                    }
                }
                .gridCellColumns(2)
            }
        }
        .padding()
        .padding(.horizontal)
        .padding(.horizontal)
        .frame(width: 400, height: 300)
        .background(.thinMaterial)
        .overlay {
            if isSignIning {
                ZStack {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.15))
            }
        }
        .task {
            do {
                let preSignIn = try await V2EXClient.shared.getPreSignIn()
                captchaUrl = preSignIn.captchaUrl
                appState.preSignIn = preSignIn
            } catch {
                print(error)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AppState())
    }
}
