// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
    import AppKit.NSImage
    internal typealias AssetColorTypeAlias = NSColor
    internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIImage
    internal typealias AssetColorTypeAlias = UIColor
    internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
    internal enum Colors {
        internal static let darkButton = ColorAsset(name: "darkButton")
        internal static let darkButtonText = ColorAsset(name: "darkButtonText")
        internal static let darkSystemButton = ColorAsset(name: "darkSystemButton")
        internal static let darkSystemButtonText = ColorAsset(name: "darkSystemButtonText")
        internal static let lightButton = ColorAsset(name: "lightButton")
        internal static let lightButtonText = ColorAsset(name: "lightButtonText")
        internal static let lightSystemButton = ColorAsset(name: "lightSystemButton")
        internal static let lightSystemButtonText = ColorAsset(name: "lightSystemButtonText")
    }

    internal enum Images {
        internal enum Buttons {
            internal static let backspace = ImageAsset(name: "Buttons/backspace")
            internal static let newline = ImageAsset(name: "Buttons/newline")
            internal static let space = ImageAsset(name: "Buttons/space")
            internal static let switchKeyboard = ImageAsset(name: "Buttons/switchKeyboard")
        }
    }
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
    internal fileprivate(set) var name: String

    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
    internal var color: AssetColorTypeAlias {
        AssetColorTypeAlias(asset: self)
    }
}

internal extension AssetColorTypeAlias {
    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
    convenience init!(asset: ColorAsset) {
        let bundle = Bundle(for: BundleToken.self)
        #if os(iOS) || os(tvOS)
            self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            self.init(named: NSColor.Name(asset.name), bundle: bundle)
        #elseif os(watchOS)
            self.init(named: asset.name)
        #endif
    }
}

internal struct DataAsset {
    internal fileprivate(set) var name: String

    #if os(iOS) || os(tvOS) || os(OSX)
        @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
        internal var data: NSDataAsset {
            NSDataAsset(asset: self)
        }
    #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
    @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
    internal extension NSDataAsset {
        convenience init!(asset: DataAsset) {
            let bundle = Bundle(for: BundleToken.self)
            #if os(iOS) || os(tvOS)
                self.init(name: asset.name, bundle: bundle)
            #elseif os(OSX)
                self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
            #endif
        }
    }
#endif

internal struct ImageAsset {
    internal fileprivate(set) var name: String

    internal var image: AssetImageTypeAlias {
        let bundle = Bundle(for: BundleToken.self)
        #if os(iOS) || os(tvOS)
            let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            let image = bundle.image(forResource: NSImage.Name(name))
        #elseif os(watchOS)
            let image = AssetImageTypeAlias(named: name)
        #endif
        guard let result = image else { fatalError("Unable to load image named \(name).") }
        return result
    }
}

internal extension AssetImageTypeAlias {
    @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
    @available(OSX, deprecated,
               message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
    convenience init!(asset: ImageAsset) {
        #if os(iOS) || os(tvOS)
            let bundle = Bundle(for: BundleToken.self)
            self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            self.init(named: NSImage.Name(asset.name))
        #elseif os(watchOS)
            self.init(named: asset.name)
        #endif
    }
}

private final class BundleToken {}
