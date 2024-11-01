//
//  TimerManager.swift
//  MatchingPairs
//
//  Created by Razvan Secure on 01.11.2024.
//

import Foundation

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let startTime: Int
    
    init(startTime: Int) {
        self.startTime = startTime
        self.timeRemaining = startTime
    }

    func start() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    func stop() {
        timer.upstream.connect().cancel()
    }

    func reset() {
        stop()
        timeRemaining = startTime
        start()
    }
    
    func decrementTime() {
        timeRemaining -= 1
    }
}
