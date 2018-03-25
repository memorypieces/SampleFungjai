//
//  Utilities.swift
//  Dummy
//
//  Created by Numpol Poldongnok on 11/15/16.
//  Copyright © 2016 TrueMoveH. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog
import SnapKit

class Utilities {
    
    
    // MARK: - Helper
    static var topMostController:UIViewController?{
        get {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                return topController
            }
            return nil
        }
    }
    
    static var topMostControllerIgnorePopupDialog:UIViewController?{
        get {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    if presentedViewController is PopupDialog {
                        break
                    }else{
                        topController = presentedViewController
                    }
                }
                print("Top Most is Popup Dialog = %@",(topController is PopupDialog ? "true" : "false"))
                return topController
            }
            return nil
        }
    }
}


