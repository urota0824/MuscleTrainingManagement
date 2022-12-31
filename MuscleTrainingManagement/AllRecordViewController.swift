//
//  AllRecordViewController.swift
//  MuscleTrainingManagement
//
//  Created by yutaro on 2022/11/29.
//

import UIKit
import RealmSwift

class AllRecordViewController: UIViewController {
    
    @IBOutlet weak var allRecordTableView: UITableView!
    
    var addBarButtonItem = UIBarButtonItem()
    var allValueList = [AllRecordModel]()
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "実施日一覧"

        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButton(_:)))
        navigationItem.leftBarButtonItem = backButton

        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = addBarButtonItem
        
        allRecordTableView.dataSource = self
        allRecordTableView.delegate = self
        
        allRecordTableView.register(UINib(nibName: "AllRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "AllRecordTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let realm = try! Realm()
        let result = realm.objects(AllRecordModel.self)
        allValueList = Array(result)
        
        allRecordTableView.reloadData()
    }
    
    @objc func backButton(_ sender: UIBarButtonItem){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "NewRegistrationViewController") as! NewRegistrationViewController
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
}

extension AllRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allValueList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllRecordTableViewCell") as! AllRecordTableViewCell
        
        cell.effectiveDateLabel.text = allValueList[indexPath.row].effectiveDate
        
        return cell
    }
}

extension AllRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "RecordViewController") as! RecordViewController
        
        nextVc.valueArray.append(contentsOf: allValueList[indexPath.row].allRecordList)
        
        // EditViewControllerで保存済みの項目を更新する際に、AllRecordModelの何番目のindexか指定
        self.delegate.allRecordIndexCount = indexPath.row
        
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 編集処理
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
            
            let alert = UIAlertController(title: "選択したデータを削除しますか?", message: "削除したデータは復元できません。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                
            
            let deleteTarget = self.allValueList[indexPath.row]
            let realm = try! Realm()
            try! realm.write {
                
                realm.delete(deleteTarget)
            }
            
            // removeで該当の要素を削除しないと落ちる
            self.allValueList.remove(at: indexPath.row)
            self.allRecordTableView.deleteRows(at: [indexPath], with: .automatic)
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
