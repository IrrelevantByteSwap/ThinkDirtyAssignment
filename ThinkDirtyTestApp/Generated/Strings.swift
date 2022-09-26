// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import SwiftUI

// MARK: - Strings

public enum L10n {
  /// Ok
  public static let generalOk = LocalizedString(table: "Localizable", lookupKey: "general_ok")
}

// MARK: - Implementation Details
fileprivate func tr(_ table: String, _ key: String, _ locale: Locale = Locale.current, _ args: CVarArg...) -> String {
  let path = Bundle.main.path(forResource: locale.identifier, ofType: "lproj") ?? ""
  let format: String
  if let bundle = Bundle(path: path) {
    format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
  } else {
    format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
  }
  return String(format: format, locale: locale, arguments: args)
}

public struct LocalizedString: Hashable, CustomStringConvertible {
    let table: String
    fileprivate let lookupKey: String
    init(table: String, lookupKey: String) {
        self.table = table
        self.lookupKey = lookupKey
    }
    var key: LocalizedStringKey {
        LocalizedStringKey(lookupKey)
    }
    var text: String {
        tr(table, lookupKey)
    }
    public var description: String {
        return text
    }
    func text(withLocale locale: Locale) -> String {
        tr(table, lookupKey, locale)
    }
}

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
      return Bundle.module
    #else
      return Bundle(for: BundleToken.self)
    #endif
  }()
}
