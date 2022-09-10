//
//  AlertVC.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit
import ProHUD

class AlertVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        header.titleLabel.text = "ProHUD.Alert"
        header.detailLabel.text = "弹窗控件，用于强阻塞性交互，用户必须做出选择或者等待结果才能进入下一步，当多个实例出现时，会以堆叠的形式显示，新的实例会在覆盖旧的实例上层。"
        
        Alert.Configuration.shared { config in
            config.reloadData { vc in
                if vc.identifier == "custom" {
                    return true
                }
                return false
            }
        }
        
        list.add(title: "纯文字") { section in
            section.add(title: "只有一句话") {
                Alert(.message("只有一句话").duration(2)).push()
            }
            section.add(title: "标题 + 正文") {
                let title = "这是标题"
                let message = "这是正文，文字支持自动换行，可设置最小宽度和最大宽度。这个弹窗将会持续4秒。"
                Alert { alert in
                    alert.vm = .text(title: title, message: message)
                    alert.vm.duration = 4
                }
            }
        }
        
        list.add(title: "图文弹窗") { section in
            section.add(title: "纯图标") {
                Alert(.loading(3)).push()
            }
            section.add(title: "图标 + 文字") {
                Alert(.loading(4).message("正在加载")) { alert in
                    alert.update(progress: 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        alert.update(progress: 0.01)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        alert.update(progress: 0.33)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        alert.update(progress: 0.67)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        alert.update(progress: 1)
                    }
                }
            }
            section.add(title: "图标 + 标题 + 正文") {
                Alert(.error) { alert in
                    alert.vm.title = "加载失败"
                    alert.vm.message = "请稍后重试"
                    alert.vm.duration = 3
                }
            }
        }
        list.add(title: "文字 + 按钮") { section in
            section.add(title: "只有一段文字 + 按钮") {
                Alert { alert in
                    alert.vm.title = "只有一段文字"
                    alert.add(action: "取消", style: .gray)
                    alert.add(action: "默认按钮")
                }
            }
            section.add(title: "标题 + 正文 + 按钮") {
                Alert { alert in
                    alert.vm.title = "标题"
                    alert.vm.message = "这是一段正文，长度超出最大宽度时会自动换行"
                    alert.add(action: "取消", style: .gray)
                    alert.add(action: "删除", style: .destructive) { alert in
                        // 自定义了按钮事件之后，需要手动pop弹窗
                        alert.pop()
                    }
                }
            }
        }
        list.add(title: "图标 + 文字 + 按钮") { section in
            section.add(title: "图标 + 一段文字 + 自定义浅色按钮") {
                Alert(.confirm) { alert in
                    alert.vm.title = "自定义浅色按钮"
                    alert.add(action: "红色", style: .light(color: .systemRed))
                    alert.add(action: "蓝色", style: .light(color: .systemBlue))
                }
            }
            section.add(title: "图标 + 标题 + 正文 + 自定义深色按钮") {
                Alert(.note) { alert in
                    alert.vm.title = "自定义深色按钮"
                    alert.vm.message = "这是一段正文，长度超出最大宽度时会自动换行"
                    alert.add(action: "橙色", style: .filled(color: .systemOrange))
                    alert.add(action: "粉色", style: .filled(color: .systemPink))
                    alert.add(action: "默认灰色", style: .gray)
                }
            }
        }
        list.add(title: "控件管理") { section in
            section.add(title: "按钮增删改查") {
                Alert(.note) { alert in
                    alert.vm.message = "可以动态增加、删除按钮"
                    alert.add(action: "在底部增加按钮", style: .filled(color: .systemGreen)) { alert in
                        alert.add(action: "哈哈1", identifier: "haha1")
                    }
                    alert.add(action: "在当前按钮下方增加", style: .filled(color: .systemIndigo), identifier: "add") { alert in
                        alert.insert(action: .init(identifier: "haha2", style: .light(color: .systemOrange), title: "哈哈2", handler: nil), after: "add")
                    }
                    alert.add(action: "修改当前按钮文字", identifier: "edit") { alert in
                        alert.update(action: "已修改", for: "edit")
                    }
                    alert.add(action: "删除「哈哈1」", style: .destructive) { alert in
                        alert.remove(actions: .identifiers("haha1"))
                    }
                    alert.add(action: "删除「哈哈1」和「哈哈2」", style: .destructive) { alert in
                        alert.remove(actions: .identifiers("haha1", "haha2"))
                    }
                    alert.add(action: "删除全部按钮", style: .destructive) { alert in
                        alert.remove(actions: .all)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            alert.pop()
                        }
                    }
                    alert.add(action: "取消", style: .gray)
                }
            }
            section.add(title: "更新文字") {
                Alert(.note) { alert in
                    alert.vm.message = "可以动态增加、删除、更新文字"
                    alert.add(action: "增加标题") { alert in
                        alert.vm.title = "这是标题"
                        alert.reloadTextStack()
                    }
                    alert.add(action: "增加正文") { alert in
                        alert.vm.message = "可以动态增加、删除、更新文字"
                        alert.reloadTextStack()
                    }
                    alert.add(action: "删除标题", style: .destructive) { alert in
                        alert.vm.title = nil
                        alert.reloadTextStack()
                    }
                    alert.add(action: "删除正文", style: .destructive) { alert in
                        alert.vm.message = nil
                        alert.reloadTextStack()
                    }
                    alert.add(action: "取消", style: .gray)
                }
            }
            section.add(title: "在弹出过程中增加元素") {
                Alert(.loading) { alert in
                    alert.vm.title = "在弹出过程中增加元素"
                    alert.add(action: "OK", style: .gray)
                    alert.config.actionAxis = .vertical
                } .onViewWillAppear { vc in
                    guard let alert = vc as? Alert else {
                        return
                    }
                    alert.vm.message = "这是一段后增加的文字\n动画效果会有细微差别"
                    alert.reloadTextStack()
                }
            }
        }
        list.add(title: "实例管理") { section in
            section.add(title: "多层级弹窗") {
                func f(i: Int) {
                    Alert { alert in
                        alert.vm.title = "第\(i)次弹"
                        alert.vm.message = "每次都是一个新的实例覆盖在上一个弹窗上面，而背景不会叠加变深。"
                        alert.add(action: "取消", style: .gray)
                        alert.add(action: "增加一个") { alert in
                            f(i: i + 1)
                        }
                    }
                }
                f(i: 1)
            }
            section.add(title: "弹出loading，如果已经存在就更新") {
                func f(i: Int) {
                    Alert.lazyPush(identifier: "haha") { alert in
                        if i < 2 {
                            alert.vm = .loading.title("第\(i)次弹")
                            let btn = alert.add(action: "请稍等", identifier: "btn")
                            btn.isEnabled = false
                        } else {
                            alert.update(progress: 1)
                            alert.vm = .success.title("第\(i)次弹").message("只更新内容")
                            alert.reloadTextStack()
                            alert.update(action: "完成", style: .filled(color: .systemGreen), for: "btn")
                            alert.button(for: "btn")?.isEnabled = true
                        }
                    }
                }
                f(i: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    f(i: 2)
                }
            }
        }
        list.add(title: "放在特定页面") { [weak self] section in
            section.add(title: "放在一个VC中") {
                let vc = UIViewController()
                vc.title = "页面"
                vc.view.backgroundColor = .systemYellow
                let alert = Alert(.loading.title("正在加载").message("这个弹窗被放在指定的容器中"))
                alert.config.enableShadow = false
                self?.present(vc, animated: true)
                vc.view.addSubview(alert.view)
                alert.view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
        list.add(title: "自定义视图") { section in
            section.add(title: "自定义控件") {
                Alert { alert in
                    alert.vm.title = "自定义控件"
                    // 图片
                    let imgv = UIImageView(image: UIImage(named: "landscape"))
                    imgv.contentMode = .scaleAspectFill
                    imgv.clipsToBounds = true
                    imgv.layer.cornerRadiusWithContinuous = 12
                    alert.add(subview: imgv).snp.makeConstraints { make in
                        make.height.equalTo(120)
                    }
                    // seg
                    let seg = UISegmentedControl(items: ["开发", "测试", "预发", "生产"])
                    seg.selectedSegmentIndex = 0
                    alert.add(subview: seg).snp.makeConstraints { make in
                        make.height.equalTo(40)
                        make.width.equalTo(400)
                    }
                    // slider
                    let slider = UISlider()
                    slider.minimumValue = 0
                    slider.maximumValue = 100
                    slider.value = 50
                    alert.add(subview: slider)
                    alert.add(spacing: 24)
                    alert.add(action: "取消", style: .gray)
                }
            }
            
            section.add(title: "圆角半径") {
                Alert { alert in
                    alert.title = "圆角半径"
                    let s1 = UISlider()
                    s1.minimumValue = 0
                    s1.maximumValue = 40
                    s1.value = Float(alert.config.cardCornerRadius ?? 16)
                    alert.add(subview: s1).snp.makeConstraints { make in
                        make.height.equalTo(50)
                    }
                    if #available(iOS 14.0, *) {
                        s1.addAction(.init(handler: { [unowned s1] act in
                            alert.config.cardCornerRadius = CGFloat(s1.value)
                            alert.contentView.layer.cornerRadiusWithContinuous = alert.config.cardCornerRadius ?? 16
                        }), for: .valueChanged)
                    } else {
                        // Fallback on earlier versions
                    }
                    alert.config.actionAxis = .vertical
                    alert.add(spacing: 24)
                    alert.add(action: "OK", style: .gray)
                }
            }
            
            section.add(title: "完全自定义容器") {
                Alert { alert in
                    alert.identifier = "custom"
                    alert.contentView.backgroundColor = .systemYellow
                    alert.view.addSubview(alert.contentView)
                    alert.contentView.layer.cornerRadiusWithContinuous = 32
                    alert.contentView.snp.makeConstraints { make in
                        make.width.equalTo(UIScreen.main.bounds.width - 100)
                        make.height.equalTo(UIScreen.main.bounds.height - 200)
                        make.center.equalToSuperview()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        alert.pop()
                    }
                }
            }
        }
    }

}
