//
//  LoginToTavantViewController.swift
//  TavantPool
//
//  Created by Kevin Vishal on 10/29/16.
//  Copyright © 2016 TuffyTiffany. All rights reserved.
//

import UIKit
import AnimatedTextInput
import FLAnimatedImage
//import OpinionzAlertView
//import KRProgressHUD
//import PopupViewController
import ReachabilitySwift
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



class LoginToTavantViewController: UIViewController,AnimatedTextInputDelegate {
    
    var screenWidth = UIScreen.main.bounds.width
    var myTripsNetworkManager : MyTripsNetworkManager  = MyTripsNetworkManager()
    var globalTxtViewRefrence: AnimatedTextInput!
    var reachability: Reachability?
    
    @IBOutlet weak var loginUserName: AnimatedTextInput!
    @IBOutlet weak var loginPassword: AnimatedTextInput!
    @IBOutlet weak var signUpPhoneNmber: AnimatedTextInput!
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var blurImageView: UIImageView!
    
    
    @IBOutlet weak var leadingLoginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backBtnwidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var backButtonBaseView: UIView!
    @IBOutlet weak var loginBaseView: UIView!
    
    @IBOutlet weak var topLoginViewConstraint: NSLayoutConstraint!
    // MARK: Button Actions
    
    @IBAction func signIn(_ sender: AnyObject) {
        //print("\(loginUserName.text!)")
        self.globalTxtViewRefrence.resignFirstResponder()
        
        
        if (self.checkNetworkStatus() == true) {
            if( validateSignIn()) {
                
                //Login
                let username =   AppCacheManager.sharedInstance.getLoggedInUserName()
                
                self.signupWithCredentials(username, sentTitle: "")
                
            }
        }
        else {
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
        @IBAction func showSignInScreen(_ sender: AnyObject) {
        // self.globalTxtViewRefrence.resignFirstResponder()
//        self.showSignIn()
    }
    
    
    
    
    
    // MARK: Base64 encoding
    
//    func encodePassword(password : String) -> String {
//        let plainData = (password as NSString).dataUsingEncoding(NSUTF8StringEncoding)
//        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
//        print("\(base64String)")
//        return base64String
//    }
//    
    
    
    
    // MARK: Login / Sign up
    
    
    
    func trimTheEmail(_ email : String) -> String {
        var emailTrimed = ""
        //let emailTrimed = email.stringByReplacingOccurrencesOfString("@tavant.com", withString: "")
        let emailComponents  = email.components(separatedBy: "@")
        if emailComponents.count > 0 {
            emailTrimed = emailComponents[0]
        }
        return emailTrimed
    }
    
    
    func appendTheEmail(_ email : String) -> String {
        let trimed = self.trimTheEmail(email)
        let emailappened = "\(trimed)@tavant.com"
        return emailappened
    }
    
    
    
   /* func loginWithCredentials() -> Void {
        
     //   let encodedString = self.encodePassword(self.loginPassword.text!)
        
        //let loginParams = ["email" : self.loginUserName.text!,"password" : self.loginPassword.text!]
        
        let trimEmail = self.trimTheEmail(self.loginUserName.text!)
        
        
        let loginParams = ["userId" : trimEmail,"password" : self.loginPassword.text!]
        
        PoolContants.sharedInstance.show()
        
//         [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 //       [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

        
        myTripsNetworkManager.loginToTavantPool(loginParams) { (loginResponse : AnyObject?, error : NSError?) in
            var alertMess  = ""
            var alertTitle  = ""
            
            dispatch_async(dispatch_get_main_queue(), {
              //  PoolContants.sharedInstance.dismiss()
                if (error == nil) && (loginResponse != nil) {
                    
                    let responseDictionary = loginResponse as! NSDictionary
                    
                    
                    /*
                     authenticate = 1;
                     mailId = "kevin.saldanha@tavant.com";
                     title = "Technical Lead";
                     userName = "Kevin Vishal Saldanha";
                     userType = tavant;
 
 */
                    if responseDictionary["authenticate"] as! Int == 1 {
                        alertTitle = ""
                        alertMess = "Successfully logged in."
                        
                        //let profileDict : NSDictionary = responseDictionary["profile"] as! NSDictionary
                        
                        
                     //   AppCacheManager.sharedInstance.saveUserLoggedInstatus([KSAVEDPHONENUMBERLOCAL : profileDict["phonenumber"]!, KSAVEDEMAILLOCAL : profileDict["email"]!])
                        
                           let usernameStr =  ((responseDictionary["userName"]) != nil ) ? responseDictionary["userName"]! as? String : "NA"
                            let jobTitleStr =  ((responseDictionary["title"]) != nil ) ? responseDictionary["title"]! as? String : "NA"
                        
                      
                        
                       self.signupWithCredentials(usernameStr!, sentTitle:jobTitleStr!)
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            PoolContants.sharedInstance.dismiss()
                        })
                        alertTitle = "Login failed"
                        alertMess = "Please check your email and password"
                        let alert = PopupViewController(title: alertTitle, message: alertMess)
                        alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                            
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        PoolContants.sharedInstance.dismiss()
                        })
                    alertTitle = ""
                    alertMess = "Login failed"
                    let alert = PopupViewController(title: alertTitle, message: alertMess)
                    alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                        
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                
                
                
            })
        }
    }
    
    
  */
    
    //after tavant login lets cal sign up
    
    
    func signupWithCredentials(_ sentUserName : String,sentTitle : String) -> Void {
        
        //  var actionTitle = "Ok"
        
    //    let encodedString = self.encodePassword(self.signUpPassword.text!)
        
        let emailStr = self.appendTheEmail(self.loginUserName.text!)
   //     let phoneNumber = self.signUpPhoneNmber.text!
     
        //let signUpParams = ["email" : self.signUpUserName.text!,"password" : self.signUpPassword.text!,"phonenumber" : self.signUpPhoneNmber.text!]
        let signUpParams = ["email" : emailStr,"phonenumber" : self.signUpPhoneNmber.text!,"username" : sentUserName,"jobtitle" : sentTitle]
        
   //     PoolContants.sharedInstance.show()
        
        myTripsNetworkManager.signInToTavantPool(signUpParams as (Dictionary<String, AnyObject>)?) { (loginResponse : AnyObject?, error : NSError?) in
            var alertMess  = ""
            var alertTitle  = ""
            
            DispatchQueue.main.async(execute: {
                PoolContants.sharedInstance.dismiss()
                
                if (error == nil) && (loginResponse != nil) {
                    
                    
                    
                    let responseDictionary = loginResponse as! NSDictionary
                    
                    if responseDictionary["status_code"] as! Int == 200 {
                        
                        alertTitle = ""
                        alertMess = responseDictionary["status_message"] as! String
                        let alert = PopupViewController(title: alertTitle, message: alertMess)
                        
                        let profileDict : NSDictionary = responseDictionary["profile"] as! NSDictionary
                        
                        
                        alert.addAction(PopupAction(title: "Start Sharing Food...", type: .positive, handler: {(action : PopupAction) in
                            
                            //                        let cacheDefaults : NSUserDefaults = NSUserDefaults.init(suiteName: kCacheSuitName)!
                            //                        cacheDefaults.setObject("aaa@bbb.com", forKey: KSAVEDEMAILLOCAL)
                            //                        cacheDefaults.synchronize()
                            AppCacheManager.sharedInstance.saveUserLoggedInstatus([KSAVEDPHONENUMBERLOCAL : profileDict["phonenumber"]!, KSAVEDEMAILLOCAL : profileDict["email"]!,KSAVEDUSERNAME : profileDict["username"]!,KSAVEDUSERROLE : ""])
                            
        AppCacheManager.sharedInstance.resetFilter()
                            
                            AppCacheManager.sharedInstance.showHomeTabScreen()
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else {
                        alertTitle = "Sign-In failed"
                        alertMess = responseDictionary["status_message"] as! String
                        let alert = PopupViewController(title: alertTitle, message: alertMess)
                        alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                            
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                }
                else {
                    alertTitle = ""
                    alertMess = "Sign-Up failed"
                    let alert = PopupViewController(title: alertTitle, message: alertMess)
                    alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                        
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
        }
    }
    
    
    // MARK: Validation
    
    
    func validateSignIn() -> Bool {
        
        var actionTitle = "Ok"
        var alertMessage = ""
        
  //      if ((loginUserName!.text != nil) || (loginUserName!.text?.isEmpty != true)) {
            //if (loginUserName!.text?.isEmpty)! {
            
            if (self.isValidEmail(loginUserName.text!) ==  false) {
                alertMessage = "Please provide valid Email."
                actionTitle = "Ok"

            }
//}
//        else if ((loginUserName.text?.containsString("@")) == true) {
//            
//            if (self.isValidEmail(loginUserName.text!) ==  false)
//            {
//                alertMessage = "Please provide valid Email."
//                actionTitle = "Ok"
//            }
//        }
        else if (loginPassword!.text?.characters.count) < 6 {
            alertMessage = "Password should be minimum of 6 characters."
            actionTitle = "Ok"
        }
        else if validatePhone(signUpPhoneNmber.text!) == false {
            
            alertMessage = "Please provide valid Phone number."
            actionTitle = "Ok"
        }
        
        if !alertMessage.isEmpty  {
            //            let alertPopup : OpinionzAlertView = OpinionzAlertView.init(title: "", message: alertMessage, cancelButtonTitle: "OK", otherButtonTitles: nil)
            //            //alertPopup.color = UIColor.init(red: 0.61, green: 0.35, blue: 0.71, alpha: 1)
            //            alertPopup.iconType = OpinionzAlertIconWarning
            //            alertPopup.show()
            
            let alert = PopupViewController(title: "", message: alertMessage)
            alert.addAction(PopupAction(title: actionTitle, type: .positive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    
    
    func validatePhone(_ value: String) -> Bool {
        //  let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        //        let PHONE_REGEX =   "^((\\+)|(00))[0-9]{6,14}$"
        //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        //        let result =  phoneTest.evaluateWithObject(value)
        //        return result
        
        
        /*
         NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
         
         NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
         
         return [string isEqualToString:filtered];
         */
        let charcter  = CharacterSet(charactersIn: "0123456789").inverted
        
        var filtered:String = ""
        let inputString:[String] = value.components(separatedBy: charcter)
        //filtered = inputString.componentsJoined(by: "") as NSString!
        filtered = inputString.joined(separator: "")
        
        if ((value == filtered) && (value.characters.count == 10)) {
            return true
        }
        return false
    }
    

    
    func isValidEmail(_ testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    
    func isPasswordSame(_ password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }
        else{
            return false
        }
    }
    
    
    func isPwdLenth(_ password: String , confirmPassword : String) -> Bool {
        if password.characters.count <= 6 && confirmPassword.characters.count <= 6{
            return true
        }
        else{
            return false
        }
    }
    
    
    // MARK: View Life Cycle Methods
    
    
    func reachabiltyInitializatin() -> Void {
//        do {
//            reachability = try Reachability.reachabilityForInternetConnection()
//        } catch {
//            print("Unable to create Reachability")
//            return
//        }
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(HomeTabbBarController.reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
//        do{
//            try reachability?.startNotifier()
//        }catch{
//            print("could not start reachability notifier")
//        }
        let reachability = Reachability()!
        
        //declare this inside of viewWillAppear
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTabbBarController.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    // MARK: Reachability
    
    func reachabilityChanged(_ note: Notification) {
        
        let reachability = note.object as! Reachability
        var alertText  = ""
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                //print("Reachable via WiFi")
                
            } else {
                //print("Reachable via Cellular")
            }
            alertText = "Network Connected."
            //  HotBox.sharedInstance().showMessage(NSAttributedString(string: alertText), ofType: "failure", withDelegate: self)
        } else {
            // //print("Network not reachable")
            alertText = "Lost Network Connection."
            //HotBox.sharedInstance().showMessage(NSAttributedString(string: alertText), ofType: "failure", withDelegate: self)
            let alert = PopupViewController(title: "Network error !", message: "Please check your internet connection.")
            alert.addAction(PopupAction(title: "Ok", type: .positive, handler: {(action : PopupAction) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = UIScreen.main.bounds.width
        self.globalTxtViewRefrence = self.loginUserName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialiseViewStyles()
        self.reachabiltyInitializatin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func initialiseViewStyles() -> Void {
        
        self.loginUserName.accessibilityLabel = "standard_text_input"
        self.loginUserName.placeHolderText = "Enter your email ID"
        self.loginUserName.text = "kevinvishal347@gmail.com"
        //        self.loginUserName.text = "kevin.saldanha"
        self.loginUserName.style  = CustomTextInputStyle1()
        self.loginUserName.delegate = self;
        
        self.loginPassword.placeHolderText = "Enter your Password"
        self.loginPassword.type = .password
        //self.loginPassword.text = "123456"
        self.loginPassword.text = "Welcome123"
        self.loginPassword.style  = CustomTextInputStyle1()
        self.loginPassword.delegate = self;

        self.signUpPhoneNmber.placeHolderText = "Phone Number"
        self.signUpPhoneNmber.type = .numeric
        self.signUpPhoneNmber.text = "8149002674"
        self.signUpPhoneNmber.style  = CustomTextInputStyle1()
        self.signUpPhoneNmber.delegate = self;
        
        
        self.view.layoutIfNeeded()
        
    }
    
    
    // MARK: Touches Delegates
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.topLoginViewConstraint.constant = 15.0
        self.globalTxtViewRefrence.resignFirstResponder()
    }
    
    
    
    func checkNetworkStatus() -> Bool {
         /*   var isAvailable  = false;
        
        do {
            self.reachability = try Reachability.reachabilityForInternetConnection()
            
            switch reachability!.currentReachabilityStatus{
            case .reachableViaWiFi:
                isAvailable = true
            case .reachableViaWWAN:
                isAvailable = true
            case .notReachable:
                isAvailable = false
            }
        }
        catch let error as NSError{
            print(error.debugDescription)
        }
        
        return isAvailable;
 */
        var isAvailable  = false;
        
        let reachability = Reachability()!
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
                isAvailable = true
            } else  if reachability.isReachableViaWWAN {
                print("Reachable via WWAN")
                isAvailable = true
            } else {
                print("Reachable via Cellular")
                isAvailable = true
            }
        } else {
            print("Network not reachable")
            isAvailable = false
        }
        return isAvailable
    }
    
    // MARK: Text Input delegates
    
    func animatedTextInputDidChange(_ animatedTextInput: AnimatedTextInput) {
        if animatedTextInput == self.loginUserName {
            self.loginUserName.text = self.loginUserName.text?.lowercased()
            self.loginUserName.style  = CustomTextInputStyle1()
        }
    }
    
    func animatedTextInputDidBeginEditing(_ animatedTextInput: AnimatedTextInput) {
        self.globalTxtViewRefrence  = animatedTextInput
        
        if animatedTextInput == self.loginPassword {
            self.topLoginViewConstraint.constant = -55.0
        }
        
        if animatedTextInput == self.signUpPhoneNmber {
            self.topLoginViewConstraint.constant = -110.0
        }
        //        else if animatedTextInput == self.signUpConfirmPassword {
        //            self.topSignUPViewConstraint.constant = -125.0
        //        }
        self.view.layoutIfNeeded()
    }
    
    func animatedTextInputShouldReturn(_ animatedTextInput: AnimatedTextInput) -> Bool {
        self.topLoginViewConstraint.constant = 15.0
        animatedTextInput.resignFirstResponder()
        return true
    }
    
    func animatedTextInputDidEndEditing(_ animatedTextInput: AnimatedTextInput) {
        self.topLoginViewConstraint.constant = 15.0
        animatedTextInput.resignFirstResponder()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    

    func removeBlurView() -> Void {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            // self.blurImageView.alpha = 0.0
            self.blurImageView.isHidden = true
            
        }, completion: { (stop :Bool) in
            
        }) 
    }
}






struct CustomTextInputStyle1: AnimatedTextInputStyle {
    
    /************************************************/
    /*******$ REDUCE SIZE OF FONT TO USE THIS $*********/
    /************************************************/
    
    
    //    let activeColor = UIColor.orangeColor()
    //    let inactiveColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
    let activeColor =  PoolContants.appPaleGreenColor// UIColor(red: 81.0/255.0, green: 229.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    let inactiveColor = UIColor.white.withAlphaComponent(0.9)
    let errorColor = PoolContants.appPaleGreenColor //UIColor(red: 81.0/255.0, green: 229.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    let textInputFont = UIFont.systemFont(ofSize: 18)
    let textInputFontColor = UIColor.white
    let placeholderMinFontSize: CGFloat = 14
    let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 14)
    let leftMargin: CGFloat = 0
    let topMargin: CGFloat = 20
    let rightMargin: CGFloat = 0
    let bottomMargin: CGFloat = 10
    let yHintPositionOffset: CGFloat = 7
}
