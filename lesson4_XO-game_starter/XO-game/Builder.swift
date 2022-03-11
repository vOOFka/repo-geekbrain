//
//  Builder.swift
//  XO-game
//
//  Created by Stanislav Belykh on 09.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

struct Builder {

	private(set) var param1: String
	private(set) var param2: String

	func addParam1(_ param: String) -> Self {
		return Builder(param1: param, param2: self.param2)
	}

	func addParam2(_ param: String) -> Self {
		return Builder(param1: self.param1, param2: param)
	}
}
