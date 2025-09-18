//
//  AppVersionCheckManager.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/3/25.
//

import Foundation

final class AppVersionCheckManager {

    static let shared = AppVersionCheckManager()
    let appStoreURL = URL(string: "https://apps.apple.com/app/6741481784")!
    init() {}

    func fetchAppStoreVersion(completion: @escaping (String?) -> Void) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            completion(nil)
            return
        }

        let urlStr = "https://itunes.apple.com/lookup?id=6741481784"

        guard let url = URL(string: urlStr) else {
            completion(nil)
            print("❌AppStoreVersion URL 변환 실패: \(urlStr)")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results.first?["version"] as? String else {
                completion(nil)
                return
            }

            completion(appStoreVersion)
        }.resume()
    }

    func isUpdateAvailable(appStoreVersion: String) -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        print("🚀 currentVersion: \(currentVersion), appstore: \(appStoreVersion)")
        return currentVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending
    }

}
