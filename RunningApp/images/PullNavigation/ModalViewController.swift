
import UIKit

class ModalViewController: UIViewController {
	@IBAction func handleDismissButton(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
		weak var nc = navigationController as? ModalNavigationController
		nc?.handleGesture(sender)
	}
}
