//
//  MyPage.Question.swift
//  FullCar
//
//  Created by Sunny on 2/21/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI

extension MyPage {
    enum Question { }
}

extension MyPage.Question {
    @MainActor
    struct BodyView: View {
        @Environment(\.openURL) var openURL

        var body: some View {
            Text("hi")
                .onAppear {

                }

//            let url = URL(string: "https://open.kakao.com/o/sg3bvqag")
//                            WebView(url: url)
//            Group { }
//                .onAppear {
//                    openURL(url!)
//                }
        }
    }
}

#Preview {
    MyPage.Question.BodyView()
}
