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
    settings: .settings(configurations: .app),
    targets: [
        mainTarget,
    ],
    schemes: .appSchemes
)
