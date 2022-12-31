//
//  TopViewController.swift
//  MuscleTrainingManagement
//
//  Created by yutaro on 2022/11/29.
//

import UIKit
import RealmSwift

class TopViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground(name: "TopImage")
//        self.navigationController?.navigationBar.backgroundColor = UIColor.rgb(red: 121, green: 162, blue: 255)
//        self.navigationController?.navigationBar.tintColor = UIColor.white;

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
    }
    
    func checkUserDefaults() {
        // 初めての起動でUserDefaults（トレーニング選択項目が未設定の場合、強制的にSettingTopViewControllerへ遷移させる）
        let myDaialog = UIAlertController(title: "設定画面へ移動します。", message: "アプリを使い始める前にトレーニング選択項目の設定をお願いします。", preferredStyle: .alert)
        myDaialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SettingTopViewController") as! SettingTopViewController
            self.navigationController?.pushViewController(nextVc, animated: true)
        }))
        self.present(myDaialog, animated: true, completion: nil)
    }
}


extension UIView {
    func addBackground(name: String) {
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        // スクリーンサイズにあわせてimageViewの配置
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        //imageViewに背景画像を表示
        imageViewBackground.image = UIImage(named: name)
        
        // 画像の表示モードを変更。
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        // subviewをメインビューに追加
        self.addSubview(imageViewBackground)
        // 加えたsubviewを、最背面に設置する
        self.sendSubviewToBack(imageViewBackground)
    }
}

// NavigationControllerBarの色をRGBで設定するためのextension
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 0.5)
    }
}
