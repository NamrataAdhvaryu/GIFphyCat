//
//  ErrorCode.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/29/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import Foundation



public enum ErrorCode: Int
{
    case noDataInResponse
    case failedToUnwrapJSONFromDataResponse
    case failedToProcessGIF
    case couldNotGenerateEndpoint
}
