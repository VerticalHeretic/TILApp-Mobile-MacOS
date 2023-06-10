//
//  Logger.swift
//  TILApp
//
//  Created by Łukasz Stachnik on 10/06/2023.
//

import Foundation
import os

enum LoggingCategory: String {
    case auth
    case networking
}

struct LoggerClient {
    static let authLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: LoggingCategory.auth.rawValue)
    static let networkingLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: LoggingCategory.networking.rawValue)
}
