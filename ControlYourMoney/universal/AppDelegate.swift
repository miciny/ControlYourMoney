//
//  AppDelegate.swift
//  ControlYourMoney
//
//  Created by maocaiyuan on 15/12/18.
//  Copyright © 2015年 maocaiyuan. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backTime: NSDate?
    var foreTime: NSDate?
    var vc: TabbarViewController?
    
    var manager: Manager?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setUpWindow()  //初始化界面
        manager = NetWork.getDefaultAlamofireManager() //初始化manager
        touchID()
        InitData.calculateCredit() // 计算信息还款信息
        
        initUserInfo()
        
        return true
    }
    
    //设置主页
    func setUpWindow(){
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        vc = TabbarViewController()
        self.window!.rootViewController = vc
        
    }

    //进入touch ID页
    func touchID(){
        let vcc = TouchIDViewController()
        vc!.presentViewController(vcc, animated: false, completion: nil)
    }
    
    
    //初始化用户信息
    func initUserInfo(){
        if InitData.userExsit() {
            let userStr = ArrayToJsonStr.getUserDataArrayToJsonStr()
            postUserInfoToDB(userStr)
        }else{
            getUserInfoFromDB()
        }
    }
    
    //从db获取数据
    func getUserInfoFromDB(){
        manager!.request(.GET, NetWork.userUrl , parameters: NetWork.userGetParas)
            .responseJSON { response in
                let toast = MyToastView()
                
                switch response.result{
                    
                case .Success:
                    let code = String((response.response?.statusCode)!)
                    let a = code.substringToIndex(code.startIndex.advancedBy(1))
                    
                    if a == "2"{
                        let data = JSON(response.result.value!)
                        let json = data["data"][0]
                        
                        let dataModel = JsonToModel.getUserJsonDataToModel(json)
                        InsertData.initUserData(dataModel)
                        print("下载用户信息成功！")
                    }else{
                        let str = getErrorCodeToString(a)
                        toast.showToast("\(str)")
                    }
                    
                case .Failure:
                    if response.response == nil{
                        toast.showToast("无法连接服务器！")
                    }else{
                        toast.showToast("上传数据失败！")
                    }
                }
        }
    }
    
    //post用户信息数据到db
    func postUserInfoToDB(str: String){
        
        let paras = [
            "data": strToJson(str)
        ]
        
        self.manager!.request(.POST, NetWork.userUrl, parameters: paras, encoding: .JSON)
            .responseJSON { response in
                let toast = MyToastView()
                
                switch response.result{
                    
                case .Success:
                    let code = String((response.response?.statusCode)!)
                    let a = code.substringToIndex(code.startIndex.advancedBy(1))
                    
                    if a == "2"{
                        print("上传用户信息成功！")
                    }else{
                        let str = getErrorCodeToString(a)
                        toast.showToast("\(str)")
                    }
                    
                case .Failure:
                    if response.response == nil{
                        toast.showToast("无法连接服务器！")
                    }else{
                        toast.showToast("上传数据失败！")
                    }
                }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        backTime = getTime()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        foreTime = getTime()
        
        let seconds = foreTime?.timeIntervalSinceDate(backTime!)
        if seconds > 600 {
            touchID()
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.maocaiyuan.ControlYourMoney" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ControlYourMoney", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

