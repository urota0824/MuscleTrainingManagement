//
//  SettingEditViewController.swift
//  MuscleTrainingManagement
//
//  Created by yutaro on 2022/12/20.
//

import UIKit

class SettingEditViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var settingTextField: UITextField!
    
    var settingFlag: Int = 0
    var valueArray: [String] = []
    var savedFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if settingFlag == 1 {
            navigationItem.title = "「器具名称」設定"
            
        } else if settingFlag == 2 {
            navigationItem.title = "「部位」設定"
            
        } else if settingFlag == 3 {
            navigationItem.title = "「箇所」設定"
            
        } else if settingFlag == 4 {
            navigationItem.title = "「重さ」設定"
            
        } else if settingFlag == 5 {
            navigationItem.title = "「回数」設定"
        }
        
        defaultArray()
        
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButton(_:)))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButton(_ sender: UIBarButtonItem){
        
        if savedFlag == 1 {
            
            let dialog = UIAlertController(
                title: "前の画面に戻りますか？",
                message: "保存されていない入力内容は破棄されます。",
                preferredStyle: .alert
            )
            
            dialog.addAction(UIAlertAction(title: "はい", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            
            dialog.addAction(UIAlertAction(title: "いいえ", style: .default, handler: nil))
            
            self.present(dialog, animated: true, completion: nil)
            
        } else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func defaultArray() {
        
        valueArray.removeAll()
        
        let userDefaults = UserDefaults()
        
        if settingFlag == 1 {
            guard let apparatusArray: [String] = userDefaults.array(forKey: "apparatus") as? [String] else {return}
            valueArray.append(contentsOf: apparatusArray)
            
        } else if settingFlag == 2 {
            guard let partArray: [String] = userDefaults.array(forKey: "part") as? [String] else {return}
            valueArray.append(contentsOf: partArray)
            
        } else if settingFlag == 3 {
            guard let placeArray: [String] = userDefaults.array(forKey: "place") as? [String] else {return}
            valueArray.append(contentsOf: placeArray)
            
        } else if settingFlag == 4 {
            guard let weightArray: [String] = userDefaults.array(forKey: "weight") as? [String] else {return}
            valueArray.append(contentsOf: weightArray)
            
        } else {
            guard let stretchCountArray: [String] = userDefaults.array(forKey: "stretchCount") as? [String] else {return}
            valueArray.append(contentsOf: stretchCountArray)
        }
    }
    
    @IBAction func settingAddButton(_ sender: Any) {
        
        if settingTextField.text != "" {
            
            savedFlag = 1
            guard let settingValue = settingTextField.text else {return}
            valueArray.append(settingValue)
            settingTableView.reloadData()
            
            // キーボードを閉じてTextFieldを空欄に戻す
            settingTextField.endEditing(true)
            settingTextField.text = ""
            
        } else {
            
            return
        }
    }
    
    @IBAction func settingSaveButton(_ sender: Any) {
        
        if valueArray != [] {
            
            savedFlag = 0
            var saveValueArray: [String] = []
            
            for array in valueArray {
                
                saveValueArray.append(array)
            }
            
            let userDefaults = UserDefaults()
            
            if settingFlag == 1 {
                userDefaults.set(saveValueArray, forKey: "apparatus")
            } else if settingFlag == 2 {
                userDefaults.set(saveValueArray, forKey: "part")
            } else if settingFlag == 3 {
                userDefaults.set(saveValueArray, forKey: "place")
            } else if settingFlag == 4 {
                userDefaults.set(saveValueArray, forKey: "weight")
            } else {
                userDefaults.set(saveValueArray, forKey: "stretchCount")
            }
            
            saveValueArray.removeAll()
            
            let myDaialog = UIAlertController(title: "保存しました。", message: nil, preferredStyle: .alert)
            myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
            self.present(myDaialog, animated: true, completion: nil)
            
        } else {
            
            let myDaialog = UIAlertController(title: "保存に失敗しました。", message: "最低でも1つは項目を追加してください。", preferredStyle: .alert)
            myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
            self.present(myDaialog, animated: true, completion: nil)
            return
        }
    }
}

extension SettingEditViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if valueArray != [] {
            return valueArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingEditViewControllerCell", for: indexPath)
        cell.textLabel?.text = valueArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

extension SettingEditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { action, _ ,completionHandler in
            
            let alert = UIAlertController(title: "選択したデータを削除しますか?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                
                self.savedFlag = 1
                
                // removeで該当の要素を削除しないと落ちる
                self.valueArray.remove(at: indexPath.row)
                self.settingTableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in
                
                // セルの「削除」の表示を閉じる
                completionHandler(true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        // 定義したアクションをセット
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
