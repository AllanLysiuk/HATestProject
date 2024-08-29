import UIKit

final class ImageCropViewModel: ImageCropVMProtocol {
    
    private weak var coordinator: ImageCropVCCoordinatorProtocol?
    private var alertFactory: AlertControllerFactoryProtocol
    
    private weak var delegate: ImageCropVCDelegate?
    
    var screenState: ImageCropVCState = .addPhoto
    
    init(
        coordinator: ImageCropVCCoordinatorProtocol,
        alertFactory: AlertControllerFactoryProtocol
    ) {
        self.coordinator = coordinator
        self.alertFactory = alertFactory
    }
    
    func finish() {
        coordinator?.finish()
    }
    
    func openImagePicker(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        coordinator?.openImagePicker(delegate)
    }
    
    func dismissImagePicker() {
        coordinator?.dismissImagePicker()
    }
    
    func didFinishPickingMediaWithInfo(_ info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        return info[.originalImage] as? UIImage
    }
    
    func openErrorPopUp(title: String?, message: String?) {
        let alert = alertFactory.makeAlert(
            title: title,
            message: message,
            actions: [
                .default("Ок", nil)
            ]
        )
        coordinator?.openErrorPopUp(alert)
    }
    
    func changeScreenState(to state: ImageCropVCState) {
        self.screenState = state
        delegate?.screenStateDidChange()
    }
    
    func setupDelegate(_ delegate: ImageCropVCDelegate) {
        self.delegate = delegate
    }
    
    func saveImage(image: UIImage, completionTarget: Any, _ selector: Selector) {
        UIImageWriteToSavedPhotosAlbum(image, completionTarget, selector, nil)
    }
    
    func cropImage(imageView: UIImageView, originalImage: UIImage, cropFrame: CGRect) -> UIImage? {
        let scale = sqrt(pow(imageView.transform.b, 2) + pow(imageView.transform.d, 2))
        let angle = atan2f(Float(imageView.transform.b), Float(imageView.transform.a))
        
        let rect = CGRect(
            x: (cropFrame.origin.x - imageView.frame.origin.x) / scale,
            y: (cropFrame.origin.y - imageView.frame.origin.y) / scale,
            width: cropFrame.width / scale,
            height: cropFrame.height / scale
        )
        
        var minY = min(sinf(angle) * Float(originalImage.size.width), cosf(angle) * Float(originalImage.size.height))
        minY = min(minY, .zero)
        
        let minX = min(-sinf(angle) * Float(originalImage.size.height), .zero)
        
        let absAngle = abs(angle)
        let rotatedImageRect = CGRect(
            x: CGFloat(minX),
            y: CGFloat(minY),
            width: CGFloat(sinf(absAngle) * Float(originalImage.size.height) + cosf(absAngle) * Float(originalImage.size.width)),
            height: CGFloat(sinf(absAngle) * Float(originalImage.size.width) + cosf(absAngle) * Float(originalImage.size.height))
        )
        
        UIGraphicsBeginImageContextWithOptions(
            CGSize(
                width: rect.size.width,
                height: rect.size.height
            ),
            true,
            0.0
        )
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(
            x: -rotatedImageRect.origin.x,
            y: -rotatedImageRect.origin.y
        )
        context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        context.rotate(by: CGFloat(angle))
        
        originalImage.draw(at: .zero)
        
        var croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
    
    func applyBlackWhiteFilter(to image: UIImage?) -> UIImage? {
        guard let currentCGImage = image?.cgImage else { return nil }
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")

        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return nil }

        let ciContext = CIContext()

        if let cgimg = ciContext.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        
        return nil
    }
}
