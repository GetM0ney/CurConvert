import SwiftUI
import Swinject

@main
struct MyApp: App {
    private let container: Resolver
    private let viewFactory: ViewFactory
    private let viewFactoryWrapper: ViewFactoryWrapper
    
    init() {
        let appContainer = AppDIContainer.shared
        self.container = appContainer.container
        self.viewFactory = ViewFactory(container: container)
        self.viewFactoryWrapper = ViewFactoryWrapper(factory: viewFactory)
    }

    var body: some Scene {
        WindowGroup {
            viewFactory.makeCurrencyRatesView(baseCurrency: .usd)
                    .environmentObject(viewFactoryWrapper)
        }
    }
}
