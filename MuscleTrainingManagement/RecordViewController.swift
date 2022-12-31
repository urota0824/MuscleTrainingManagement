//
//  RecordViewController.swift
//  MuscleTrainingManagement
//
//  Created by yutaro on 2022/11/29.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController {
    
    @IBOutlet weak var recordTableView: UITableView!
    
    var valueArray: [RecordModel] = []
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "トレーニング内容"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButton(_:)))
        navigationItem.leftBarButtonItem = backButton
        
        self.recordTableView.dataSource = self
        self.recordTableView.delegate = self
        
        recordTableView.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        recordTableView.reloadData()
    }
    
    @objc func backButton(_ sender: UIBarButtonItem){
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return valueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell") as! RecordTableViewCell
        
        cell.apparatusLabel.text = valueArray[indexPath.row].apparatus
        cell.partLabel.text = valueArray[indexPath.row].part
        cell.placeLabel.text = valueArray[indexPath.row].place
        cell.weightLabel.text = valueArray[indexPath.row].weight
        cell.stretchCountLabel.text = valueArray[indexPath.row].stretchCount
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 180
    }
}

extension RecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        
        nextVc.rootCheckFlag = 3
        
        nextVc.apparatusValue = valueArray[indexPath.row].apparatus
        nextVc.partValue = valueArray[indexPath.row].part
        nextVc.placeValue = valueArray[indexPath.row].place
        nextVc.weightValue = valueArray[indexPath.row].weight
        nextVc.stretchCountValue = valueArray[indexPath.row].stretchCount
        
        // EditViewControllerで保存済みの項目を更新する際に、allRecordListの何番目のindexか指定
        self.delegate.recordIndexCount = indexPath.row
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 編集処理
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { action, _ ,completionHandler in
            
            let alert = UIAlertController(title: "選択したデータを削除しますか?", message: "削除したデータは復元できません。", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                
                // removeで該当の要素を削除しないと落ちる
                self.valueArray.remove(at: indexPath.row)
                self.recordTableView.deleteRows(at: [indexPath], with: .automatic)
                
                // Realmから削除する
                do {
                    let realm = try Realm()
                    try! realm.write {
                        
                        let result = realm.objects(AllRecordModel.self)
                        let delresult = result[self.delegate.allRecordIndexCount].allRecordList[self.delegate.recordIndexCount]
                        
                        if self.valueArray.count != 0 {
                            
                            realm.delete(delresult)
                            print("Save 成功")
                            
                        } else {
                            
                            let allDelresult = result[self.delegate.allRecordIndexCount]
                            realm.delete(allDelresult)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } catch {
                    
                    print("Save is Faild")
                }
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

