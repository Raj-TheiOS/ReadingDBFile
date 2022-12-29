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
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private weak var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval?
    private var elapsed: CFTimeInterval = 0
    private var priorElapsed: CFTimeInterval = 0
    
    var allData = [SecurityData]()
    
    var search:String=""
    fileprivate var regex = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       // self.startDB()
        self.tfSearch.delegate = self
        self.startAndCopyDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.readValues()
    }
    
    private func startAndCopyDB()  {
        self.startTimer()
        
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("security_master.db")
        
        // see if db is in app support directory already
        if sqlite3_open_v2(fileURL.path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK {
            print("db ok")
            return
        }

        // clean up before proceeding
        sqlite3_close(db)
        db = nil

        // if not, get URL from bundle
        guard let bundleURL = Bundle.main.url(forResource: "security_master", withExtension: "db") else {
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
            let SCRIPTID = String(cString: sqlite3_column_text(stmt, 0))
            let TCS_TOKEN_ID = String(cString: sqlite3_column_text(stmt, 1))
            let ODIN_TOKEN_ID = String(cString: sqlite3_column_text(stmt, 2))
            let SEGMENT = String(cString: sqlite3_column_text(stmt, 3))
            let EXCHANGE = String(cString: sqlite3_column_text(stmt, 4))
            let EXCHANGESECURITYID = String(cString: sqlite3_column_text(stmt, 5))
            let EXCHANGE_STATUS = String(cString: sqlite3_column_text(stmt, 6))
            let ASL_ALLOWED = String(cString: sqlite3_column_text(stmt, 7))
            let ASL_HCUT_PCNT = String(cString: sqlite3_column_text(stmt, 8))
            let EXCHANGE_SYMBOL = String(cString: sqlite3_column_text(stmt, 9))
            let EXCHANGE_SERIES = String(cString: sqlite3_column_text(stmt, 10))
            let ISIN_CODE = String(cString: sqlite3_column_text(stmt, 11))
            let CONAME = String(cString: sqlite3_column_text(stmt, 12))
            let T_SETT_DAY = String(cString: sqlite3_column_text(stmt, 13))
            let INSTRUMENTTYPE = String(cString: sqlite3_column_text(stmt, 14))
            let OPTIONTYPE = String(cString: sqlite3_column_text(stmt, 15))
            let EXPIRYDATE = String(cString: sqlite3_column_text(stmt, 16))
            let STRIKEPRICE = String(cString: sqlite3_column_text(stmt, 17))
            let LOTSIZE = String(cString: sqlite3_column_text(stmt, 18))
            let TICKSIZE = String(cString: sqlite3_column_text(stmt, 19))
            let NRI_ALLOWED = String(cString: sqlite3_column_text(stmt, 20))
            let ILLIQUID_SEC = String(cString: sqlite3_column_text(stmt, 21))
            let OPENPRICE = String(cString: sqlite3_column_text(stmt, 22))
            let HIGHPRICE = String(cString: sqlite3_column_text(stmt, 23))
            let LOWPRICE = String(cString: sqlite3_column_text(stmt, 24))
            let CLOSEPRICE = String(cString: sqlite3_column_text(stmt, 25))
            let DPRHIGH = String(cString: sqlite3_column_text(stmt, 26))
            let DPRLOW = String(cString: sqlite3_column_text(stmt, 27))
            let CMOTS_COCODE = String(cString: sqlite3_column_text(stmt, 28))
            let ASSET_CLASS = String(cString: sqlite3_column_text(stmt, 29))
            let SEARCH_PRIORITY = String(cString: sqlite3_column_text(stmt, 30))
            let UNDERLYING = String(cString: sqlite3_column_text(stmt, 31))
            let SEARCHABLE = String(cString: sqlite3_column_text(stmt, 32))
            let CREATED_DATE = String(cString: sqlite3_column_text(stmt, 33))
            let UPDATED_DATE = String(cString: sqlite3_column_text(stmt, 34))


            securityMasterModel.append(SecurityMasterModel(SCRIPTID: SCRIPTID, TCS_TOKEN_ID: TCS_TOKEN_ID, ODIN_TOKEN_ID: ODIN_TOKEN_ID, SEGMENT: SEGMENT, EXCHANGE: EXCHANGE, EXCHANGESECURITYID: EXCHANGESECURITYID, EXCHANGE_STATUS: EXCHANGE_STATUS, ASL_ALLOWED: ASL_ALLOWED, ASL_HCUT_PCNT: ASL_HCUT_PCNT, EXCHANGE_SYMBOL: EXCHANGE_SYMBOL, EXCHANGE_SERIES: EXCHANGE_SERIES, ISIN_CODE: ISIN_CODE, CONAME: CONAME, T_SETT_DAY: T_SETT_DAY, INSTRUMENTTYPE: INSTRUMENTTYPE, OPTIONTYPE: OPTIONTYPE, EXPIRYDATE: EXPIRYDATE, STRIKEPRICE: STRIKEPRICE, LOTSIZE: LOTSIZE, TICKSIZE: TICKSIZE, NRI_ALLOWED: NRI_ALLOWED, ILLIQUID_SEC: ILLIQUID_SEC, OPENPRICE: OPENPRICE, HIGHPRICE: HIGHPRICE, LOWPRICE: LOWPRICE, CLOSEPRICE: CLOSEPRICE, DPRHIGH: DPRHIGH, DPRLOW: DPRLOW, CMOTS_COCODE: CMOTS_COCODE, ASSET_CLASS: ASSET_CLASS, SEARCH_PRIORITY: SEARCH_PRIORITY, UNDERLYING: UNDERLYING, SEARCHABLE: SEARCHABLE, CREATED_DATE: CREATED_DATE, UPDATED_DATE: UPDATED_DATE))
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
                self.pauseTimer()
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
                object.aslAllowed = data.ASL_ALLOWED
                object.aslHcutPcnt = data.ASL_HCUT_PCNT
                object.assetClass = data.ASSET_CLASS
                object.closePrice = data.CLOSEPRICE
                object.cmotsCoCode = data.CMOTS_COCODE
                object.coname = data.CONAME
                object.createdDate = data.CREATED_DATE
                object.dprHigh = data.DPRHIGH
                object.dprLow = data.DPRLOW
                object.exchange = data.EXCHANGE
                object.exchangeSecurityId = data.EXCHANGESECURITYID
                object.exchangeSerires = data.EXCHANGE_SERIES
                object.exchangeStatus = data.EXCHANGE_STATUS
                object.exchangeSymbol = data.EXCHANGE_SYMBOL
                object.expiryDate = data.EXPIRYDATE
                object.highPrice = data.HIGHPRICE
                object.illiquidSec = data.ILLIQUID_SEC
                object.instrumentType = data.INSTRUMENTTYPE
                object.isinCode = data.ISIN_CODE
                object.lotSize = data.LOWPRICE
                object.lowPrice = data.LOWPRICE
                object.nriAllowed = data.NRI_ALLOWED
                object.odInTokenId = data.ODIN_TOKEN_ID
                object.openPrice = data.OPENPRICE
                object.optionType = data.OPTIONTYPE
                object.scriptId = data.SCRIPTID
                object.searchable = data.SEARCHABLE
                object.searchPriority = data.SEARCH_PRIORITY
                object.segment = data.SEGMENT
                object.strikePrice = data.STRIKEPRICE
                object.tcsTokenId = data.TCS_TOKEN_ID
                object.tickSize = data.TICKSIZE
                object.tSettDay = data.T_SETT_DAY
                object.underlying = data.UNDERLYING
                object.updatedDate = data.UPDATED_DATE
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
     
//        let searchPredicate = NSPredicate(format: "SELF.searchable CONTAINS[c] %@", "20MICRONS")
//        fetchRequest.predicate = searchPredicate

        do {
            let results = try context.fetch(fetchRequest)
            let securityData  = results as! [SecurityData]

//            let array = (results as NSArray).filtered(using: searchPredicate)
//            let securityData  = array as! [SecurityData]

            self.allData = securityData
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

extension ReadDBFileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        /*
         
         // MARK: Approach 1
         self.view.activityStartAnimating(activityColor: .magenta, backgroundColor: .white)

        var filteredData = [SecurityData]()
        if string.isEmpty{
            search = String(search.dropLast())
        }else{
            search=textField.text!+string
        }
        self.getRegexString(searchString: search.lowercased())
        print("search :", search, "regex :", regex)
        if search.count > 0{
            for obj in allData {
                let searchable = obj.searchable
                if self.checkSearchStringCharHas(compareString: (searchable ?? "").lowercased()) {
                    filteredData.append(obj)
                }
            }
            self.view.activityStopAnimating()
            datasourceTable.array = filteredData
            self.dataTable.reloadData()
        }else{
            datasourceTable.array = allData
            self.view.activityStopAnimating()

            self.dataTable.reloadData()
        }
         */

        
        // MARK: Approach 2
         if string.isEmpty{
             search = String(search.dropLast())
         }else{
             search=textField.text!+string
         }
        if search.count > 0{
            let predicate = NSPredicate(format: "SELF.exchangeSymbol CONTAINS[c] %@", search)
            let securityData  = (allData as NSArray).filtered(using: predicate) as! [SecurityData]
            datasourceTable.array = securityData
            self.dataTable.reloadData()
        }else{
            datasourceTable.array = allData
            self.dataTable.reloadData()
        }
        
        self.dataTable.reloadData()
        return true
    }


}

extension ReadDBFileViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            self.setUpTableCell(data: allData)
            return
        }
        
        /*
        // MARK: Approach 1
        self.getRegexString(searchString: searchText.lowercased())
        var filteredData = [SecurityData]()
        print("search :", searchText, "regex :", self.regex)
        for obj in self.allData {
            let searchable = obj.exchangeSymbol
            if self.checkSearchStringCharHas(compareString: (searchable ?? "").lowercased()) {
                filteredData.append(obj)
            }
        }
        self.view.activityStopAnimating()
        self.datasourceTable.array = filteredData
        self.dataTable.reloadData()
        */
        
        // MARK: Approach 2
        self.searchDataFromCoreData(searchString: searchText)
    }
    
    
    func getRegexString(searchString: String) {
        var str :String = ""
        let count = searchString.count
        for index in 0..<count {
            let i = searchString.index(searchString.startIndex, offsetBy: index, limitedBy: searchString.endIndex)
            if str.count == 0{
                str = "(^|[a-z0-9\\u4e00-\\u9fa5])+[\(searchString[i!])]"
            } else {
                str = "\(str)+[a-z0-9\\u4e00-\\u9fa5]*[\(searchString[i!])]"
            }
        }
        regex = "\(str)+[a-z0-9\\u4e00-\\u9fa5]*$"
    }
    func checkSearchStringCharHas(compareString: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: compareString)
        return isValid
    }
    
    // MARK:- searching data from coredata
    func searchDataFromCoreData(searchString: String) {
        
        var filteredData = [SecurityData]()

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SecurityData")
     
        let searchPredicate = NSPredicate(format: "SELF.searchable CONTAINS[c] %@", searchString)
        fetchRequest.predicate = searchPredicate

        do {
            let results = try context.fetch(fetchRequest)
            filteredData  = results as! [SecurityData]

            self.setUpTableCell(data: filteredData)
            self.dataTable.reloadData()
            print("SecurityMasterModel count : ", filteredData.count)
            
            for obj in filteredData {
                print("SecurityMasterModel Searchable : ", obj.searchable)

            }

        }catch let err as NSError {
            print(err.debugDescription)
        }
    }
}

extension ReadDBFileViewController {
     func resetTimer() {
        stopDisplayLink()
        elapsed = 0
        priorElapsed = 0
        updateUI()
    }

     func startTimer() {
        if displayLink == nil {
            startDisplayLink()
        }
    }

     func pauseTimer() {
        priorElapsed += elapsed
        elapsed = 0
        displayLink?.invalidate()
    }
    
    func startDisplayLink() {
        startTime = CACurrentMediaTime()
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }

    func stopDisplayLink() {
        displayLink?.invalidate()
    }

    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        guard let startTime = startTime else { return }
        elapsed = CACurrentMediaTime() - startTime
        updateUI()
    }

    func updateUI() {
        let totalElapsed = elapsed + priorElapsed

        let hundredths = Int((totalElapsed * 100).rounded())
        let (minutes, hundredthsOfSeconds) = hundredths.quotientAndRemainder(dividingBy: 60 * 100)
        let (seconds, milliseconds) = hundredthsOfSeconds.quotientAndRemainder(dividingBy: 100)

    //    timerLbl.text = "\(String(minutes))" + ": \(String(format: "%02d", seconds))"  + ": \(String(format: "%02d", milliseconds))"
        
        timerLbl.text = "\(String(format: "%02d", seconds))"  + ": \(String(format: "%02d", milliseconds))"

    }

}
