//
//  Logging.swift
//  Networking
//
//  Created by Andrew Bernard on 3/26/25.
//

import OSLog

struct Logging {
    private static let subsystem = "networkingKit"
    
    private static let defaultCategory = "Networking"
    
    private static let logger = Logger(subsystem: subsystem, category: defaultCategory)
    
    static func debug(_ message: String, category: String = defaultCategory,file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
        let fileName = (file as NSString).lastPathComponent
        var messageBuilder: String {
            var completeMessage: String = ""
            completeMessage = """
        🪵 - \(category) \(Date().twentyFourhourMinuteSecondMillisecond())
        \(message)
        📁 - [\(fileName):\(line) \(function)]
        """
            return completeMessage
        }
       
        logger.debug("\(messageBuilder, privacy: .private)")
#endif
        
        
        
    }
}

extension Date {
    func twentyFourhourMinuteSecondMillisecond() -> String {
        return self.formatted(.dateTime.hour().minute().second().secondFraction(.fractional(3)).locale(Locale(identifier: "EUR")))
    }
}
