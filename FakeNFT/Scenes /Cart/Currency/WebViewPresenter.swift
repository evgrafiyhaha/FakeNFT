import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)

}

final class WebViewPresenter: WebViewPresenterProtocol {

    weak var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        guard let url = URL(string: RequestConstants.userAgreementURL) else {
            return
        }
        let request = URLRequest(url: url)

        didUpdateProgressValue(0)

        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

}
