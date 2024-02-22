import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

import MyPlugin

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String,
        platform: Platform,
        additionalTargets: [String] = []
    ) -> Project {
        var targets = makeAppTargets(
            name: name,
            platform: platform,
            dependencies: additionalTargets.map { TargetDependency.target(name: $0) }
        )
        targets += makeFrameworkTargets(
            name: "FullCarKit", 
            platform: .iOS,
            dependencies: [
                .alamofire,
                .analytics,
                .crashlytics,
                .dependencies,
//                .dependenciesMacros,
            ]
        )
        targets += makeFrameworkTargets(
            name: "FullCarUI", 
            platform: .iOS
        )
        return Project(
            name: name,
            organizationName: "com.fullcar",
            targets: targets
        )
    }
    
    // MARK: - Private
    
    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(
        name: String,
        platform: Platform,
        dependencies: [ProjectDescription.TargetDependency] = []
    ) -> [Target] {
        let sources = Target(
            name: name,
            platform: platform,
            product: .framework,
            bundleId: "com.fullcar.\(name)",
            infoPlist: .default,
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: [] + dependencies
        )
        let tests = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "com.fullcar.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            resources: [],
            dependencies: [
                .target(name: name)
            ]
        )
        return [
            sources,
            tests
        ]
    }
    
    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(
        name: String,
        platform: Platform,
        dependencies: [TargetDependency]
    ) -> [Target] {
        let platform: Platform = platform
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": "1.1",
            "CFBundleVersion": "2",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
        ]
        
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "com.fullcar.\(name)",
            deploymentTarget: .iOS(targetVersion: "17.0", devices: .iphone),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            scripts: [
                TargetScript.pre(path: "./Scripts/FBCrashlyticsRunScript.sh", name: "Firebase Crashlystics",inputFileListPaths: [
                    Path("${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"),
                    Path("${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}"),
                    Path("${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist"),
                    Path("$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist"),
                    Path("$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)")
                ])
            ],
            dependencies: dependencies
        )
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "com.fullcar.\(name)Tests",
            infoPlist: .default,
            sources: ["Targets/\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ]
        )
        return [
            mainTarget,
            testTarget
        ]
    }
}
