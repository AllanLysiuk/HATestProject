import UIKit

protocol ImageCropVCCoordinatorProtocol: AnyObject {
    func openImagePicker(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    func dismissImagePicker()
    func openErrorPopUp(_ alert: UIAlertController)
    func finish()
}
