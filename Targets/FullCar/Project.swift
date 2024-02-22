import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(
    name: "MyPlugin"
)

let project = Project(
    name: .appName,
    organizationName: .organizationName,
    options: .options(
        automaticSchemesOptions: .disabled,
        defaultKnownRegions: ["Base", "ko"],
        developmentRegion: "ko",
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    ),
    packages: [],
    settings: .settings(base: [
        "MARKETING_VERSION": "2",
        "CURRENT_PROJECT_VERSION": "1.1",
        "INFOPLIST_KEY_CFBundleDisplayName": "FullCar",
    ], configurations: .app),
    targets: [
        mainTarget,
    ],
    schemes: .appSchemes
)
