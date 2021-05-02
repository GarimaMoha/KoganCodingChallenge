
import Foundation

protocol ServiceDelegate: AnyObject {
    func didLoad(viewModel: ViewModel)
    func didFail(viewModel: ViewModel)
    func didSucceed(viewModel: ViewModel)
}

final class ViewModel {
    
    weak var delegate: ServiceDelegate?
    private var results: [Equipments] = []
    
    enum State: Equatable {
        case none
        case loading
        case success([Equipments])
        case failure
    }
    
    private enum Constants {
        static let categoryName = "Air Conditioners"
        static let conversionFactor = 250.0
    }
    
    func fetchData(service: ServiceCallDelegate = Service(), uri: String) {
        self.state = .loading
        service.makeServiceCall(to: uri) { [weak self] result in
            switch result {
            case .success(let equipments):
                self?.results.append(equipments)
                if let uri = equipments.next {
                    self?.fetchData(uri: uri)
                } else {
                    self?.state = .success(self?.results ?? [])
                }
            case .failure:
                self?.state = .failure
            }
        }
    }
    
    var text: String {
        switch state {
        case .success:
            return String(format: "Average Weight: %.2f", averageWeight)
        case .loading:
            return "Loading"
        case .failure, .none:
            return "Failure"
        }
    }
    
    private(set) var state: State = .none {
        didSet {
            guard oldValue != state else {
                return
            }
            
            switch state {
            case .loading:
                delegate?.didLoad(viewModel: self)
            case .success:
                delegate?.didSucceed(viewModel: self)
            case .failure, .none:
                delegate?.didFail(viewModel: self)
            }
        }
    }
    
    private var averageWeight: Double {
        guard
            case .success(let equipments) = state,
            equipments.isEmpty == false
        else {
            return .zero
        }
        
        let airConditioners = equipments.flatMap(filterAirConditioners)
        
        guard airConditioners.count > 0 else {
            return .zero
        }
        
        let totalWeight = airConditioners.reduce(.zero, cubicWeight)
        
        let averageWeight = totalWeight / Double(airConditioners.count)
        
        return averageWeight
    }
    
    private func filterAirConditioners(equipment: Equipments) -> [Objects] {
        return equipment.objects.filter { $0.category == Constants.categoryName }
    }
    
    private func cubicWeight(result: Double, object: Objects) -> Double {
        let length = object.size.length.adjustedvalue
        let width = object.size.width.adjustedvalue
        let height = object.size.height.adjustedvalue
        
        return result + (length * width * height * Constants.conversionFactor)
    }
}

private extension Optional where Wrapped == Double {

    enum Factor {
        static let centiMeterToMeterConversionFactor = 100.0
    }
    
    var adjustedvalue: Double {
        guard let valueInCM = self else {
            return 0.0
        }
        
        let valueInMeter = valueInCM / Factor.centiMeterToMeterConversionFactor
        return valueInMeter
    }
}
