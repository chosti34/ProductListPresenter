//
//  BaseApi.swift
//  ProductListPresenter
//
//  Created by Тимур on 14.07.19.
//  Copyright © 2019 Timur. All rights reserved.
//

import UIKit
import Alamofire

class BaseApi: NSObject {
    let apiUrl: String = "http://ostest.whitetigersoft.ru/api"
    let appKey: String = "yx-1PU73oUj6gfk0hNyrNUwhWnmBRld7-SfKAU7Kg6Fpp43anR261KDiQ-MY4P2SRwH_cd4Py1OCY5jpPnY_Viyzja-s18njTLc0E7XcZFwwvi32zX-B91Sdwq1KeZ7m"

    private func buildRequestUrl(_ relativeRequestPath: String, _ params: [String]) -> String {
        var requestUrl = apiUrl + relativeRequestPath
        if params.isEmpty {
            requestUrl += ("?appKey=" + appKey)
            return requestUrl
        }

        var firstParamTraversed: Bool = false
        for param in params {
            if !firstParamTraversed {
                requestUrl += ("?" + param)
                firstParamTraversed = true
            } else {
                requestUrl += ("&" + param)
            }
        }

        return requestUrl + "&appKey=" + appKey
    }

    func sendGetRequest(relativeRequestPath: String, params: [String], responseHandler: @escaping (Any?) -> Void) {
        Alamofire.request(buildRequestUrl(relativeRequestPath, params)).validate().responseJSON { response in
            if !response.result.isSuccess {
                responseHandler(nil)
                return
            }
            responseHandler(response.result.value)
        }
    }
}
