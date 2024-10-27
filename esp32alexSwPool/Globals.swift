//
//  Globals.swift
//  esp32alexSwPool
//
//  Created by Alexey Sorokin on 22.10.2024.
//

import Foundation

final class Settings {
    
    static let shared = Settings()
    
    private var defaults = UserDefaults.standard
    
    private func read<T>(property: String = #function) -> T? {
        defaults.object(forKey: property) as? T
    }
    
    private func write<T>(_ value: T, to property: String = #function) {
        defaults.setValue(value, forKey: property)
    }
    
    func set<T>(value: T, key: String) {
        defaults.setValue(value, forKey: key)
    }
}

extension Settings {
    
    var addr: String {
        get { read() ?? "http://192.168.1.131" }
        set { write(newValue) }
    }
    
    var login: String {
        get { read() ?? "admin" }
        set { write(newValue) }
    }
    
    var pwd: String {
        get { read() ?? "780" }
        set { write(newValue) }
    }
    
    var autoRefresh: Bool {
        get { read() ?? false }
        set { write(newValue) }
    }
    
    var refreshPeriod: Double {
        get { read() ?? 5 }
        set { write(newValue) }
    }
    
    var waterTrmId: String {
        get { read() ?? "t28F0A158D4E13C7D" }
        set { write(newValue) }
    }
    
    var heaterInTrmId: String {
        get { read() ?? "t2823CC7997040342" }
        set { write(newValue) }
    }
    
    var heaterOutTrmId: String {
        get { read() ?? "t28E20E799704034B" }
        set { write(newValue) }
    }
    
    var pumpRelayID: String {
        get { read() ?? "R4" }
        set { write(newValue) }
    }
    
    var heaterRelayID: String {
        get { read() ?? "R0" }
        set { write(newValue) }
    }
    
    var lightWaterRelayID: String {
        get { read() ?? "R1" }
        set { write(newValue) }
    }
    
    var lightExtRelayID: String {
        get { read() ?? "R2" }
        set { write(newValue) }
    }

    var heaterPrsID: String {
        get { read() ?? "AI0" }
        set { write(newValue) }
    }

    var filterPrsID: String {
        get { read() ?? "AI2" }
        set { write(newValue) }
    }
    
    var waterLevelID: String {
        get { read() ?? "AI1" }
        set { write(newValue) }
    }
    
}


func n2b(_ number: Int?) -> Bool? {
    if let number {
        return !(number == 0)
    } else {
        return nil
    }
}

func b2s(_ bool: Bool?) -> String? {
    if let bool {
        return bool ? "1" : "0"
    } else {
        return nil
    }
}
