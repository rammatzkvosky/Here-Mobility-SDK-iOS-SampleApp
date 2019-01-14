//
// Copyright © 2018 HERE Global B.V. All rights reserved.
//

import UIKit

import HereSDKCoreKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var verifyPhoneNumberTextField: UITextField!

    @IBOutlet weak var nextButton: UIButton!
    var shouldHideNextButton : Bool = false

    @IBOutlet weak var loginView: UIView!
    var shouldHideLoginView = false
    
    @IBOutlet weak var verificationView: UIView!
    var shouldHideVerificationView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.isHidden = shouldHideNextButton
        loginView.isHidden = shouldHideLoginView
        verificationView.isHidden = shouldHideVerificationView
        checkForHereSDKUser()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let SDKManager = HereSDKManager.shared, let _ = SDKManager.user else{
            UIAlertController.show("User was not set", from: self)
            return false
        }

        return true
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if let userID = userIDTextField.text{
            self.loginWith(userID: userID)
        }
    }

    @IBAction func requestVerificationCodePressed(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber.count > 0 else {
            UIAlertController.show("phone number text is empty", from: self)
            return
        }

        self.requestVerificationCodeFor(number: phoneNumber)
    }

    @IBAction func verifyPhoneNumberPressed(_ sender: Any) {
        guard let phoneNumber = phoneNumberTextField.text, let verificationCode = verifyPhoneNumberTextField.text, phoneNumber.count > 0, verificationCode.count > 0 else {
            UIAlertController.show("phone number or verification code missing", from: self)
            return
        }

        verifyVerificationCode(verificationCode: verificationCode, phoneNumber: phoneNumber)
    }

    private func checkForHereSDKUser() {
        if let userId = HereSDKManager.shared?.user?.userId{
            userIDTextField.text = userId
            if let verified = HereSDKManager.shared?.isPhoneNumberVerified(), verified == true{
                UIAlertController.show("you are verified", from: self)
            }
        }
    }

    // required data to get results (HereSDKUser, phone verification)
    // MARK: generate user credentials

    private func loginWith(userID: String){
        let userExpirationInterval: Int32 = 60 * 60 * 24 * 365 // 1 year
        let date = Date().addingTimeInterval(TimeInterval(userExpirationInterval))

        // Generating user token with expiration time of one year from the current date.
        self.generateUserCredentialsWithUser(userId: userID, expiration: UInt32(date.timeIntervalSince1970))
    }

    private func generateHash(appKey: String, userId: String, expiration:UInt32, key: String) -> String? {
        return HMACGenerator.hmacSHA256(from: appKey, userId: userId, expiration: Int32(expiration), withKey: key)
    }

    private func generateUserCredentialsWithUser(userId : String, expiration : UInt32){
        if let infoDictionary = Bundle.main.infoDictionary{
            if let appKey = infoDictionary["HereMobilitySDKAppId"] as? String, let appSecret = infoDictionary["HereMobilitySDKAppSecret"] as? String {
                let hashString = generateHash(appKey: appKey, userId: userId, expiration: expiration, key: appSecret)
                HereSDKManager.shared?.user = HereSDKUser(id: userId, expiration: Date(timeIntervalSince1970 : TimeInterval(expiration)), verificationHash: hashString!)
                if let _ = HereSDKManager.shared?.user{
                    UIAlertController.show("Login success", from: self)
                }
                else{
                    UIAlertController.show("Login fail", from: self)
                }
            }
        }
    }

    // MARK: phone verification

    private func requestVerificationCodeFor(number: String){
        HereSDKManager.shared?.sendVerificationSMS(number, withHandler: { [weak self] (error) in
            if let error = error{
                UIAlertController.show(error.localizedDescription, from: self!)
            }
            else{
                UIAlertController.show("Verification code sent", from: self!)
            }
        })
    }

    private func verifyVerificationCode(verificationCode: String, phoneNumber: String){
        HereSDKManager.shared?.verifyPhoneNumber(phoneNumber, pinCode: verificationCode, withHandler: { [weak self] (error) in
            if (error != nil){
                UIAlertController.show((error?.localizedDescription)!, from: self!)
            }
            else{
                UIAlertController.show("Verification success", from: self!)
            }
        })
    }
}

extension AuthorizationViewController : UITextFieldDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
