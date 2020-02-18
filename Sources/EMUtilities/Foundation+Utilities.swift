//
//  Foundationpublic extensions.swift
//  Canvass
//
//  Created by Bryan on 11/8/16.
//  Copyright © 2016 Bryan Lloyd Anderson. All rights reserved.
//

import Foundation

public extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

public extension Date {
    func timeAgoDisplay() -> String {

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            if diff == 1 {
                return "\(diff) second"
            }
            return "\(diff) seconds"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            if diff == 1 {
                return "\(diff) minute"
            }
            return "\(diff) minutes"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            if diff == 1 {
                return "\(diff) hour"
            }
            return "\(diff) hours"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff == 1 {
                return "\(diff) day"
            }
            return "\(diff) days"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        if diff == 1 {
            return "\(diff) week"
        }
        return "\(diff) weeks"
    }
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}


public func print(typeOf: Any...) {
    print(typeOf.map({String(describing: type(of: $0))}))
}

public extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//public extension BehaviorRelay where Element: RangeReplaceableCollection {
//    func acceptAppending(_ element: Element.Element) {
//        accept(value + [element])
//    }
//}

public extension String {
    func equalityScore(with string: String) -> Double {
        if self == string {
            return 2     // the greatest equality score this method can give
        } else if self.contains(string) {
            return 1 + 1 / Double(self.count - string.count)   // contains our term, so the score will be between 1 and 2, depending on number of letters.
        } else {
            // you could of course have other criteria, like string.contains(self)
            return 1 / Double(abs(self.count - string.count))
        }
    }
}

private var ordinalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter
}()

public extension Int {
    var ordinal: String? {
        return ordinalFormatter.string(from: NSNumber(value: self))
    }
}

public extension Int {
    var withCommas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

public extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
public extension URL {
    var queryDictionary: [String: String]? {
        guard let query = URLComponents(string: self.absoluteString)?.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}

public extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)m"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)k"
        }
        else {
            return "\(Int(number))"
        }
    }
}

public extension Double {
    var kmFormatted: String {
//        if self >= 1000, self <= 9999 {
//            return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
//        }
        if self >= 10000, self <= 999999 {
            return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999 {
            return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", locale: Locale.current,self)
    }
}

public extension Date {
    
    init?(day: Int, month: Int, year: Int) {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.day = day
        components.month = month
        components.year = year
        guard let date = components.date else { return nil }
        self = date
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var weekBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }

    var monthBefore: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }

    var quarterBefore: Date {
        let quarter = 365 / 4
        return Calendar.current.date(byAdding: .day, value: -quarter, to: self)!
    }
    var yearBefore: Date {
        return Calendar.current.date(byAdding: .year, value: -1, to: self)!
    }
    
    func monthByAdding(_ value: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: value, to: self)!
    }
    func yearByAdding(_ value: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: value, to: self)!
    }
    func dayByAdding(_ value: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: value, to: self)!
    }

}


public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

public extension EnumCollection {
    
    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    static var allValues: [Self] {
        return Array(self.cases())
    }
}

public extension Double {
    init?(_ string: String?) {
        guard let string = string,
        let double = Double(string) else {return nil }
        self = double
    }
}
public extension Int {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
    init?(_ string: String?) {
        guard let string = string,
        let int = Int(string) else { return nil }
        self = int
    }
}

public extension Sequence {
    func recursiveFlatMap<T, TResult>(root: T, transform: @escaping (T) -> TResult?, children: @escaping (T) -> [T]) -> [TResult] {
        var result = [TResult]()
        if let value = transform(root) {
            result.append(value)
        }
        result += children(root).flatMap( { recursiveFlatMap(root: $0, transform: transform, children: children) } )
        return result
    }
    
}

public func sequentialFlatten<S : Sequence>(seq : S, children : @escaping (S.Iterator.Element) -> S) -> AnySequence<S.Iterator.Element> {
    return AnySequence {
        () -> AnyIterator<S.Iterator.Element> in
        
        var mainGen = seq.makeIterator()
        // Current generator, or `nil` if all sequences are exhausted:
        var generator: AnyIterator<S.Iterator.Element>?
        
        return AnyIterator {
            
            guard let gen = generator, let elem = gen.next() else {
                if let elem = mainGen.next() {
                    generator = sequentialFlatten(seq: children(elem), children: children).makeIterator()
                    return elem
                }
                return nil
            }
            return elem
        }
    }
}


public extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}

public extension DateComponents {
    init(_ body: (inout DateComponents) -> ()) {
        self.init()
        body(&self)
    }
}

public extension Int {
    var array: [Int] {
        return description.compactMap{Int(String($0))}
    }
}

public extension NotificationCenter {
    
    func post(name: Notification.Name) {
        post(name: name, object: nil)
    }
    
    func addObserver(forName name: Notification.Name?, using block: @escaping (Notification) -> Swift.Void) {
        addObserver(forName: name, object: nil, queue: nil, using: block)
    }
}

public extension String {
    var intValue: Int? {
        return Int(self)
    }
}


public extension Optional {
    // `then` function executes the closure if there is some value
    func then(_ handler: (Wrapped) -> Void) {
        switch self {
        case .some(let wrapped): return handler(wrapped)
        case .none: break
        }
    }
}

public extension Array {
    func takeElements(elementCount: Int) -> Array {
        if (elementCount > count) {
            return Array(self[0..<count])
        }
        return Array(self[0..<elementCount])
    }
}

public extension Array {
    var randomItem: Element? {
        let index = Int(arc4random_uniform(UInt32(self.count)))
    return self[safe: index]
    }
}

public extension Array {
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count
            ? self[index]
            : nil
    }
}

public extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
    
    /** Appends the element only if the element is unique */
//    mutating func insert(uniqueElement: Element, atBeginning: Bool = false) {
//        if contains(uniqueElement) == false {
//            if atBeginning {
//                self.insert(uniqueElement, atIndex: 0)
//            } else {
//                self.append(uniqueElement)
//            }
//        }
//    }
}


public extension String {
    
    var length: Int {
        return self.count
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(from: Int) -> String {
        return self[min(from, length) ..< length]
    }
    
    func substring(to: Int) -> String {
        return self[0 ..< max(0, to)]
    }
}



