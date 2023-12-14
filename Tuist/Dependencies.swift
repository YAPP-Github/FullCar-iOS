import MyPlugin
import ProjectDescription

let packages: [Package] = [
    .firebase,
    .dependencies,
    .alamofire,
]

///// deprecated된거 모르겠음 ㅎ;
//let dependencies: Dependencies = .init(
//    swiftPackageManager: .init(
//        packages, 
//        baseSettings: .settings(
//            configurations: .app
//        )
//    ), 
//    platforms: [.iOS]
//)
