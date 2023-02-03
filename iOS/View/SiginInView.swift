//
//  SiginInView.swift
//  V2 Explore (iOS)
//
//  Created by Mak Ho-Cheung on 2023/2/3.
//

import SwiftUI
import V2EXClient

struct SignInView: View {
    
    @State var username = ""
    @State var password = ""
    @State var captcha = ""
    @State var captchaUrl: URL?
    @State var isSignIning = false
    
    @Environment(\.dismiss) var dismissAction

    @EnvironmentObject var appState: AppState
   
    var body: some View {
        Grid {
            GridRow {
                AppIconView(size: 64)
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
                captchaView
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
                        siginIn()
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
