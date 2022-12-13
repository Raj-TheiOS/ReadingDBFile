//
//  DataCell.swift
//  ReadingDBFile
//
//  Created by Raj Rathod on 13/12/22.
//

import UIKit

class DataCell: UITableViewCell, ReusableCell {

    @IBOutlet weak var scriptID: UILabel!
    @IBOutlet weak var exchangeSymbol: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- Loading data to table cell
    var object: SecurityMasterModel? {
        didSet {
            self.scriptID.text = "\(object?.SCRIPTID ?? "")" + "  \(object?.TCS_TOKEN_ID ?? "")" + "  \(object?.ODIN_TOKEN_ID ?? "")" + "  \(object?.SEGMENT ?? "")" + "  \(object?.EXCHANGE ?? "")" + "  \(object?.ASL_ALLOWED ?? "")"
            
            self.exchangeSymbol.text = "\(object?.EXCHANGE_SYMBOL ?? "")" + "  \(object?.ISIN_CODE ?? "")" +  "  \(object?.CONAME ?? "")" + "  \(object?.EXPIRYDATE ?? "")" + "  \(object?.STRIKEPRICE ?? "")" + "  \(object?.OPTIONTYPE ?? "")"
        }
    }

}
