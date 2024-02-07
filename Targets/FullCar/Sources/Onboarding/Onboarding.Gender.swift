//
//  Onboarding.Gender.swift
//  FullCar
//
//  Created by Sunny on 2/7/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

extension Onboarding.Gender {
    @MainActor
    struct PickerView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            bodyView
        }

        private var bodyView: some View {
            SectionView(
                content: {
                    HStack(spacing: 6) {
                        ForEach(Onboarding.Gender.allCases, id: \.self) { genderType in
                            if genderType != .none {
                                Button(action: {
                                    $viewModel.gender.wrappedValue = genderType
                                }, label: {
                                    Text(genderType.rawValue)
                                })
                                .buttonStyle(.chip(genderType == $viewModel.gender.wrappedValue))
                            }
                        }
                    }
                },
                header: {
                    HeaderLabel(
                        title: "\(viewModel.nickname)님의 성별을 알려주세요.",
                        font: .pretendard22(.bold)
                    )
                    .frame(width: 335, alignment: .leading)
                },
                footer: {
                    if $viewModel.gender.wrappedValue == .notPublic {
                        let notPublic: Message = .information("성별 미공개 시 게시글 노출률이 낮아질 수 있어요.")
                        Text(notPublic.description)
                            .font(.pretendard14(.semibold))
                            .foregroundStyle(notPublic.fontColor)
                    }
                },
                headerBottomPadding: 20,
                footerTopPadding: 8
            )
        }
    }

    @MainActor
    struct ButtonView: View {
        @Bindable var viewModel: Onboarding.ViewModel

        var body: some View {
            bodyView
        }

        private var bodyView: some View {
            Button(action: {
                // 온보딩 완료!
            }, label: {
                Text("완료")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.fullCar(style: .palette(.primary_white)))
        }
    }
}
