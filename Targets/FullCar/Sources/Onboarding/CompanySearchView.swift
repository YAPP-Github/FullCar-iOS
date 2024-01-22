//
//  CompanySearchView.swift
//  FullCar
//
//  Created by Sunny on 1/22/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import FullCarUI

struct CompanySearchView: View {

    @Binding var company: String

    @State private var companySearchBarState: InputState = .default

    var body: some View {
        bodyView
    }

    private var bodyView: some View {
        VStack {
            FCTextFieldView(
                textField: {
                    HStack {
                        TextField("회사, 주소 검색", text: $company)
                            .textFieldStyle(
                                .fullCar(
                                    type: .none,
                                    state: $companySearchBarState,
                                    padding: 16,
                                    backgroundColor: .gray5,
                                    cornerRadius: 10
                                ))

                        Button(action: {
                            print("검색 버튼 눌림")
                            companySearchBarState = .default
                        }, label: {
                            Text("검색")
                        })
                        .buttonStyle(.fullCar(
                            font: .pretendard16(.semibold),
                            horizontalPadding: 14,
                            verticalPadding: 15,
                            style: .palette(.primary_secondary)
                        ))
                    }
                },
                state: $companySearchBarState
            )

            Spacer()
        }
    }
}

#Preview {
    CompanySearchView(company: .constant("네이버"))
}
