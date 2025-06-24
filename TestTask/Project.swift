import ProjectDescription

// MARK: - Common Constants

private enum Constants {
    static let iosDeploymentTarget: DeploymentTargets = .iOS("17.0")
    static let bundleIdPrefix = "com.example"
}

// MARK: - Target Definitions

private extension Target {
    static func convApp() -> Target {
        .target(
            name: "ConverterApp",
            destinations: .iOS,
            product: .app,
            bundleId: "\(Constants.bundleIdPrefix).converter",
            deploymentTargets: Constants.iosDeploymentTarget,
            infoPlist: .default,
            sources: ["ConverterApp/Sources/**"],
            resources: ["ConverterApp/Resources/**"],
            dependencies: [
                .target(name: "ConvComponents"),
                .target(name: "ConvCore"),
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .automaticCodeSigning(devTeam: "3M9CCX6KPN")
            )
        )
    }
    
    static func convComponents() -> Target {
        .target(
            name: "ConvComponents",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Constants.bundleIdPrefix).convComponents",
            deploymentTargets: Constants.iosDeploymentTarget,
            infoPlist: .default,
            sources: ["ConvComponents/Sources/**"],
            resources: ["ConvComponents/Resources/**"],
            dependencies: [
                .target(name: "ConvCore"),
            ],
            settings: .settings(
                base: SettingsDictionary()
                    .otherLinkerFlags([
                        "$(inherited) -ObjC -lresolv -l\"c++\" -framework \"CoreFoundation\" -framework \"Foundation\" -framework \"CoreLocation\" -framework \"UIKit\" -framework \"OpenGLES\" -framework \"SystemConfiguration\" -framework \"CoreGraphics\" -framework \"QuartzCore\" -framework \"Security\" -framework \"CoreTelephony\" -framework \"CoreMotion\" -framework \"DeviceCheck\"",
                    ])
            )
        )
    }
    
    static func convTests() -> Target {
        .target(
            name: "ConvTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(Constants.bundleIdPrefix).ConvTests",
            infoPlist: .default,
            sources: ["ConverterApp/Tests/**"],
            resources: [],
            dependencies: [.target(name: "ConverterApp")]
        )
    }
    
    static func convCore() -> Target {
        .target(
            name: "ConvCore",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(Constants.bundleIdPrefix).convCore",
            deploymentTargets: Constants.iosDeploymentTarget,
            infoPlist: .default,
            sources: ["ConvCore/Sources/**"],
            resources: ["ConvCore/Resources/**"],
            dependencies: [
                .external(name: "Swinject"),
                .external(name: "SwinjectAutoregistration"),
            ]
        )
    }
    
    
    
}

// MARK: - Project Definition

let project = Project(
    name: "CurrencyConverter",
    targets: [.convApp(), .convComponents(), .convCore(), .convTests()]
)
