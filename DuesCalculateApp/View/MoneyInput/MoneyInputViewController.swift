//
//  MoneyInputViewController.swift
//  DuesCalculateApp
//
//  Copyright © 2017年 TechLab. All rights reserved.
//

import UIKit

/// 金額入力画面
class MoneyInputViewController: UIViewController {
    
    // MARK: - Properties

    // 前画面で選択されたユーザを収めるディクショナリ
    var selectMember  = [Int: String]()
    
    // 前画面で選択した人を表示するための変数
    var name: String = ""
    
    // 全画面で選択した人のメールアドレスを保持するための変数
    var memberMailAddress  = [Int: String]()
    
    // 飲み会ID
    var selectPartyId: Int?
    
    // 編集対象のシリアルNo
    private var memberSerialNo: Int?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var cheakMember: UILabel!

    @IBOutlet weak var inputAmount: UITextField!
    
    @IBOutlet weak var buttonRegister: UIButton!
    
    // MARK: - IBActions
    
    // 登録するボタン押下時の処理
    @IBAction func TapInsertButton(_ sender: Any) {
        
        let amount = Int(inputAmount.text!)
        
        if let no = memberSerialNo {
            // 更新するボタン押下時の挙動
            let _: Bool = DBManager.updateMember(serialNo: no, amount: amount!)
        } else {
            // 登録するボタン押下時の挙動
            for index in selectMember.keys {
                // 選択した人数分登録処理を実施
                if let partyId = selectPartyId,
                    let name = selectMember[index],
                    let amount = amount {
                    let _: Bool = DBManager.createPartyDetail(partyId: partyId, name: name, mailAddress: "test@test.co.jp", amount: amount)
                }
            }
        }
        // ボタンをタップしたら飲み会詳細画面に.遷移
        let vc = PartyDetailViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }

    // MARK: - Initializer
    
    
    /// 参加者選択画面から遷移した場合
    ///
    /// - Parameters:
    ///   - partyId: 飲み会ID
    ///   - selectedMember: 選択した参加者
    init(partyId: Int, selectedMember: [Int: String]) {
        selectPartyId = partyId
        selectMember = selectedMember
        
        super.init(nibName: nil, bundle: nil)
        
        cheakMember.numberOfLines = selectMember.count
        
        for index in selectMember.keys {
            name += selectMember[index]! + "\n"
        }
        
        cheakMember.text = name

    }
    
    /// 飲み会詳細画面から編集ボタン押下で遷移した場合
    ///
    /// - Parameter serialNo: 飲み会ID
    init(partyId: Int) {
        selectPartyId = partyId

        super.init(nibName: nil, bundle: nil)
        
        let member = DBManager.searchMember(serialNo: no)
        cheakMember.text = member.memberName
        inputAmount.text = String(member.paymentAmount)
        buttonRegister.setTitle("更新する", for: .normal)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarのタイトルを設定
        self.navigationItem.title = "金額入力"
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(doneBtn))
        toolBar.items = [toolBarBtn]
        inputAmount.inputAccessoryView = toolBar

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Functions
    
    //toolbarのdoneボタン
    @objc private func doneBtn() {
        inputAmount.resignFirstResponder()
    }

}
