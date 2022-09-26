//
//  ThinkDirtyTestAppApp.swift
//  ThinkDirtyTestApp
//
//  Created by Vivienne Fosh on 25.09.2022.
//

import SwiftUI
import Stinsen
import Kingfisher

@main
struct ThinkDirtyTestApp: App {
    @StateObject private var appState: AppState
    @StateObject private var rootCoordinator: RootCoordinator
    
    @State private var reachability = try? Reachability()
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        let appState = AppState()
        
        _appState = StateObject(wrappedValue: appState)
        _rootCoordinator = StateObject(wrappedValue: RootCoordinator(appState: appState))
        
        catchAllExceptions()
        
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 100
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationViewCoordinator(rootCoordinator)
                .view()
                .onAppear {
                    onAppear()
                }.onDisappear {
                    reachability?.stopNotifier()
                }
                .onChange(of: scenePhase, perform: { phase in
                    switch phase {
                    case .active: break
                    case .inactive: break
                    case .background:
                        NetworkLogger.unregister()
                    @unknown default: break
                    }
                })
                .onReceive(appState.alertMessageSubject) { message in
                    presentAlert(title: message, message: nil)
                }.onReceive(appState.alertErorSubject) { error in
                    handleError(error)
                }.onReceive(appState.resignFirstResponderSubject) {
                    UIApplication.shared.key?.resignFirstResponder()
                    UIApplication.shared.key?.endEditing(true)
                }
        }
    }
    
    private func onAppear() {
        guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else { return }
        reachability?.whenUnreachable = { _ in
            appState.alertMessageSubject.send("No Internet Connection")
        }
        
        try? reachability?.startNotifier()
        
        NetworkLogger.register()
    }
}

private extension ThinkDirtyTestApp {
    func presentAlert(title: String?, message: String?) {
        guard let windowScene = UIApplication.shared.key?.windowScene else { return }
        
        var alertWindow: UIWindow? = UIWindow(windowScene: windowScene)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = UIWindow.Level.alert
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            alertWindow?.isHidden = true
            alertWindow = nil
        })
        
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func handleError(_ error: Error) {
        if let error = error as? URLError, error.code == .userAuthenticationRequired {
            // Logout
        } else {
            presentAlert(title: error.localizedDescription, message: nil)
        }
    }
}

private extension ThinkDirtyTestApp {
    func catchAllExceptions() {
        NSSetUncaughtExceptionHandler { (exception) in
            print(exception.reason ?? "")
        }
    }
}
