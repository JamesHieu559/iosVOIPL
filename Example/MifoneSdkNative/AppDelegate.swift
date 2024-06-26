//
//  AppDelegate.swift
//  MifoneSdkNative
//
//  Created by Hieu James on 14/03/2024.
//

import UIKit
import MifoneSdkNative
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, LogDelegate {
    

    var window: UIWindow?

    // var voipLib = VoIPLibCallDelegate()
    
    private let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        loadDefaultCredentialsFromEnvironment()
        
        let applicationSetup = ApplicationSetup(
            middleware: VoIPGRIDMiddleware(),
            requestCallUi: {
                if let nav = self.window?.rootViewController as? UITabBarController {
                    nav.performSegue(withIdentifier: "LaunchCallSegue", sender: nav)
                }
            },
            logDelegate: self
        )
        
        do {
            _ = try startIOSPIL(
                applicationSetup: applicationSetup,
                auth: Auth(
                    username: self.userDefault(key: "username"),
                    password: self.userDefault(key: "password"),
                    domain: self.userDefault(key: "domain"),
                    proxy: self.userDefault(key: "proxy"),
                    transport: self.userDefault(key: "transport"),
                    port: Int(self.userDefault(key: "port")) ?? 0,
                    secure: self.defaults.bool(forKey: "encryption")
                )
            )
        } catch {
           print("ERROR: Failed to start PIL - \(error)")
        }
        
        return true
    }
    
    /// Loads in environment variables into the user default, so you can provide default login information to avoid manually adding it every time.
    ///
    /// To add environment variables, in xCode, "Edit Scheme" > Run > Environment and add the environment keys (e.g. pil.default.username) and
    /// the relevant values (i.e. your voip account password).
    private func loadDefaultCredentialsFromEnvironment() {
        _ = loadCredentialFromEnvironment(environmentKey: "pil.default.username", userDefaultsKey: "username")
        _ = loadCredentialFromEnvironment(environmentKey: "pil.default.password", userDefaultsKey: "password")
        _ = loadCredentialFromEnvironment(environmentKey: "pil.default.domain", userDefaultsKey: "domain")
        _ = loadCredentialFromEnvironment(environmentKey: "pil.default.proxy", userDefaultsKey: "proxy")
        _ = loadCredentialFromEnvironment(environmentKey: "pil.default.transport", userDefaultsKey: "transport")
        _ = loadCredentialFromEnvironment(environmentKey: "pil.default.port", userDefaultsKey: "port")
        if loadCredentialFromEnvironment(environmentKey: "pil.default.voipgrid.username", userDefaultsKey: "voipgrid_username")
            && loadCredentialFromEnvironment(environmentKey: "pil.default.voipgrid.password", userDefaultsKey: "voipgrid_password") {
            SettingsViewController.attemptVoipgridLogin { _ in }
        }
    }
    
    func configAudioSession(){
        let audioSession = AVAudioSession.sharedInstance()
        let bAudioInputAvailable = audioSession.isInputAvailable
        var err: NSError?

        do {
            try audioSession.setActive(false)
        } catch let error as NSError {
            err = error
            print("audioSession setActive failed: \(err?.description ?? "")")
        }

        if !bAudioInputAvailable {
            let errView = UIAlertController(title: NSLocalizedString("No microphone", comment: ""),
                                            message: NSLocalizedString("You need to plug a microphone to your device to use the application.", comment: ""),
                                            preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                              style: .default,
                                              handler: nil)
            
            errView.addAction(defaultAction)
        }
    }
    
    /// Attempts to load a credential from an environment variable, and puts it into the user defaults.
    private func loadCredentialFromEnvironment(environmentKey: String, userDefaultsKey: String) -> Bool {
        if let value = ProcessInfo.processInfo.environment[environmentKey] {
            if !value.isEmpty {
                self.defaults.set(value, forKey: userDefaultsKey)
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    private func userDefault(key: String) -> String {
        defaults.object(forKey: key) as? String ?? ""
    } //TODO: move this outside ViewControllers
    
    func onLogReceived(message: String, level: LogLevel) {
        print("\(String(describing: level)) \(message)")
    }
}

