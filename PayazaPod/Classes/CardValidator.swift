//
//  CardValidator.swift
//  PayazaPod
//
//  Created by Xy-joe on 9/26/23.
//

import Foundation

public enum CreditCardType: String {
    case amex = "^3[47][0-9]{5,}$"
    case visa = "^4[0-9]{6,}$"
    case masterCard = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
    case maestro = "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
    case dinersClub = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
    case jcb = "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
    case discover = "^6(?:011|5[0-9]{2})[0-9]{3,}$"
    case unionPay = "^62[0-5]\\d{13,16}$"
    case mir = "^2[0-9]{6,}$"
    case verve = "^(506099|650002|650006|650010|650011|650012|650013|650015|650016|650017|650018|650019|650020|650021|650022|650027|650032|650033|650035|650036|650037|650038|650039|650040|650041|650042|650043|650044|650045|650046|650047|650048|650049|650050|650051|650052|650053|650054|650055|650056|650057|650058|650059|650060|650061|650062|650063|650064|650065|650066|650067|650068|650069|650070|650071|650072|650073|650074|650075|650076|650077|650078|650079|650080|650081|650082|650083|650084|650085|650086|650087|650088|650089|650090|650091|650092|650093|650094|650095|650096|650097|650098|650099)[0-9]{10}$"

    /// Possible C/C number lengths for each C/C type
    /// reference: https://en.wikipedia.org/wiki/Payment_card_number
    var validNumberLength: IndexSet {
        switch self {
        case .visa:
            return IndexSet([13,16])
        case .amex:
            return IndexSet(integer: 15)
        case .verve:
            return IndexSet([16, 18, 19])
        case .maestro:
            return IndexSet(integersIn: 12...19)
        case .dinersClub:
            return IndexSet(integersIn: 14...19)
        case .jcb, .discover, .unionPay, .mir:
            return IndexSet(integersIn: 16...19)
        default:
            return IndexSet(integer: 16)
        }
    }
    
    var name: String {
        switch self {
        case .amex:
             return "Amex"
        case .visa:
            return "Visa"
        case .verve:
            return "Verve"
        case .masterCard:
            return "MasterCard"
        case .maestro:
            return "Maestro"
        case .dinersClub:
            return "Diners Club"
        case .jcb:
            return "JCB"
        case .discover:
            return "Discover"
        case .unionPay:
            return "UnionPay"
        case .mir:
            return "Mir"
        }
    }
}

public struct CreditCardValidator {
    
    /// Available credit card types
    private let types: [CreditCardType] = [
        .amex,
        .visa,
        .masterCard,
        .maestro,
        .verve,
        .dinersClub,
        .jcb,
        .discover,
        .unionPay,
        .mir
    ]
    
    private let string: String
    
    /// Create validation value
    /// - Parameter string: credit card number
    public init(_ string: String) {
        self.string = string.numbers
    }
    
    /// Get card type
    /// Card number validation is not perfroms here
    public var type: CreditCardType? {
        types.first { type in
            NSPredicate(format: "SELF MATCHES %@", type.rawValue)
                .evaluate(
                    with: string.numbers
                )
        }
    }
    
    /// Calculation structure
    private struct Calculation {
        let odd, even: Int
        func result() -> Bool {
            (odd + even) % 10 == 0
        }
    }
    
    /// Validate credit card number
    public var isValid: Bool {
        guard let type = type else { return false }
        let isValidLength = type.validNumberLength.contains(string.count)
        return isValidLength && isValid(for: string)
    }
    
    /// Validate card number string for type
    /// - Parameters:
    ///   - string: card number string
    ///   - type: credit card type
    /// - Returns: bool value
    public func isValid(for type: CreditCardType) -> Bool {
        isValid && self.type == type
    }
    
    /// Validate string for credit card type
    /// - Parameters:
    ///   - string: card number string
    /// - Returns: bool value
    private func isValid(for string: String) -> Bool {
        string
            .reversed()
            .compactMap({ Int(String($0)) })
            .enumerated()
            .reduce(Calculation(odd: 0, even: 0), { value, iterator in
                return .init(
                    odd: odd(value: value, iterator: iterator),
                    even: even(value: value, iterator: iterator)
                )
            })
            .result()
    }
    
    private func odd(value: Calculation, iterator: EnumeratedSequence<[Int]>.Element) -> Int {
        iterator.offset % 2 != 0 ? value.odd + (iterator.element / 5 + (2 * iterator.element) % 10) : value.odd
    }

    private func even(value: Calculation, iterator: EnumeratedSequence<[Int]>.Element) -> Int {
        iterator.offset % 2 == 0 ? value.even + iterator.element : value.even
    }
    
}

fileprivate extension String {
 
    var numbers: String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
}
