//
//  NewRegistrationViewController.swift
//  MuscleTrainingManagement
//
//  Created by yutaro on 2022/12/11.
//

import UIKit
import RealmSwift

class NewRegistrationViewController: UIViewController {
    
    @IBOutlet weak var registrDateTextField: UITextField!
    @IBOutlet weak var registrTableView: UITableView!
    
    var newRegistrArray: [RecordModel] = []
    var effectiveDatePicker: UIDatePicker = UIDatePicker()
    var savedFlag = 0
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "新規登録"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButton(_:)))
        navigationItem.leftBarButtonItem = backButton
        
        registrTableView.delegate = self
        registrTableView.dataSource = self
        registrTableView.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCell")
        
        picker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        registrTableView.reloadData()
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
    
    @IBAction func addButton(_ sender: Any) {
        
        savedFlag = 1
        view.endEditing(true)
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        nextVc.rootCheckFlag = 1
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let allRecordModel = AllRecordModel()
        
        if registrDateTextField.text != "" {
            
            allRecordModel.effectiveDate = registrDateTextField.text!
            
        } else {
            
            let myDaialog = UIAlertController(title: "日付が未入力です", message: nil, preferredStyle: .alert)
            myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
            self.present(myDaialog, animated: true, completion: nil)
            return
        }
        
        if newRegistrArray != [] {
            
            allRecordModel.allRecordList.append(objectsIn: newRegistrArray)
            savedFlag = 0
            
            // Realmに保存する
            do{
                let realm = try Realm()
                try! realm.write {
                    realm.add(allRecordModel)
                    
                    let myDaialog = UIAlertController(title: "保存が完了しました。", message: nil, preferredStyle: .alert)
                    myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
                    self.present(myDaialog, animated: true, completion: nil)
                }
            } catch {
                
                print("Save is Faild")
            }
        } else {
            
            let myDaialog = UIAlertController(title: "トレーニング項目が未入力です", message: nil, preferredStyle: .alert)
            myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
            self.present(myDaialog, animated: true, completion: nil)
            return
        }
    }
    
    func picker() {
        
        // datePickerの設定
        effectiveDatePicker.datePickerMode = UIDatePicker.Mode.date
        
        // これを記述しないとドラムロールの形にならない
        effectiveDatePicker.preferredDatePickerStyle = .wheels
        effectiveDatePicker.timeZone = NSTimeZone.local
        effectiveDatePicker.locale = Locale.current
        
        // 決定・キャンセル用ツールバーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: true)
        
        //inputView入力項目定義
        registrDateTextField.inputView = effectiveDatePicker
        //入力エリアアクセス宣言
        registrDateTextField.inputAccessoryView = toolbar
        
        // デフォルト日付（本日になるように設定）
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        registrDateTextField.text = "\(formatter.string(from: Date()))"
    }
    
    @objc func donePicker() {
        
        savedFlag = 1
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        registrDateTextField.text = "\(formatter.string(from: effectiveDatePicker.date))"
        
        view.endEditing(true)
    }
    
    @objc func cancelPicker() {
        
        view.endEditing(true)
    }
}

extension NewRegistrationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newRegistrArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell") as! RecordTableViewCell
        
        cell.apparatusLabel.text = newRegistrArray[indexPath.row].apparatus
        cell.partLabel.text = newRegistrArray[indexPath.row].part
        cell.placeLabel.text = newRegistrArray[indexPath.row].place
        cell.weightLabel.text = newRegistrArray[indexPath.row].weight
        cell.stretchCountLabel.text = newRegistrArray[indexPath.row].stretchCount
        
        return cell
    }
}

extension NewRegistrationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        
        nextVc.apparatusValue = newRegistrArray[indexPath.row].apparatus
        nextVc.partValue = newRegistrArray[indexPath.row].part
        nextVc.placeValue = newRegistrArray[indexPath.row].place
        nextVc.weightValue = newRegistrArray[indexPath.row].weight
        nextVc.stretchCountValue = newRegistrArray[indexPath.row].stretchCount
        
        nextVc.rootCheckFlag = 2
        
        // 何番目のindexか指定
        self.delegate.NewRegistrationIndexCount = indexPath.row
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { action, _ ,completionHandler in
            
            let alert = UIAlertController(title: "選択したデータを削除しますか?", message: "削除したデータは復元できません。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                
                // removeで該当の要素を削除しないと落ちる
                self.newRegistrArray.remove(at: indexPath.row)
                self.registrTableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in
                
                // セルの「削除」の表示を閉じる
                completionHandler(true)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
