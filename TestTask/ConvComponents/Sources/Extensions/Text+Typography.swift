import SwiftUI

public extension ButtonStyleConfiguration.Label {
    func typographyStyle(_ style: TypographyStyle) -> some View {
        font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
    }
}

public extension Toggle {
    func typographyStyle(_ style: TypographyStyle) -> some View {
        font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
    }
}

public extension Text {
    func typographyStyle(_ style: TypographyStyle) -> some View {
        font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
    }
}

public extension TextField {
    func typographyStyle(_ style: TypographyStyle) -> some View {
        font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
    }
}

public extension SecureField {
    func typographyStyle(_ style: TypographyStyle) -> some View {
        font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
    }
}

public extension TextEditor {
    func typographyStyle(_ style: TypographyStyle) -> some View {
        font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
    }
}

public extension Button {
    func typographyStyle(_ style: TypographyStyle) -> some View {
        font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
    }
}

public struct TypographyStyle {
    public let fontConvertible: ConvComponentsFontConvertible
    public let fontSize: CGFloat
    public let kerning: CGFloat
    public let desiredLineHeight: CGFloat

    public var font: Font { fontConvertible.swiftUIFont(size: fontSize) }
    public var lineSpacing: CGFloat {
        let originalLineHeight = fontConvertible.font(size: fontSize).lineHeight
        return desiredLineHeight - originalLineHeight
    }

    public static let style32Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 32.0,
        kerning: -0.1,
        desiredLineHeight: 39
    )

    public static let style30Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 30.0,
        kerning: -0.1,
        desiredLineHeight: 36
    )

    public static let style24Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 24.0,
        kerning: -0.1,
        desiredLineHeight: 29
    )

    public static let style20Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.semiBold,
        fontSize: 20.0,
        kerning: -0.1,
        desiredLineHeight: 24
    )

    public static let style20Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 20.0,
        kerning: 0.0,
        desiredLineHeight: 24
    )

    public static let style20Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.regular,
        fontSize: 20.0,
        kerning: 0.0,
        desiredLineHeight: 24
    )

    public static let style18Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 18.0,
        kerning: -0.1,
        desiredLineHeight: 22
    )

    public static let style18Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.semiBold,
        fontSize: 18.0,
        kerning: 0.3,
        desiredLineHeight: 22
    )

    public static let style16Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.regular,
        fontSize: 16.0,
        kerning: -0.2,
        desiredLineHeight: 20
    )

    public static let style16Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 16.0,
        kerning: -0.1,
        desiredLineHeight: 20
    )

    public static let style15Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.regular,
        fontSize: 15.0,
        kerning: -0.2,
        desiredLineHeight: 18
    )

    public static let style15Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 15.0,
        kerning: -0.2,
        desiredLineHeight: 18
    )

    public static let style14Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.regular,
        fontSize: 14.0,
        kerning: -0.1,
        desiredLineHeight: 17
    )

    public static let style14Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 14.0,
        kerning: -0.1,
        desiredLineHeight: 17
    )

    public static let style14Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.semiBold,
        fontSize: 14.0,
        kerning: 0.3,
        desiredLineHeight: 17
    )

    public static let style13Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.regular,
        fontSize: 13.0,
        kerning: -0.1,
        desiredLineHeight: 16
    )

    public static let style13Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 13.0,
        kerning: -0.1,
        desiredLineHeight: 16
    )

    public static let style13Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.semiBold,
        fontSize: 13.0,
        kerning: 0.1,
        desiredLineHeight: 16
    )

    public static let style12Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.regular,
        fontSize: 12.0,
        kerning: -0.1,
        desiredLineHeight: 15
    )

    public static let style12Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 12.0,
        kerning: -0.1,
        desiredLineHeight: 15
    )

    public static let style12Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.semiBold,
        fontSize: 12.0,
        kerning: 0.2,
        desiredLineHeight: 15
    )

    public static let style11Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 11.0,
        kerning: 0.0,
        desiredLineHeight: 13
    )

    public static let style10Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.medium,
        fontSize: 10.0,
        kerning: 0.2,
        desiredLineHeight: 12
    )

    public static let style10Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Inter.semiBold,
        fontSize: 10.0,
        kerning: 0.3,
        desiredLineHeight: 12
    )

    // Headings
    
    public static let heading32Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.medium,
        fontSize: 32.0,
        kerning: 0.0,
        desiredLineHeight: 38
    )
    
    public static let heading20Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 20.0,
        kerning: 0.0,
        desiredLineHeight: 27
    )

    public static let heading17Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 17.0,
        kerning: 0.0,
        desiredLineHeight: 22
    )

    public static let heading24Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 24.0,
        kerning: 0.0,
        desiredLineHeight: 31
    )

    public static let heading18Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 18.0,
        kerning: 0.0,
        desiredLineHeight: 24
    )

    public static let heading18Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.regular,
        fontSize: 18.0,
        kerning: 0.0,
        desiredLineHeight: 25
    )

    public static let heading16Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 16.0,
        kerning: 0.3,
        desiredLineHeight: 22
    )

    public static let heading16Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.medium,
        fontSize: 16.0,
        kerning: 0.3,
        desiredLineHeight: 22
    )

    public static let heading15Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.medium,
        fontSize: 15.0,
        kerning: 0.4,
        desiredLineHeight: 20
    )

    public static let heading15Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.regular,
        fontSize: 15.0,
        kerning: 0.3,
        desiredLineHeight: 20
    )

    public static let heading14Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 14.0,
        kerning: 0.0,
        desiredLineHeight: 16
    )

    public static let heading14Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.medium,
        fontSize: 14.0,
        kerning: 0.0,
        desiredLineHeight: 16
    )

    public static let heading12Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.medium,
        fontSize: 12.0,
        kerning: 0.3,
        desiredLineHeight: 18
    )

    // Body
    public static let body16Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.regular,
        fontSize: 16.0,
        kerning: 0.2,
        desiredLineHeight: 22
    )

    // Button Text
    public static let button13Bold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.bold,
        fontSize: 13.0,
        kerning: 0.3,
        desiredLineHeight: 15
    )

    // Nav Bar
    public static let navBar15Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 15.0,
        kerning: 0.0,
        desiredLineHeight: 20
    )

    // Tag
    public static let tag11Bold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.bold,
        fontSize: 11.0,
        kerning: 0.3,
        desiredLineHeight: 15
    )

    public static let heading24Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 24.0,
        kerning: 0.0,
        desiredLineHeight: 27
    )
    public static let heading22Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 22.0,
        kerning: 0.2,
        desiredLineHeight: 27
    )
    public static let heading20Semibold28 = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 20.0,
        kerning: 0.0,
        desiredLineHeight: 28
    )
    public static let heading18Semibold24 = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 18.0,
        kerning: 0.0,
        desiredLineHeight: 24
    )
    public static let heading16Medium22 = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.medium,
        fontSize: 16.0,
        kerning: 0.3,
        desiredLineHeight: 22
    )
    public static let heading15Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 15.0,
        kerning: 0.3,
        desiredLineHeight: 20
    )
    public static let heading15Medium20 = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.medium,
        fontSize: 15.0,
        kerning: 0.3,
        desiredLineHeight: 20
    )
    public static let heading14Semibold16 = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 14.0,
        kerning: 0.0,
        desiredLineHeight: 16
    )
    public static let heading14Medium16 = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.medium,
        fontSize: 14.0,
        kerning: 0.0,
        desiredLineHeight: 16
    )
    public static let body15Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.regular,
        fontSize: 15.0,
        kerning: 0.3,
        desiredLineHeight: 20
    )
    public static let button17Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 17.0,
        kerning: -0.2,
        desiredLineHeight: 22
    )
    public static let body20Regular27 = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.regular,
        fontSize: 20.0,
        kerning: 0.2,
        desiredLineHeight: 27
    )
    public static let numberInput20Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.regular,
        fontSize: 20.0,
        kerning: 2.0,
        desiredLineHeight: 27
    )
    public static let body17Regular = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.regular,
        fontSize: 17.0,
        kerning: 0.0,
        desiredLineHeight: 20
    )
    public static let error11Medium = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.medium,
        fontSize: 11.0,
        kerning: 0.2,
        desiredLineHeight: 16
    )
    public static let tabBar10Semibold = TypographyStyle(
        fontConvertible: ConvComponentsFontFamily.Manrope.semiBold,
        fontSize: 10.0,
        kerning: 0.1,
        desiredLineHeight: 12
    )
}
