//
//  Common.swift
//  Fungjai
//
//  Created by BSD_MAC_Pro2 on 25/3/18.
//  Copyright © 2018 BSD_MAC_Pro2. All rights reserved.
//

import Foundation
import UIKit

var SCREEN_WIDTH: CGFloat { get { return UIScreen.main.bounds.size.width } }
var SCREEN_HEIGHT: CGFloat { get { return UIScreen.main.bounds.size.height } }
let SCREEN_MAX_LENGTH : CGFloat = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH : CGFloat = min(SCREEN_WIDTH, SCREEN_HEIGHT)
