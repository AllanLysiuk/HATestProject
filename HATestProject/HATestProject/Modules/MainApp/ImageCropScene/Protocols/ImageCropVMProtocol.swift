import UIKit

protocol ImageCropVMProtocol {
    func openImagePicker(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    func dismissImagePicker()
    func didFinishPickingMediaWithInfo(_ info: [UIImagePickerController.InfoKey : Any]) -> UIImage?
    func openErrorPopUp(title: String?, message: String?)
    func changeScreenState(to state: ImageCropVCState)
    func setupDelegate(_ delegate: ImageCropVCDelegate)
    func saveImage(image: UIImage, completionTarget: Any, _ selector: Selector)
    func cropImage(imageView: UIImageView, originalImage: UIImage, cropFrame: CGRect) -> UIImage?
    func applyBlackWhiteFilter(to image: UIImage?) -> UIImage?
    func finish()
    
    var screenState: ImageCropVCState { get }
}
