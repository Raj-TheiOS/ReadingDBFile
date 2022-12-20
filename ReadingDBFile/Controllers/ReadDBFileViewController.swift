//
//  ViewController.swift
//  ReadingDBFile
//
//  Created by Raj Rathod on 13/12/22.
//

import UIKit
import SQLite3
import CoreData

class ReadDBFileViewController: UIViewController {

    var db: OpaquePointer?
    var securityMasterModel = [SecurityMasterModel]()
    var datasourceTable = GenericTableView()

    @IBOutlet weak var dataTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.startAndCopyDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.readValues()
    }
    
    private func startAndCopyDB()  {
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("securitymasterdatabase_db2.db")
        
        // see if db is in app support directory already
        if sqlite3_open_v2(fileURL.path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK {
            print("db ok")
            return
        }

        // clean up before proceeding
        sqlite3_close(db)
        db = nil

        // if not, get URL from bundle
        guard let bundleURL = Bundle.main.url(forResource: "securitymasterdatabase_db2", withExtension: "db") else {
            print("db not found in bundle")
            return
        }
        // copy from bundle to app support directory
        do {
            try FileManager.default.copyItem(at: bundleURL, to: fileURL)
        } catch {
            print("unable to copy db", error.localizedDescription)
            return
        }

        // now open database again
        guard sqlite3_open_v2(fileURL.path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return
        }

        // report success
        print("db copied and opened")
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
            let ID  = sqlite3_column_int(stmt, 0)
            let SCRIPTID = String(cString: sqlite3_column_text(stmt, 1))
            let TCS_TOKEN_ID = String(cString: sqlite3_column_text(stmt, 2))
            let ODIN_TOKEN_ID = String(cString: sqlite3_column_text(stmt, 3))
            let SEGMENT = String(cString: sqlite3_column_text(stmt, 4))
            let EXCHANGE = String(cString: sqlite3_column_text(stmt, 5))
            let ASL_ALLOWED = String(cString: sqlite3_column_text(stmt, 6))
            let EXCHANGE_SYMBOL = String(cString: sqlite3_column_text(stmt, 7))
            let ISIN_CODE = String(cString: sqlite3_column_text(stmt, 8))
            let CONAME = String(cString: sqlite3_column_text(stmt, 9))
            let EXPIRYDATE = String(cString: sqlite3_column_text(stmt, 10))
            let STRIKEPRICE = String(cString: sqlite3_column_text(stmt, 11))
            let OPTIONTYPE = String(cString: sqlite3_column_text(stmt, 11))
            
            securityMasterModel.append(SecurityMasterModel(id: Int(ID), SCRIPTID: SCRIPTID , TCS_TOKEN_ID: TCS_TOKEN_ID , ODIN_TOKEN_ID: ODIN_TOKEN_ID, SEGMENT: SEGMENT, EXCHANGE: EXCHANGE, ASL_ALLOWED: ASL_ALLOWED, EXCHANGE_SYMBOL: EXCHANGE_SYMBOL, ISIN_CODE: ISIN_CODE, CONAME: CONAME, EXPIRYDATE: EXPIRYDATE, STRIKEPRICE: STRIKEPRICE, OPTIONTYPE: OPTIONTYPE))
        }

        self.batchInsertData(securityMasterModel)
        
    }

    func isEntityAttributeExist(id: Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SecurityData")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let res = try! managedContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    private func batchInsertData(_ dataArray: [SecurityMasterModel]) {
        // 1
        guard !dataArray.isEmpty else { return }
        
        // 2
        let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
        
        let container = appDelegate.persistentContainer

        container.performBackgroundTask { context in
            // 3
            let batchInsert = self.newBatchInsertRequest(with: dataArray)
            do {
                try context.execute(batchInsert)
                
                DispatchQueue.main.async {
                    self.readDataFromCoreData()

                }

            } catch {
                // log any errors
            }
        }
        
    }
    private func newBatchInsertRequest(with dataArray: [SecurityMasterModel])
      -> NSBatchInsertRequest {
      // 1
      var index = 0
      let total = dataArray.count

      // 2
      let batchInsert = NSBatchInsertRequest(
        entity: SecurityData.entity()) { (managedObject: NSManagedObject) -> Bool in
        // 3
        guard index < total else { return true }

            if let object = managedObject as? SecurityData {
                // 4
                let data = dataArray[index]
                object.id = Int64(data.ID ?? 0)
                object.aslAllowed = data.ASL_ALLOWED
                object.coname = data.CONAME
                object.exchange = data.EXCHANGE
                object.exchangeSymbol = data.EXCHANGE_SYMBOL
                object.expiryDate = data.EXPIRYDATE
                object.isinCode = data.ISIN_CODE
                object.odInTokenId = data.ODIN_TOKEN_ID
                object.optionType = data.OPTIONTYPE
                object.scriptId = data.SCRIPTID
                object.segment = data.SEGMENT
                object.strikePrice = data.STRIKEPRICE
                object.tcsTokenId = data.TCS_TOKEN_ID
            }

        // 5
        index += 1
        return false
      }
      return batchInsert
    }

    // MARK:- fetching data from coredata
    func readDataFromCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SecurityData")

        do {
            let results = try context.fetch(fetchRequest)
            let securityData  = results as! [SecurityData]


            print("SecurityMasterModel count : ", securityData.count)
            self.setUpTableCell(data: securityData)

        }catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    // MARK:- loading data in cell
    func setUpTableCell(data: [SecurityData]) {
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

extension ReadDBFileViewController {
    
    
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
    
    func saveUserData(_ securityMasterObj: SecurityMasterModel) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate

        let context = appDelegate.persistentContainer.viewContext
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "SecurityData", into: context)
            
            newUser.setValue(securityMasterObj.ASL_ALLOWED, forKey: "aslAllowed")
            newUser.setValue(securityMasterObj.CONAME, forKey: "coname")
            newUser.setValue(securityMasterObj.EXCHANGE, forKey: "exchange")
            newUser.setValue(securityMasterObj.EXCHANGE_SYMBOL, forKey: "exchangeSymbol")
            newUser.setValue(securityMasterObj.EXPIRYDATE, forKey: "expiryDate")
            newUser.setValue(securityMasterObj.ISIN_CODE, forKey: "isinCode")
            newUser.setValue(securityMasterObj.ODIN_TOKEN_ID, forKey: "odInTokenId")
            newUser.setValue(securityMasterObj.OPTIONTYPE, forKey: "optionType")
            newUser.setValue(securityMasterObj.SCRIPTID, forKey: "scriptId")
            newUser.setValue(securityMasterObj.SEGMENT, forKey: "segment")
            newUser.setValue(securityMasterObj.STRIKEPRICE, forKey: "strikePrice")
            newUser.setValue(securityMasterObj.TCS_TOKEN_ID, forKey: "tcsTokenId")

        do {
            try context.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
}
