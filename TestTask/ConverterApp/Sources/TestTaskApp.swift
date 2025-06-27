import SwiftUI
import Swinject

@main
struct MyApp: App {
    private let container: Resolver
    private let viewFactory: ViewFactory

    init() {
        let appContainer = AppDIContainer.shared
        self.container = appContainer.container
        self.viewFactory = ViewFactory(container: container)
    }

    var body: some Scene {
        WindowGroup {
            viewFactory.makeCurrencyRatesView(baseCurrency: .usd)
        }
    }
}
