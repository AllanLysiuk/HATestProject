import UIKit

final class CroppingView: UIView {
    
    // MARK: - UI Elements
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        return view
    }()
    
    private let cropReferenceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Properties
    
    private let shapeLayer = CAShapeLayer()
    private let borderLayer = CAShapeLayer()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
        addTransparentLayer()
        addBorderLayer()
    }
    
    // MARK: - Configure UI
    
    private func addSubviews() {
        self.addSubview(overlayView)
        overlayView.addSubview(cropReferenceView)
    }
    
    private func configureLayout() {
        overlayView.frame = self.bounds
        
        let cropWidth: CGFloat = 250
        let cropHeight: CGFloat = 400
        cropReferenceView.frame = CGRect(
            x: (overlayView.bounds.width - cropWidth) / 2,
            y: (overlayView.bounds.height - cropHeight) / 2,
            width: cropWidth,
            height: cropHeight
        )
    }
    
    private func addTransparentLayer() {
        shapeLayer.frame = overlayView.bounds
        shapeLayer.fillRule = .evenOdd
        
        let path = UIBezierPath(rect: overlayView.bounds)
        path.append(UIBezierPath(rect: cropReferenceView.frame))
        shapeLayer.path = path.cgPath
        
        overlayView.layer.mask = shapeLayer
    }
    
    private func addBorderLayer() {
        borderLayer.frame = cropReferenceView.frame
        borderLayer.path = UIBezierPath(rect: cropReferenceView.bounds).cgPath
        borderLayer.strokeColor = UIColor.yellow.cgColor
        borderLayer.lineWidth = 10
        borderLayer.fillColor = UIColor.clear.cgColor
        
        overlayView.layer.addSublayer(borderLayer)
    }
    
    // MARK: - Internal methods
    
    func getCropReferenceViewFrame() -> CGRect {
        return cropReferenceView.frame
    }
}
