//
//  ViewController.swift
//  ReadingDBFile
//
//  Created by Raj Rathod on 13/12/22.
//

import UIKit
import SQLite3

class ReadDBFileViewController: UIViewController {

    var db: OpaquePointer?
    var securityMasterModel = [SecurityMasterModel]()
    var datasourceTable = GenericTableView()

    @IBOutlet weak var dataTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.startDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.readValues()
    }
    public func startDB()  {
        
        guard let fileURL = Bundle.main.url(forResource: "securitymasterdatabase_db2", withExtension: "db") else {
            print("unable to open database")
            return
        }
        print(fileURL)
        
        // open database
        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            return
        }
        print("database opened successfully")
        return
    }
    
    func readValues() {
 
        //first empty the list of securityMasterModel
        securityMasterModel.removeAll()
 
        //this is our select query
        let queryString = "SELECT * FROM security_master_table"
 
        //statement pointer
        var stmt:OpaquePointer?
 
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
 
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
           // let ID  = sqlite3_column_int(stmt, 0)
            
            let SCRIPTID = String(cString: sqlite3_column_text(stmt, 0))
            let TCS_TOKEN_ID = String(cString: sqlite3_column_text(stmt, 1))
            let ODIN_TOKEN_ID = String(cString: sqlite3_column_text(stmt, 2))
            let SEGMENT = String(cString: sqlite3_column_text(stmt, 3))
            let EXCHANGE = String(cString: sqlite3_column_text(stmt, 4))
            let ASL_ALLOWED = String(cString: sqlite3_column_text(stmt, 5))
            let EXCHANGE_SYMBOL = String(cString: sqlite3_column_text(stmt, 6))
            let ISIN_CODE = String(cString: sqlite3_column_text(stmt, 7))
            let CONAME = String(cString: sqlite3_column_text(stmt, 8))
            let EXPIRYDATE = String(cString: sqlite3_column_text(stmt, 9))
            let STRIKEPRICE = String(cString: sqlite3_column_text(stmt, 10))
            let OPTIONTYPE = String(cString: sqlite3_column_text(stmt, 11))
                    
            securityMasterModel.append(SecurityMasterModel(SCRIPTID: SCRIPTID , TCS_TOKEN_ID: TCS_TOKEN_ID , ODIN_TOKEN_ID: ODIN_TOKEN_ID, SEGMENT: SEGMENT, EXCHANGE: EXCHANGE, ASL_ALLOWED: ASL_ALLOWED, EXCHANGE_SYMBOL: EXCHANGE_SYMBOL, ISIN_CODE: ISIN_CODE, CONAME: CONAME, EXPIRYDATE: EXPIRYDATE, STRIKEPRICE: STRIKEPRICE, OPTIONTYPE: OPTIONTYPE))
            
        }
        
        print("SecurityMasterModel count : ", securityMasterModel.count)

        self.setUpTableCell(data: securityMasterModel)

    }


    // MARK:- loading data in cell
    func setUpTableCell(data: [SecurityMasterModel]) {
        datasourceTable.isContextMenu = true
        datasourceTable.emptyMessage = "Data not available!"
        datasourceTable.array = data
        datasourceTable.identifier = DataCell.identifier
        dataTable.dataSource = datasourceTable
        dataTable.delegate = datasourceTable
        dataTable.tableFooterView = UIView()
        datasourceTable.configure = {cell, index in
            guard let dataCell = cell as? DataCell else { return }
            dataCell.object = data[index]
        }
        datasourceTable.didScroll = {
        }
        datasourceTable.didSelect = {cell, index in
        }
    }
    
}

