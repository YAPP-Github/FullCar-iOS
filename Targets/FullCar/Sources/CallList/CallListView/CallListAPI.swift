//
//  CallListAPI.swift
//  FullCar
//
//  Created by Tabber on 2024/02/11.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import Foundation

import FullCarUI
import FullCarKit

import Dependencies
import XCTestDynamicOverlay

extension CallListView {
    struct API {
        var fetchSentList: @Sendable () async throws -> CommonResponse<[CarPull.Model.Information]>
        var fetchReceivedList: @Sendable () async throws -> CommonResponse<[CarPull.Model.Information]>
        private var fetch: @Sendable (Int64) async throws -> CommonResponse<CarPull.Model.Information>
        private var changeForm: @Sendable (Int64, String, String, String?) async throws -> CommonResponse<CarPull.Model.Information>
        private var apply: @Sendable (Int64, String, String, Int, String) async throws -> CommonResponse<CarPull.Model.Information>
        private var delete: @Sendable (Int64) async throws -> CommonResponse<CarPull.Model.Information>
        
        
        @discardableResult
        func getFormDetail(formId: Int64) async throws -> CommonResponse<CarPull.Model.Information> {
            return try await self.fetch(formId)
        }
        
        @discardableResult
        func changeFormState(formId: Int64, state: CarPull.Model.FormStateType, contact: String, toPassenger: String?) async throws -> CommonResponse<CarPull.Model.Information> {
            return try await self.changeForm(formId, state.rawValue, contact, toPassenger)
        }
        
        @discardableResult
        func applyCarpull(formId: Int64, pickupLocation: String, peroidType: String, money: Int, content: String) async throws -> CommonResponse<CarPull.Model.Information> {
            return try await self.apply(formId, pickupLocation, peroidType, money, content)
        }
        
        @discardableResult
        func deleteCarpull(formId: Int64) async throws -> CommonResponse<CarPull.Model.Information> {
            return try await self.delete(formId)
        }
    }
}

extension CallListView.API: DependencyKey {
    static let liveValue: CallListView.API = .init(fetchSentList: {
        return try await NetworkClient.main.request(endpoint: Endpoint.Form.fetchSentForms)
            .response()
    }, fetchReceivedList: {
        return try await NetworkClient.main.request(endpoint: Endpoint.Form.fetchReceivedForms)
            .response()
    }, fetch: { formId in
        return try await NetworkClient.main.request(endpoint: Endpoint.Form.getFormDetail(formId: formId))
            .response()
    }, changeForm: { formId, state, contact, toPassenger in
        return try await NetworkClient.main.request(endpoint: Endpoint.Form.changeFormStatus(formId: formId, formState: state, contact: contact, toPassenger: toPassenger))
            .response()
    }, apply: { formId, pickupLocation, peroidType, money, content in
        return try await NetworkClient.main.request(endpoint: Endpoint.Form.applyCarpull(formId: formId, pickupLocation: pickupLocation, periodType: peroidType, money: money, content: content))
            .response()
    }, delete: { formId in
        return try await NetworkClient.main.request(endpoint: Endpoint.CarPull.deleteCarpull(id: formId))
            .response()
    })
    #if DEBUG
    static let previewValue: CallListView.API = .init(fetchSentList: {
        return CommonResponse<[CarPull.Model.Information]>(
            status: 200, message: "", data: [
                .init(id: 0,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .REQUEST,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: .init(contact: "탑승자에게 보내는 메시지", toPassenger: "연락은 카톡으로 드리겠습니다~\n내일 뵙겠습니다."),
                      createdAt: Date()),
                .init(id: 1,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .REJECT,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
                      createdAt: Date()),
                .init(id: 2,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .REQUEST,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: nil,
                      createdAt: Date()),
                .init(id: 3,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .ACCEPT,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: nil,
                      createdAt: Date()),
                .init(id: 4,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .REJECT,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
                      createdAt: Date()),
                .init(id: 5,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .ACCEPT,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: .init(contact: "탑승자에게 보내는 메시지", toPassenger: "연락은 카톡으로 드리겠습니다~\n내일 뵙겠습니다."),
                      createdAt: Date())
            ]
        )
    }, fetchReceivedList: {
        return CommonResponse<[CarPull.Model.Information]>(
            status: 200, message: "", data: [
                .init(id: 0,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .REQUEST,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: .init(contact: "탑승자에게 보내는 메시지", toPassenger: "연락은 카톡으로 드리겠습니다~\n내일 뵙겠습니다."),
                      createdAt: Date()),
                .init(id: 1,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .REJECT,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
                      createdAt: Date()),
                .init(id: 2,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .REQUEST,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: nil,
                      createdAt: Date()),
                .init(id: 3,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .ACCEPT,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: nil,
                      createdAt: Date()),
                .init(id: 4,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .REJECT,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
                      createdAt: Date()),
                .init(id: 5,
                      pickupLocation: "봉천역",
                      periodType: .oneWeek,
                      money: 10000,
                      content: "봉천역에서 카풀해요~",
                      moodType: .quiet,
                      formState: .ACCEPT,
                      carpoolState: .OPEN,
                      nickname: "알뜰한 물개",
                      companyName: "현대자동차",
                      gender: .male,
                      resultMessage: .init(contact: "탑승자에게 보내는 메시지", toPassenger: "연락은 카톡으로 드리겠습니다~\n내일 뵙겠습니다."),
                      createdAt: Date())
            ]
        )
    }, fetch: { formId in
            .init(status: 200, message: "", data: .init(id: 4,
                                                        pickupLocation: "봉천역",
                                                        periodType: .oneWeek,
                                                        money: 10000,
                                                        content: "봉천역에서 카풀해요~",
                                                        moodType: .quiet,
                                                        formState: .REJECT,
                                                        carpoolState: .OPEN,
                                                        nickname: "알뜰한 물개",
                                                        companyName: "현대자동차",
                                                        gender: .male,
                                                        resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
                                                        createdAt: Date()))
        
    }, changeForm: { formId, state, contact, toPassenger in
            .init(status: 200, message: "", data: .init(id: 4,
                                                        pickupLocation: "봉천역",
                                                        periodType: .oneWeek,
                                                        money: 10000,
                                                        content: "봉천역에서 카풀해요~",
                                                        moodType: .quiet,
                                                        formState: .REJECT,
                                                        carpoolState: .OPEN,
                                                        nickname: "알뜰한 물개",
                                                        companyName: "현대자동차",
                                                        gender: .male,
                                                        resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
                                                        createdAt: Date()))
    }, apply: { formId, pickupLocation, periodType, money, contect in
            .init(status: 200, message: "", data: .init(id: 4,
                                                        pickupLocation: "봉천역",
                                                        periodType: .oneWeek,
                                                        money: 10000,
                                                        content: "봉천역에서 카풀해요~",
                                                        moodType: .quiet,
                                                        formState: .REJECT,
                                                        carpoolState: .OPEN,
                                                        nickname: "알뜰한 물개",
                                                        companyName: "현대자동차",
                                                        gender: .male,
                                                        resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
                                                        createdAt: Date()))
    }, delete: { formId in
            .init(status: 200, message: "", data: .init(id: 4,
                                                        pickupLocation: "봉천역",
                                                        periodType: .oneWeek,
                                                        money: 10000,
                                                        content: "봉천역에서 카풀해요~",
                                                        moodType: .quiet,
                                                        formState: .REJECT,
                                                        carpoolState: .OPEN,
                                                        nickname: "알뜰한 물개",
                                                        companyName: "현대자동차",
                                                        gender: .male,
                                                        resultMessage: .init(contact: "카풀 매칭에 실패했어요. 다른 카풀을 찾아보세요!", toPassenger: nil),
                                                        createdAt: Date()))
    })
    #endif
}

extension DependencyValues {
    var callListAPI: CallListView.API {
        get { self[CallListView.API.self] }
        set { self[CallListView.API.self] = newValue }
    }
}
