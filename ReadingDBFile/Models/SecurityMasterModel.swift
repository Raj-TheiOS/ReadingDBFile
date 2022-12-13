//
//  SecurityMasterModel.swift
//  ReadingDBFile
//
//  Created by Raj Rathod on 13/12/22.
//

import Foundation

class SecurityMasterModel {
 
  //  var ID: Int
    var SCRIPTID: String?
    var TCS_TOKEN_ID: String?
    var ODIN_TOKEN_ID: String?
    var SEGMENT: String?
    var EXCHANGE: String?
    var ASL_ALLOWED: String?
    var EXCHANGE_SYMBOL: String?
    var ISIN_CODE: String?
    var CONAME: String?
    var EXPIRYDATE: String?
    var STRIKEPRICE: String?
    var OPTIONTYPE: String?

    init(SCRIPTID: String?, TCS_TOKEN_ID: String?, ODIN_TOKEN_ID: String?, SEGMENT: String?, EXCHANGE: String?, ASL_ALLOWED: String?, EXCHANGE_SYMBOL: String?,  ISIN_CODE: String?, CONAME: String?, EXPIRYDATE: String?, STRIKEPRICE: String?, OPTIONTYPE: String?) {
        
     //   self.ID = id
        self.SCRIPTID = SCRIPTID
        self.TCS_TOKEN_ID = TCS_TOKEN_ID
        self.ODIN_TOKEN_ID = ODIN_TOKEN_ID
        self.SEGMENT = SEGMENT
        self.EXCHANGE = EXCHANGE
        self.ASL_ALLOWED = ASL_ALLOWED
        self.EXCHANGE_SYMBOL = EXCHANGE_SYMBOL
        self.ISIN_CODE = ISIN_CODE
        self.CONAME = CONAME
        self.EXPIRYDATE = EXPIRYDATE
        self.STRIKEPRICE = STRIKEPRICE
        self.OPTIONTYPE = OPTIONTYPE
    }
}

