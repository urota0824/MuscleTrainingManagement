//
//  EditViewController.swift
//  MuscleTrainingManagement
//
//  Created by yutaro on 2022/11/30.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    @IBOutlet weak var apparatusTextField: UITextField!
    @IBOutlet weak var partTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var stretchCountTextField: UITextField!
    
    @IBOutlet weak var addSaveButton: UIButton!
    
//    let apparatusArray: [String] = ["アームカールエクステンション", "フライ", "クランチ", "シー・テッドロー", "ロータリー&ツイストロー", "ランニングマシン"]
//    let partArray: [String] = ["腕", "胸", "腹", "背中", "太もも", "ふくらはぎ"]
//    let placeArray: [String] = ["表", "裏", "右", "左"]
    
    var apparatusArray: [String] = []
    var partArray: [String] = []
    var placeArray: [String] = []
    
    var weightIntArray = [Int](1...100)
    var stretchCountIntArray = [Int](1...100)
    var weightArray: [String] = []
    var stretchCountArray: [String] = []
    
    var  apparatusValue = ""
    var  partValue = ""
    var  placeValue = ""
    var  weightValue = ""
    var  stretchCountValue = ""
    
    var pickersw = 0
    var selectValue: String = ""
    
    // 1:新規登録画面からの遷移　2:新規画面で追加したセルタップ時の遷移　3:トレーニング内容画面からの遷移
    var rootCheckFlag: Int = 0
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 「重さ」「回数/分」初期値を「(1...100)」でベタ書きしているためキャストをループで実行
        for weight in weightIntArray {
            weightArray.append(String(weight))
        }
        for stretchCount in stretchCountIntArray {
            stretchCountArray.append(String(stretchCount))
        }
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButton(_:)))
        navigationItem.leftBarButtonItem = backButton
        
        if rootCheckFlag == 1 {
            navigationItem.title = "トレーニング内容登録"
            addSaveButton.titleLabel?.text = "追加"
            
        } else if rootCheckFlag == 2 {
            navigationItem.title = "トレーニング内容修正"
            addSaveButton.titleLabel?.text = "修正を反映"
            
        } else if rootCheckFlag == 3 {
            navigationItem.title = "トレーニング内容編集"
        }
        
        apparatusTextField.text = apparatusValue
        partTextField.text = partValue
        placeTextField.text = placeValue
        weightTextField.text = weightValue
        stretchCountTextField.text = stretchCountValue
        
        callUserDefaults()
        picker()
    }
    
    @objc func backButton(_ sender: UIBarButtonItem){
        
        self.navigationController?.popViewController(animated: true)
    }
        
    func callUserDefaults() {
        
        let userDefaults = UserDefaults()
        
        guard let callApparatusArray:[String] = userDefaults.array(forKey: "apparatus") as? [String] else {return}
        apparatusArray.append(contentsOf: callApparatusArray)
        
        guard let callPartArray: [String] = userDefaults.array(forKey: "part") as? [String] else {return}
        partArray.append(contentsOf: callPartArray)
        
        guard let callPlaceArray: [String] = userDefaults.array(forKey: "place") as? [String] else {return}
        placeArray.append(contentsOf: callPlaceArray)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let recordModel = RecordModel()
        
        if (apparatusTextField.text != "" &&
            partTextField.text != "" &&
            placeTextField.text != "" &&
            weightTextField.text != "" &&
            stretchCountTextField.text != ""
        ) {
            
            // 1:新規登録画面からの遷移
            if rootCheckFlag == 1 {
                
                recordModel.apparatus = apparatusTextField.text!
                recordModel.part = partTextField.text!
                recordModel.place = placeTextField.text!
                recordModel.weight = weightTextField.text!
                recordModel.stretchCount = stretchCountTextField.text!
                
                // 画面を閉じて遷移前の画面に戻り、かつ、入力した値を渡す
                if let index = navigationController?.viewControllers.count {
                    let vc = navigationController?.viewControllers[index - 2] as? NewRegistrationViewController
                    vc?.newRegistrArray.append(recordModel)
                }
                    self.navigationController?.popViewController(animated: true)
                
                // 2:新規画面で追加したセルタップ時の遷移
            } else if rootCheckFlag == 2 {
                
                recordModel.apparatus = apparatusTextField.text!
                recordModel.part = partTextField.text!
                recordModel.place = placeTextField.text!
                recordModel.weight = weightTextField.text!
                recordModel.stretchCount = stretchCountTextField.text!
                
                // 画面を閉じて遷移前の画面に戻り、かつ、遷移前画面で選択されたセルの内容を更新
                if let index = navigationController?.viewControllers.count {
                    let vc = navigationController?.viewControllers[index - 2] as? NewRegistrationViewController
                    vc?.newRegistrArray[self.delegate.NewRegistrationIndexCount] = recordModel
                }
                
                let myDaialog = UIAlertController(title: "修正を反映しました。", message: nil, preferredStyle: .alert)
                myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  {_ in
                    // クロージャで前の画面への遷移処理を入れることで、ダイアログのOKをタップした後に前の画面へ遷移することができる
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(myDaialog, animated: true, completion: nil)
                
                // 3:トレーニング内容画面からの遷移
            } else if rootCheckFlag == 3 {
                
                do {
                    let upRlealm = try Realm()
                    try! upRlealm.write {
                        
                        let result = upRlealm.objects(AllRecordModel.self)
                        let newValueModel =  result[self.delegate.allRecordIndexCount].allRecordList[self.delegate.recordIndexCount]
                        
                        newValueModel.apparatus = apparatusTextField.text!
                        newValueModel.part = partTextField.text!
                        newValueModel.place = placeTextField.text!
                        newValueModel.weight = weightTextField.text!
                        newValueModel.stretchCount = stretchCountTextField.text!
                    }
                } catch {
                    
                    print(error)
                }
                
                let myDaialog = UIAlertController(title: "保存が完了しました。", message: nil, preferredStyle: .alert)
                myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  {_ in
                    // クロージャで前の画面への遷移処理を入れることで、ダイアログのOKをタップした後に前の画面へ遷移することができる
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(myDaialog, animated: true, completion: nil)
            }
        } else {
            
            let myDaialog = UIAlertController(title: "未入力の欄があります", message: nil, preferredStyle: .alert)
            myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  nil))
            self.present(myDaialog, animated: true, completion: nil)
            return
        }
    }
    
    private func picker() {
        
        let apparatusPickerView = UIPickerView()
        let partPickerView = UIPickerView()
        let placePickerView = UIPickerView()
        let weightPickerView = UIPickerView()
        let stretchCountPickerView = UIPickerView()
        
        apparatusPickerView.delegate = self
        apparatusPickerView.dataSource = self
        partPickerView.delegate = self
        partPickerView.dataSource = self
        placePickerView.delegate = self
        placePickerView.dataSource = self
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        stretchCountPickerView.delegate = self
        stretchCountPickerView.dataSource = self
        
        apparatusPickerView.tag = 1
        partPickerView.tag = 2
        placePickerView.tag = 3
        weightPickerView.tag = 4
        stretchCountPickerView.tag = 5
        
        //inputView入力項目定義
        apparatusTextField.inputView = apparatusPickerView
        partTextField.inputView = partPickerView
        placeTextField.inputView = placePickerView
        weightTextField.inputView = weightPickerView
        stretchCountTextField.inputView = stretchCountPickerView
        
        // 決定・キャンセル用ツールバーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPicker))
        toolbar.setItems([cancelItem, spaceItem, doneItem], animated: true)
        
        //入力エリアアクセス宣言
        apparatusTextField.inputAccessoryView = toolbar
        partTextField.inputAccessoryView = toolbar
        placeTextField.inputAccessoryView = toolbar
        weightTextField.inputAccessoryView = toolbar
        stretchCountTextField.inputAccessoryView = toolbar
    }
}

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if picker.tag == 1 {
            return apparatusArray.count
            
        } else if picker.tag == 2 {
            return partArray.count
            
        } else if picker.tag == 3 {
            return placeArray.count
            
        } else if picker.tag == 4 {
            return weightArray.count
            
        } else {
            return stretchCountArray.count
        }
    }
    
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if picker.tag == 1 {
            pickersw = 1
            // ユーザーがピッカーを動かさずにdoneをした場合、didSelectRowが呼ばれずにselectValueが""になってしまうため、デフォルトのとして表示されたarrayの[0]をselectValueとして表示させる（）
            selectValue = apparatusArray[0]
            return apparatusArray[row] as String
            
        } else if picker.tag == 2 {
            pickersw = 2
            // ユーザーがピッカーを動かさずにdoneをした場合、didSelectRowが呼ばれずにselectValueが""になってしまうため、デフォルトのとして表示されたarrayの[0]をselectValueとして表示させる（）
            selectValue = partArray[0]
            return partArray[row] as String
            
        } else if picker.tag == 3 {
            pickersw = 3
            // ユーザーがピッカーを動かさずにdoneをした場合、didSelectRowが呼ばれずにselectValueが""になってしまうため、デフォルトのとして表示されたarrayの[0]をselectValueとして表示させる（）
            selectValue = placeArray[0]
            return placeArray[row] as String
            
        } else if picker.tag == 4 {
            pickersw = 4
            // ユーザーがピッカーを動かさずにdoneをした場合、didSelectRowが呼ばれずにselectValueが""になってしまうため、デフォルトのとして表示されたarrayの[0]をselectValueとして表示させる（）
            selectValue = weightArray[0]
            return weightArray[row] as String
            
        } else {
            pickersw = 5
            // ユーザーがピッカーを動かさずにdoneをした場合、didSelectRowが呼ばれずにselectValueが""になってしまうため、デフォルトのとして表示されたarrayの[0]をselectValueとして表示させる（）
            selectValue = stretchCountArray[0]
            return stretchCountArray[row] as String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            selectValue = apparatusArray[row]
            
        } else if pickerView.tag == 2 {
            selectValue = partArray[row]
            
        } else if pickerView.tag == 3 {
            selectValue = placeArray[row]
            
        } else if pickerView.tag == 4 {
            selectValue = weightArray[row]
            
        } else if pickerView.tag == 5 {
            selectValue = stretchCountArray[row]
        }
    }
    
    @objc func donePicker() {
        
        if pickersw == 1 {
            apparatusTextField.text = selectValue
            
        } else if pickersw == 2 {
            partTextField.text = selectValue
            
        } else if pickersw == 3 {
            placeTextField.text = selectValue
            
        } else if pickersw == 4 {
            weightTextField.text = selectValue
            
        } else {
            stretchCountTextField.text = selectValue
            
        }
        
        view.endEditing(true)
    }
    
    @objc func cancelPicker() {
        
        view.endEditing(true)
    }
}
