//
//  QRCodeShape.swift
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

// SwiftUI Shape implementation

import SwiftUI

/// A QRCode SwiftUI `Shape` object for generating a shape path from component(s) of the QR Code.
@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public struct QRCodeShape: Shape {
	/// Create a QRCode shape using the specified data
	/// - Parameters:
	///   - data: The data to contain within the QR Code
	///   - errorCorrection: The error correction level
	///   - components: The components of the QR Code to include within the Shape path
	///   - shape: The shape object to describle the style of the generated path
	///   - generator: The generator to use when creating the Shape path
	public init(
		data: Data,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		generator: QRCodeEngine? = nil
	) {
		self.data__ = data
		self.errorCorrection__ = errorCorrection
		self.components__ = components
		self.shape__ = shape
		if let g = generator {
			self.qrCodeGenerator__.generator = g
		}
		self.qrCodeGenerator__.update(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode shape using the specified text
	/// - Parameters:
	///   - text: The text content to contain within the QR Code
	///   - errorCorrection: The error correction level
	///   - components: The components of the QR Code to include within the Shape path
	///   - shape: The shape object to describle the style of the generated path
	///   - generator: The generator to use when creating the Shape path
	public init?(
		text: String,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		generator: QRCodeEngine? = nil
	) {
		guard let data = text.data(using: .utf8) else { return nil }
		self.data__ = data
		self.errorCorrection__ = errorCorrection
		self.components__ = components
		self.shape__ = shape
		if let g = generator {
			self.qrCodeGenerator__.generator = g
		}
		self.qrCodeGenerator__.update(data, errorCorrection: errorCorrection)
	}

	/// Create a QRCode shape using the specified message formatter
	/// - Parameters:
	///   - message: The message formatter for generating the content to be contained within the QR Code
	///   - errorCorrection: The error correction level
	///   - components: The components of the QR Code to include within the Shape path
	///   - shape: The shape object to describle the style of the generated path
	///   - generator: The generator to use when creating the Shape path
	public init(
		message: QRCodeMessageFormatter,
		errorCorrection: QRCode.ErrorCorrection = .low,
		components: QRCode.Components = .all,
		shape: QRCode.Shape = QRCode.Shape(),
		generator: QRCodeEngine? = nil
	) {
		self.data__ = message.data
		self.errorCorrection__ = errorCorrection
		self.components__ = components
		self.shape__ = shape
		if let g = generator {
			self.qrCodeGenerator__.generator = g
		}
		self.qrCodeGenerator__.update(self.data__, errorCorrection: errorCorrection)
	}

	// Private
	private let data__: Data
	private let shape__: QRCode.Shape
	private let components__: QRCode.Components
	private let errorCorrection__: QRCode.ErrorCorrection
	private let qrCodeGenerator__ = QRCode()
}

// MARK: - Modifiers

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension QRCodeShape {
	/// Returns a copy of the qrcode using the specified error correction level
	func errorCorrection(_ errorCorrection: QRCode.ErrorCorrection) -> QRCodeShape {
		return QRCodeShape(
			data: self.data__,
			errorCorrection: errorCorrection,
			components: self.components__,
			shape: self.shape__.copyShape(),
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Returns a copy of the qrcode using only the specified components being generated.
	func components(_ components: QRCode.Components) -> QRCodeShape {
		return QRCodeShape(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: components,
			shape: self.shape__.copyShape(),
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Returns a copy of the qrcode Shape using the specified QRCode shape object
	func shape(_ shape: QRCode.Shape) -> QRCodeShape {
		return QRCodeShape(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape.copyShape(),
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Change the 'on' pixel shape
	func onPixelShape(_ pixelShape: QRCodePixelShapeGenerator) -> QRCodeShape {
		let shape = self.shape__.copyShape()
		shape.onPixels = pixelShape
		return QRCodeShape(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Change the 'off' pixel shape
	func offPixelShape(_ pixelShape: QRCodePixelShapeGenerator) -> QRCodeShape {
		let shape = self.shape__.copyShape()
		shape.offPixels = pixelShape
		return QRCodeShape(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Change the eye shape to another shape
	func eyeShape(_ eyeShape: QRCodeEyeShapeGenerator) -> QRCodeShape {
		let shape = self.shape__.copyShape()
		shape.eye = eyeShape
		return QRCodeShape(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			generator: self.qrCodeGenerator__.generator
		)
	}

	/// Change the shape of the pupil in the shape
	func pupilShape(_ pupilShape: QRCodePupilShapeGenerator) -> QRCodeShape {
		let shape = self.shape__.copyShape()
		shape.pupil = pupilShape
		return QRCodeShape(
			data: self.data__,
			errorCorrection: self.errorCorrection__,
			components: self.components__,
			shape: shape,
			generator: self.qrCodeGenerator__.generator
		)
	}
}

// MARK: - Deprecated

@available(macOS 11, iOS 13.0, tvOS 13.0, *)
public extension QRCodeShape {
	/// Deprecated. Use `pixelShape` instead.
	@available(*, deprecated, renamed: "onPixelShape")
	func dataShape(_ dataShape: QRCodePixelShapeGenerator) -> QRCodeShape {
		self.pixelShape(dataShape)
	}

	/// Change the 'on' pixel shape
	@available(*, deprecated, renamed: "onPixelShape")
	@inlinable func pixelShape(_ pixelShape: QRCodePixelShapeGenerator) -> QRCodeShape {
		self.onPixelShape(pixelShape)
	}

	/// Returns a copy of the qrcode using the specified shape (both eye and data)
	@available(*, deprecated, renamed: "shape")
	@inlinable func contentShape(_ shape: QRCode.Shape) -> QRCodeShape {
		self.shape(shape)
	}
}

// MARK: - Paths

@available(macOS 11, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension QRCodeShape {
	/// Returns the path for the qr code
	func path(in rect: CGRect) -> Path {
		let path = self.qrCodeGenerator__.path(rect.size, components: self.components__, shape: self.shape__)
		return Path(path)
	}
}

// MARK: - Previews

let DemoContent = "https://goo.gl/maps/Z4d9uVV87gVifrZKA"
let DemoContent2 = "Harness the power of Quartz technology to perform lightweight 2D rendering with high-fidelity output. Handle path-based drawing, antialiased rendering, gradients, images, color management, PDF documents, and more."

// Unfortunately, there is no point in creating more previews as
// XCode refuses to display them either with a compilation error, or with a
// 'fail to send message to helper'.  Grrrr...

@available(macOS 11, iOS 14, tvOS 14, watchOS 6.0, *)
struct QRCodeShape_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			HStack {
				QRCodeShape(text: DemoContent, errorCorrection: .low)!
					.components(.all)
					.onPixelShape(QRCodePixelShapeFactory.shared.named("circle")!)
				QRCodeShape(text: DemoContent2, errorCorrection: .medium)!
			}

			Text("Components")

			VStack {
				HStack {
					VStack {
						QRCodeShape(text: "Hello there how are you", errorCorrection: .low)!
							.components(.onPixels)
						Text("'on' pixels only")
					}
					VStack {
						QRCodeShape(text: "Hello there how are you", errorCorrection: .low)!
							.offPixelShape(QRCode.PixelShape.Square())
							.components(.offPixels)
						Text("'off' pixels only")
					}
				}
				HStack {
					VStack {
						QRCodeShape(text: "Hello there how are you", errorCorrection: .low)!
							.components(.eyeOuter)
						Text("eye outer only")
					}
					VStack {
						QRCodeShape(text: "Hello there how are you", errorCorrection: .low)!
							.components(.eyePupil)
						Text("pupil only")
					}
				}
			}
		}
	}
}
