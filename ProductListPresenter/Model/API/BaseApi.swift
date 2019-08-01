//
//  BaseApi.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import Alamofire

class BaseApi {

    let apiUrl: String = "http://ostest.whitetigersoft.ru/api"
    let appKey: String = "yx-1PU73oUj6gfk0hNyrNUwhWnmBRld7-SfKAU7Kg6Fpp43anR261KDiQ-MY4P2SRwH_cd4Py1OCY5jpPnY_Viyzja-s18njTLc0E7XcZFwwvi32zX-B91Sdwq1KeZ7m"

    private func prepareParams(_ params: Dictionary<String, Any>) -> Dictionary<String, Any> {
        var newParams = params
        newParams["appKey"] = self.appKey
        return newParams
    }

    private func prepareUrl(_ relativeUrl: String) -> String {
        if relativeUrl.isEmpty {
            return apiUrl
        }
        return apiUrl + (relativeUrl.starts(with: "/") ? relativeUrl : "/" + relativeUrl)
    }

    func sendRequest(relativeUrl: String, params: Dictionary<String, Any>, responseHandler: @escaping (Any?) -> Void) {

        let url: String = prepareUrl(relativeUrl)
        let newParams = prepareParams(params)

        Alamofire.request(url, method: .get, parameters: newParams, encoding: URLEncoding.default, headers: nil).validate().responseJSON { (response: DataResponse<Any>) in
            if response.result.isSuccess {
                if let jsonRoot = response.result.value as? [String: Any] {
                    responseHandler(jsonRoot["data"])
                    return
                }
            }
            responseHandler(nil)
        }
    }
}
