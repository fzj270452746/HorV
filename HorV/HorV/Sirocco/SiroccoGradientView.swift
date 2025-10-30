import UIKit

final class SiroccoGradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        install()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        install()
    }

    private func install() {
        // Desert dusk to oasis teal gradient
        gradientLayer.colors = [
            UIColor(red: 0.06, green: 0.05, blue: 0.05, alpha: 1).cgColor,
            UIColor(red: 0.36, green: 0.27, blue: 0.16, alpha: 1).cgColor,
            UIColor(red: 0.06, green: 0.27, blue: 0.24, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0.0, 0.55, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}


