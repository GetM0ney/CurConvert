import SwiftUI
import ConvCore
import Swinject

public struct ContentView: View {
    @StateObject private var viewModel: CurrencyRatesViewModel

        init(baseCurrency: Currency, container: Resolver) {
            let service = container.resolve(CurrencyRateService.self)!
            let converter = container.resolve(ICurrencyConverterManager.self)!
            _viewModel = StateObject(wrappedValue: CurrencyRatesViewModel(
                baseCurrency: baseCurrency,
                currencyRateService: service,
                converter: converter
            ))
        }

    public var body: some View {
        VStack {
            Text("asdasddasdas")
        }
    }
}
