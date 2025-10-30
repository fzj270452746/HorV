//
//  ViewController.swift
//  HorV
//
//  Created by Zhao on 2025/10/22.
//

import UIKit

struct HorVModel {
    var horvimage: UIImage
    var horValueInt: Int
}

// MARK: - Refactored Catalog

enum GlyphConsortium {
    case bamboo
    case dots
    case characters
}

enum TilePantry {
    /// 生成某花色 1~9 的牌组
    static func assemble(prefix: String) -> [HorVModel] {
        (1...9).map { idx in
            HorVModel(horvimage: procureSprite(named: "\(prefix)\(idx)"), horValueInt: idx)
        }
    }

    static let bamboo: [HorVModel] = assemble(prefix: "jitiao")
    static let dots: [HorVModel] = assemble(prefix: "jitong")
    static let characters: [HorVModel] = assemble(prefix: "jiwan")

    /// 根据花色获取整套牌
    static func suite(for consortium: GlyphConsortium) -> [HorVModel] {
        switch consortium {
        case .bamboo: return bamboo
        case .dots: return dots
        case .characters: return characters
        }
    }

    /// 随机抽一张
    static func drawRandom(from consortium: GlyphConsortium) -> HorVModel {
        let kit = suite(for: consortium)
        return kit.randomElement() ?? kit[0]
    }
}

// 安全获取图片，避免强制解包导致崩溃
private func procureSprite(named name: String) -> UIImage {
    if let img = UIImage(named: name) { return img }
    // 生成 1x1 透明占位图，避免运行时崩溃
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
    let placeholder = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    UIGraphicsEndImageContext()
    return placeholder
}

// MARK: - Backward compatible constants (kept for existing call sites)

// t_iaofs (bamboo / jitiao)
let horvJ1 = TilePantry.bamboo[0]
let horvJ2 = TilePantry.bamboo[1]
let horvJ3 = TilePantry.bamboo[2]
let horvJ4 = TilePantry.bamboo[3]
let horvJ5 = TilePantry.bamboo[4]
let horvJ6 = TilePantry.bamboo[5]
let horvJ7 = TilePantry.bamboo[6]
let horvJ8 = TilePantry.bamboo[7]
let horvJ9 = TilePantry.bamboo[8]

// t_ongjh (dots / jitong)
let horvK1 = TilePantry.dots[0]
let horvK2 = TilePantry.dots[1]
let horvK3 = TilePantry.dots[2]
let horvK4 = TilePantry.dots[3]
let horvK5 = TilePantry.dots[4]
let horvK6 = TilePantry.dots[5]
let horvK7 = TilePantry.dots[6]
let horvK8 = TilePantry.dots[7]
let horvK9 = TilePantry.dots[8]

// w_anwr (characters / jiwan)
let horvL1 = TilePantry.characters[0]
let horvL2 = TilePantry.characters[1]
let horvL3 = TilePantry.characters[2]
let horvL4 = TilePantry.characters[3]
let horvL5 = TilePantry.characters[4]
let horvL6 = TilePantry.characters[5]
let horvL7 = TilePantry.characters[6]
let horvL8 = TilePantry.characters[7]
let horvL9 = TilePantry.characters[8]
