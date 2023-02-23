//
//  LoginView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/11/11.
//

import Shimmer
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
        Form {
            AppIconView(size: 64)
                .listRowBackground(Color.clear)
            Section("common.username") {
                TextField("info.usernameOrEmail", text: $username)
                    .multilineTextAlignment(.leading)
            }
            Section("common.password") {
                SecureField("输入密码", text: $password)
                    .frame(width: 100)
            }
            Section {
                Text("info.areYouRobot")
                // captchaView
            }
            Section("common.captcha") {
                TextField("info.enterCaptchaAndClickToChangePicture", text: $captcha)
                    .frame(width: 100)
            }
            Section {
                HStack {
                    Button {
                        dismissAction()
                    } label: {
                        Label("common.cancel", systemImage: "xmark.circle")
                            .frame(width: 55)
                    }
                    Button {
                        siginIn()
                    } label: {
                        Label("common.signIn", systemImage: "arrow.up.circle")
                            .frame(width: 55)
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(idealWidth: 720)
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

    var captchaView: some View {
        AsyncImage(url: captchaUrl) {
            $0.resizable().scaledToFit()
        } placeholder: {
            Rectangle()
                .shimmering()
        }
        .frame(height: 55)
        .onTapGesture {
            captchaUrl = V2EXClient.shared.getCaptchaUrl()
        }
    }

    func siginIn() {
        isSignIning = true
        Task {
            let signIn = SignIn(usernameKey: appState.preSignIn.usernameKey, passwordKey: appState.preSignIn.passwordKey, captchaKey: appState.preSignIn.captchaKey, username: username, password: password, captcha: captcha)
            do {
                let (user, token) = try await V2EXClient.shared.signIn(signIn: signIn)
                appState.upateUserAndToken(user: user, token: token)
                siginInDone()
            } catch {
                appState.show(errorInfo: "登录失败")
            }
        }
    }

    @MainActor
    func siginInDone() {
        isSignIning = false
        dismissAction()
    }
}

struct SiginInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AppState())
    }
}
