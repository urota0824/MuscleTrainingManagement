//
//  SettingTopViewController.swift
//  MuscleTrainingManagement
//
//  Created by yutaro on 2022/12/20.
//

import UIKit

class SettingTopViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "設定"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButton(_:)))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButton(_ sender: UIBarButtonItem){
        
        let userDefaults = UserDefaults()
        
        guard let callApparatusArray:[String] = userDefaults.array(forKey: "apparatus") as? [String] else {
            checkUserDefaults()
            return
        }
        
        guard let callPartArray: [String] = userDefaults.array(forKey: "part") as? [String] else {
            checkUserDefaults()
            return
        }
        
        guard let callPlaceArray: [String] = userDefaults.array(forKey: "place") as? [String] else {
            checkUserDefaults()
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func checkUserDefaults() {
        
        let myDaialog = UIAlertController(title: "未設定の項目があります。", message: "アプリを使用するには全ての項目を設定する必要があります。", preferredStyle: .alert)
        myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
        self.present(myDaialog, animated: true, completion: nil)
    }
    
    @IBAction func apparatusSelectButton(_ sender: Any) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SettingEditViewController") as! SettingEditViewController
        nextVc.settingFlag = 1
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func partSelectButton(_ sender: Any) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SettingEditViewController") as! SettingEditViewController
        nextVc.settingFlag = 2
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func placeSelectButton(_ sender: Any) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SettingEditViewController") as! SettingEditViewController
        nextVc.settingFlag = 3
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
}
