//
//  DataCell.swift
//  ReadingDBFile
//
//  Created by Raj Rathod on 13/12/22.
//

import UIKit

class DataCell: UITableViewCell, ReusableCell {

    @IBOutlet weak var oneLbl: UILabel!
    @IBOutlet weak var twoLbl: UILabel!
    @IBOutlet weak var threeLbl: UILabel!
    @IBOutlet weak var fourLbl: UILabel!
    @IBOutlet weak var fiveLbl: UILabel!
    @IBOutlet weak var sixLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- Loading data to table cell
    var object: SecurityData? {
        didSet {
            self.oneLbl.attributedText =
            NSMutableAttributedString()
                .orangeHighlight(" Id: ")
                .blackHighlight(" \(object?.scriptId ?? "") ")
                .normal("   Asl Allowed: ")
                .bold("\(object?.aslAllowed ?? "NA")")
            
            self.twoLbl.attributedText =
            NSMutableAttributedString()
                .normal(" Coname: ")
                .bold(" \(object?.coname ?? "NA") ")
                .normal("   Exchange: ")
                .bold("\(object?.exchange ?? "NA")")

            self.threeLbl.attributedText =
            NSMutableAttributedString()
                .normal(" Exchange Symbol: ")
                .bold(" \(object?.exchangeSymbol ?? "NA") ")
                .normal("   Expiry Date: ")
                .bold("\(object?.expiryDate ?? "NA")")
            
            self.fourLbl.attributedText =
            NSMutableAttributedString()
                .normal(" ISIN Code: ")
                .bold(" \(object?.isinCode ?? "NA") ")
                .normal("   ODIN Token Id: ")
                .bold("\(object?.odInTokenId ?? "NA")")

            self.fiveLbl.attributedText =
            NSMutableAttributedString()
                .normal(" Option Type: ")
                .bold(" \(object?.optionType ?? "NA") ")
                .normal("   Script Id: ")
                .bold("\(object?.scriptId ?? "NA")")

            self.sixLbl.attributedText =
            NSMutableAttributedString()
                .normal(" Segment: ")
                .bold(" \(object?.segment ?? "NA") ")
                .normal("  Strike Price: ")
                .bold("\(object?.strikePrice ?? "NA")")
                .normal("  TCS Token Id: ")
                .bold("\(object?.tcsTokenId ?? "NA")")

            }
        /*
        didSet {
            self.scriptID.text = "\(object?.SCRIPTID ?? "")" + "  \(object?.TCS_TOKEN_ID ?? "")" + "  \(object?.ODIN_TOKEN_ID ?? "")" + "  \(object?.SEGMENT ?? "")" + "  \(object?.EXCHANGE ?? "")" + "  \(object?.ASL_ALLOWED ?? "")"
            
            self.exchangeSymbol.text = "\(object?.EXCHANGE_SYMBOL ?? "")" + "  \(object?.ISIN_CODE ?? "")" +  "  \(object?.CONAME ?? "")" + "  \(object?.EXPIRYDATE ?? "")" + "  \(object?.STRIKEPRICE ?? "")" + "  \(object?.OPTIONTYPE ?? "")"
        }
         */
    }

}
