//
//  QRCodePixelShapeRoundedRect.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import CoreGraphics
import Foundation

public extension QRCode.PixelShape {
	/// A rounded rect pixel shape
	@objc(QRCodePixelShapeRoundedRect) class RoundedRect: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "roundedRect"

		/// Create
		/// - Parameters:
		///   - insetFraction: The inset between each pixel
		///   - cornerRadiusFraction: For types that support it, the roundedness of the corners (0 -> 1)
		@objc public init(insetFraction: CGFloat = 0, cornerRadiusFraction: CGFloat = 0) {
			self.common = CommonPixelGenerator(pixelType: .roundedRect, insetFraction: insetFraction, cornerRadiusFraction: cornerRadiusFraction)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			let insetFraction = DoubleValue(settings?[QRCode.SettingsKey.insetFraction, default: 0]) ?? 0
			let radius = DoubleValue(settings?[QRCode.SettingsKey.cornerRadiusFraction]) ?? 0
			return RoundedRect(insetFraction: insetFraction, cornerRadiusFraction: radius)
		}

		/// Make a copy of the object
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return RoundedRect(insetFraction: self.common.insetFraction, cornerRadiusFraction: self.common.cornerRadiusFraction)
		}
		
		public func onPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			self.common.onPath(size: size, data: data, isTemplate: isTemplate)
		}
		
		public func offPath(size: CGSize, data: QRCode, isTemplate: Bool) -> CGPath {
			self.common.offPath(size: size, data: data, isTemplate: isTemplate)
		}

		/// The fractional corner radius for the pixel
		@objc public var cornerRadiusFraction: CGFloat { self.common.cornerRadiusFraction }

		/// The fractional inset for the pixel
		@objc public var insetFraction: CGFloat { self.common.insetFraction }

		private let common: CommonPixelGenerator
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.RoundedRect {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == QRCode.SettingsKey.insetFraction
			 || key == QRCode.SettingsKey.cornerRadiusFraction
	}
	
	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] {
		return [
			QRCode.SettingsKey.insetFraction: self.common.insetFraction,
			QRCode.SettingsKey.cornerRadiusFraction: self.common.cornerRadiusFraction,
		]
	}
	
	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.insetFraction {
			guard let v = value else {
				self.common.insetFraction = 0
				return true
			}
			guard let v = DoubleValue(v) else { return false }
			self.common.insetFraction = v
			return true
		}
		else if key == QRCode.SettingsKey.cornerRadiusFraction {
			guard let v = value else {
				self.common.cornerRadiusFraction = 0
				return true
			}
			guard let v = DoubleValue(v) else { return false }
			self.common.cornerRadiusFraction = v
			return true
		}
		return false
	}
}
