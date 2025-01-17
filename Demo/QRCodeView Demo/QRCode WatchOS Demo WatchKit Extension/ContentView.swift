//
//  ContentView.swift
//  QRCode WatchOS Demo WatchKit Extension
//
//  Created by Darren Ford on 10/12/21.
//

import SwiftUI

import QRCode
import QRCodeExternal

struct ContentView: View {
	let fixedCode = QRCodeShape(
		text: "QRCode WatchOS Demo",
		errorCorrection: .quantize,
		generator: QRCodeGenerator_External())!

	@State var number: CGFloat = 0

	var dataColor: Color = Color(red: 1.0, green: 1.0, blue: 0.5)
	var eyeColor: Color = .yellow
	var pupilColor: Color = Color(red: 1.0, green: 0.8, blue: 0.3)

	var body: some View {

		let c = Color(hue: number, saturation: 1.0, brightness: 1)

		ZStack {
			fixedCode
				.components(.eyeOuter)
				.eyeShape(QRCode.EyeShape.RoundedOuter())
				.fill(eyeColor)
			fixedCode
				.components(.eyePupil)
				.eyeShape(QRCode.EyeShape.RoundedOuter())
				.fill(pupilColor)
			fixedCode
				.components(.onPixels)
				.onPixelShape(QRCode.PixelShape.RoundedPath())
				.fill(c)
		}
		.padding()
		.background(Color(red: 0.0, green: 0.0, blue: 0.2, opacity: 1.0))
		.focusable()
		.digitalCrownRotation(
			$number,
			from: 0.0,
			through: 1.0,
			sensitivity: .low,
			isContinuous: true
		)
		//.onChange(of: number) { print($0) }
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
