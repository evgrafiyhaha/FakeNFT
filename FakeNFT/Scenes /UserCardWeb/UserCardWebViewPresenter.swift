import Foundation

final class UserCardWebViewPresenter {
    
    weak var delegate: UserCardWebViewController?
    
    let stringURL: String
    
    init(stringURL: String) {
        self.stringURL = stringURL
    }
    
    func loadUserPage() {
        guard let url = URL(string: stringURL) else { return }
        let request = URLRequest(url: url)
        delegate?.userWebView.load(request)
    }
}
