//
//  ViewModel.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

/// 数据模型
open class ViewModel: NSObject {
    
    /// 图标
    open var icon: UIImage?
    var iconURL: URL?
    
    /// 图标旋转动画
    open var rotation: Rotation?
    
    /// 标题
    open var title: String?
    
    /// 消息正文
    open var message: String?
    
    /// 持续时间（为空代表根据场景不同的默认配置，为0代表无穷大）
    open var duration: TimeInterval? {
        didSet {
            resetTimeoutHandler()
        }
    }
    
    public required override init() {
        
    }
    
    public convenience init(icon: UIImage? = nil, duration: TimeInterval? = nil) {
        self.init()
        self.icon = icon
        self.duration = duration
    }
    
    /// 超时处理
    var timeoutHandler: DispatchWorkItem? {
        didSet {
            resetTimeoutHandler()
        }
    }
    
    var timeoutTimer: Timer?
    
    func resetTimeoutHandler() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
        if let t = duration, t > 0 {
            let timer = Timer(timeInterval: t, repeats: false, block: { [weak self] t in
                self?.timeoutHandler?.perform()
            })
            RunLoop.main.add(timer, forMode: .common)
            timeoutTimer = timer
        }
    }
    
}

// MARK: - convenience func
public extension ViewModel {
    
    func icon(_ image: UIImage?) -> Self {
        self.icon = image
        return self
    }
    
    func icon(_ imageURL: URL?) -> Self {
        self.iconURL = imageURL
        return self
    }
    
    func title(_ text: String?) -> Self {
        self.title = text
        return self
    }
    
    func message(_ text: String?) -> Self {
        self.message = text
        return self
    }
    
    func duration(_ seconds: TimeInterval?) -> Self {
        self.duration = seconds
        return self
    }
    
    func rotation(_ rotation: Rotation?) -> Self {
        self.rotation = rotation
        return self
    }
    
}

// MARK: - example scenes
public extension ViewModel {
    
    // MARK: plain
    static func title(_ text: String?) -> Self {
        .init()
        .title(text)
    }
    static func message(_ text: String?) -> Self {
        .init()
        .message(text)
    }
    
    // MARK: loading
    static var loading: Self {
        .init()
        .icon(.init(inProHUD: "prohud.windmill"))
        .rotation(.init(repeatCount: .infinity))
    }
    static func loading(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(inProHUD: "prohud.windmill"))
        .rotation(.init(repeatCount: .infinity))
        .duration(seconds)
    }
    // MARK: success
    static var success: Self {
        .init()
        .icon(.init(inProHUD: "prohud.checkmark"))
    }
    static func success(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(inProHUD: "prohud.checkmark"))
        .duration(seconds)
    }
    // MARK: warning
    static var warning: Self {
        .init()
        .icon(.init(inProHUD: "prohud.exclamationmark"))
    }
    static func warning(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(inProHUD: "prohud.exclamationmark"))
        .duration(seconds)
    }
    // MARK: error
    static var error: Self {
        .init()
        .icon(.init(inProHUD: "prohud.xmark"))
    }
    static func error(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(inProHUD: "prohud.xmark"))
        .duration(seconds)
    }
    // MARK: failure
    static var failure: Self { error }
    static func failure(_ seconds: TimeInterval) -> Self { error(seconds) }
    
}
