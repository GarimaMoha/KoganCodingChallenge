import UIKit

final class ViewController: UIViewController {
    
    private let viewModel = ViewModel()
    private var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        viewModel.delegate = self
        viewModel.fetchData(uri: Constants.uri)
    }
}

extension ViewController: ServiceDelegate {
    func didLoad(viewModel: ViewModel) {
        DispatchQueue.main.async {
            self.label.text = viewModel.text
        }
    }
    
    func didFail(viewModel: ViewModel) {
        DispatchQueue.main.async {
            self.label.text = viewModel.text
        }
    }
    
    func didSucceed(viewModel: ViewModel) {
        DispatchQueue.main.async {
            self.label.text = viewModel.text
        }
    }
}
