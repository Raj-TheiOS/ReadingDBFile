//
//  SecurityMasterModel.swift
//  ReadingDBFile
//
//  Created by Raj Rathod on 13/12/22.
//

import Foundation

class SecurityMasterModel {
    var SCRIPTID: String?
    var TCS_TOKEN_ID: String?
    var ODIN_TOKEN_ID: String?
    var SEGMENT: String?
    var EXCHANGE: String?
    var EXCHANGESECURITYID: String?
    var EXCHANGE_STATUS: String?
    var ASL_ALLOWED: String?
    var ASL_HCUT_PCNT: String?
    var EXCHANGE_SYMBOL: String?
    var EXCHANGE_SERIES: String?
    var ISIN_CODE: String?
    var CONAME: String?
    var T_SETT_DAY: String?
    var INSTRUMENTTYPE: String?
    var OPTIONTYPE: String?
    var EXPIRYDATE: String?
    var STRIKEPRICE: String?
    var LOTSIZE: String?
    var TICKSIZE: String?
    var NRI_ALLOWED: String?
    var ILLIQUID_SEC: String?
    var OPENPRICE: String?
    var HIGHPRICE: String?
    var LOWPRICE: String?
    var CLOSEPRICE: String?
    var DPRHIGH: String?
    var DPRLOW: String?
    var CMOTS_COCODE: String?
    var ASSET_CLASS: String?
    var SEARCH_PRIORITY: String?
    var UNDERLYING: String?
    var SEARCHABLE: String?
    var CREATED_DATE: String?
    var UPDATED_DATE: String?



    init(SCRIPTID: String?, TCS_TOKEN_ID: String?, ODIN_TOKEN_ID: String?, SEGMENT: String?, EXCHANGE: String?, EXCHANGESECURITYID: String?, EXCHANGE_STATUS: String?, ASL_ALLOWED: String?, ASL_HCUT_PCNT: String?, EXCHANGE_SYMBOL: String?, EXCHANGE_SERIES: String?, ISIN_CODE: String?, CONAME: String?, T_SETT_DAY: String?, INSTRUMENTTYPE: String?, OPTIONTYPE: String?, EXPIRYDATE: String?, STRIKEPRICE: String?, LOTSIZE: String?, TICKSIZE: String?, NRI_ALLOWED: String?, ILLIQUID_SEC: String?, OPENPRICE: String?, HIGHPRICE: String?, LOWPRICE: String?, CLOSEPRICE: String?, DPRHIGH: String?, DPRLOW: String?, CMOTS_COCODE: String?, ASSET_CLASS: String?, SEARCH_PRIORITY: String?, UNDERLYING: String?, SEARCHABLE: String?, CREATED_DATE: String?, UPDATED_DATE: String?) {
        
        self.SCRIPTID = SCRIPTID
        self.TCS_TOKEN_ID = TCS_TOKEN_ID
        self.ODIN_TOKEN_ID = ODIN_TOKEN_ID
        self.SEGMENT = SEGMENT
        self.EXCHANGE = EXCHANGE
        self.EXCHANGESECURITYID = EXCHANGESECURITYID
        self.EXCHANGE_STATUS = EXCHANGE_STATUS
        self.ASL_ALLOWED = ASL_ALLOWED
        self.ASL_HCUT_PCNT = ASL_HCUT_PCNT
        self.EXCHANGE_SYMBOL = EXCHANGE_SYMBOL
        self.EXCHANGE_SERIES = EXCHANGE_SERIES
        self.ISIN_CODE = ISIN_CODE
        self.CONAME = CONAME
        self.T_SETT_DAY = T_SETT_DAY
        self.INSTRUMENTTYPE = INSTRUMENTTYPE
        self.OPTIONTYPE = OPTIONTYPE
        self.EXPIRYDATE = EXPIRYDATE
        self.STRIKEPRICE = STRIKEPRICE
        self.LOTSIZE = LOTSIZE
        self.TICKSIZE = TICKSIZE
        self.NRI_ALLOWED = NRI_ALLOWED
        self.ILLIQUID_SEC = ILLIQUID_SEC
        self.OPENPRICE = OPENPRICE
        self.HIGHPRICE = HIGHPRICE
        self.LOWPRICE = LOWPRICE
        self.CLOSEPRICE = CLOSEPRICE
        self.DPRHIGH = DPRHIGH
        self.DPRLOW = DPRLOW
        self.CMOTS_COCODE = CMOTS_COCODE
        self.ASSET_CLASS = ASSET_CLASS
        self.SEARCH_PRIORITY = SEARCH_PRIORITY
        self.UNDERLYING = UNDERLYING
        self.SEARCHABLE = SEARCHABLE
        self.CREATED_DATE = CREATED_DATE
        self.UPDATED_DATE = UPDATED_DATE
        
        
    }
}

