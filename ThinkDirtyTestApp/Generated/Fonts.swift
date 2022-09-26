
import SwiftUI

extension Font {
   static func resagokr(_ style: ResagokrStyle, fixedSize: CGFloat) -> Font {
    return Font.custom(style.rawValue, fixedSize: fixedSize)
  }

   static func resagokr(_ style: ResagokrStyle, size: CGFloat, relativeTo textStyle: TextStyle = .body) -> Font {
    return Font.custom(style.rawValue, size: size, relativeTo: textStyle)
  }

   enum ResagokrStyle: String {
    case regular = "Resagokr"
    case bold = "ResagokrBold"
    case light = "ResagokrLight"
  }
}
