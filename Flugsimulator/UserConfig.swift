//
//  UserConfig.swift
//  Naggar
//
//  Created by Mohamed El-Naggar on 2/6/21.
//

import Foundation

struct UserConfig {
    static var userScores: [Double]? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "UserScores")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.array(forKey: "UserScores") as? [Double]
        }
    }
}

extension UserConfig {
    static func saveUserScore(currentScore: Double) {
        guard var scores = UserConfig.userScores , scores.count > 0 else {
            UserConfig.userScores = [currentScore]
            return
        }
        
        if scores.count < 10 {
            scores.append(currentScore)
        } else if currentScore > scores[scores.count - 1] {
            scores[scores.count - 1] = currentScore
            UserConfig.userScores = scores.sorted().reversed()
        }
        
        UserConfig.userScores = scores.sorted().reversed()

    }
    
    static func getUserScores() -> [Double] {
        var scores: [Double] = []
        
        for score in UserConfig.userScores ?? [] {
            let y = Double(round(1000 * score)/1000)

            scores.append(y)
        }
        
        return scores
    }
}
