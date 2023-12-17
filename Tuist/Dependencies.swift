import MyPlugin
import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .firebase,
            .dependencies,
            .alamofire,
            .kakao
        ],
        baseSettings: .settings(
            configurations: [
                .debug(name: .sandbox),
                .release(name: .store),
            ]
        )
    ),
    platforms: [.iOS]
)
