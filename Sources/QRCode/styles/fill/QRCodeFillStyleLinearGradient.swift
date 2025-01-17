//
//  QRCodeFillStyleLinearGradient.swift
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

import Foundation
import CoreGraphics

public extension QRCode.FillStyle {
	/// A simple linear gradient fill style
	@objc(QRCodeFillStyleLinearGradient)
	class LinearGradient: NSObject, QRCodeFillStyleGenerator {

		@objc public static var Name: String { "lineargradient" }

		/// The gradient
		@objc public let gradient: DSFGradient
		/// linear starting point (0 -> 1)
		@objc public let startPoint: CGPoint
		/// linear ending point (0 -> 1)
		@objc public let endPoint: CGPoint

		/// The current settings for the linear gradient
		@objc public func settings() -> [String: Any] {
			[
				"startX": startPoint.x,
				"startY": startPoint.y,
				"endX": endPoint.x,
				"endY": endPoint.y,
				"gradient": self.gradient.asRGBAGradientString() ?? ""
			]
		}

		/// Create a linear gradient with the specified settings
		@objc public static func Create(settings: [String: Any]) -> QRCodeFillStyleGenerator? {
			if let sX = DoubleValue(settings["startX"]),
				let sY = DoubleValue(settings["startY"]),
				let eX = DoubleValue(settings["endX"]),
				let eY = DoubleValue(settings["endY"]),
				let gs = settings["gradient"] as? String,
				let grad = DSFGradient.FromRGBAGradientString(gs)
			{
				return QRCode.FillStyle.LinearGradient(
					grad,
					startPoint: CGPoint(x: sX, y: sY),
					endPoint: CGPoint(x: eX, y: eY)
				)
			}
			return nil
		}

		/// Fill the specified path/rect with a gradient
		/// - Parameters:
		///   - gradient: The color gradient to use
		///   - startPoint: The fractional position within the fill rect to start the gradient (0.0 -> 1.0)
		///   - endPoint: The fractional position within the fill rect to end the gradient (0.0 -> 1.0)
		@objc public init(
			_ gradient: DSFGradient,
			startPoint: CGPoint = CGPoint(x: 0, y: 0),
			endPoint: CGPoint = CGPoint(x: 1, y: 1)
		) {
			self.gradient = gradient
			self.startPoint = startPoint
			self.endPoint = endPoint
		}

		/// Fill the specified rect with the gradient
		public func fill(ctx: CGContext, rect: CGRect) {
			ctx.drawLinearGradient(
				self.gradient.cgGradient,
				start: self.gradientStartPt(forSize: rect.width),
				end: self.gradientEndPt(forSize: rect.width),
				options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
		}

		/// Fill the specified path with the gradient
		public func fill(ctx: CGContext, rect: CGRect, path: CGPath) {
			ctx.addPath(path)
			ctx.clip()
			ctx.drawLinearGradient(
				self.gradient.cgGradient,
				start: self.gradientStartPt(forSize: rect.width),
				end: self.gradientEndPt(forSize: rect.width),
				options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
		}

		/// Create a copy of the style
		public func copyStyle() -> QRCodeFillStyleGenerator {
			return LinearGradient(
				self.gradient.copyGradient(),
				startPoint: self.startPoint,
				endPoint: self.endPoint)
		}

		private func gradientStartPt(forSize: CGFloat) -> CGPoint {
			return CGPoint(x: self.startPoint.x * forSize, y: self.startPoint.y * forSize)
		}

		private func gradientEndPt(forSize: CGFloat) -> CGPoint {
			return CGPoint(x: self.endPoint.x * forSize, y: self.endPoint.y * forSize)
		}
	}
}

// MARK: - SwiftUI conformances

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 11, iOS 14, tvOS 14, watchOS 7.0, *)
public extension QRCode.FillStyle.LinearGradient {
	/// Returns a SwiftUI LinearGradient for this fill style
	func linearGradient() -> LinearGradient {
		let stops: [Gradient.Stop] = self.gradient.pins
			.map { $0.gradientStop }
			.sorted { a, b in a.location < b.location }
		return LinearGradient(
			stops: stops,
			startPoint: UnitPoint(x: self.startPoint.x, y: self.startPoint.y),
			endPoint: UnitPoint(x: self.endPoint.x, y: self.endPoint.y)
		)
	}
}
#endif
