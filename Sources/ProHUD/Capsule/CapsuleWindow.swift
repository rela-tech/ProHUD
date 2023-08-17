//
//  CapsuleWindow.swift
//
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

class CapsuleWindow: Window {
    
    var capsule: Capsule
    
    init(capsule: Capsule) {
        self.capsule = capsule
        super.init(frame: .zero)
        windowScene = AppContext.windowScene
        switch capsule.vm.position {
        case .top:
            // 略高于toast
            windowLevel = .phCapsuleTop
        case .middle:
            // 略低于alert
            windowLevel = .phCapsuleMiddle
        case .bottom:
            // 略高于sheet
            windowLevel = .phCapsuleBottom
        }
        frame = .init(x: 0, y: 0, width: 128, height: 48)
        isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Capsule {
    var attachedWindow: CapsuleWindow? {
        view.window as? CapsuleWindow
    }
}
