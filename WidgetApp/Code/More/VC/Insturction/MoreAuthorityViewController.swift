//
//  MoreAuthorityViewController.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/10.
//

import UIKit

class MoreAuthorityViewController: BaseViewController {
      
    var items: [PermissionItem] = []
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        tableView.backgroundColor = UIColor(hexString: "#F5F5F5")
        tableView.register(UINib(nibName: "MoreAuthorityManagementTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreAuthorityManagementTableViewCell")

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = PermissionManager.getPermissionData()
        self.tableView.reloadData()
    }
    
    override func setupView() {
        super.setupView()
        
        self.addBackButton()
        self.title = NSLocalizedString("权限管理", comment: "")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
    }

}


extension MoreAuthorityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreAuthorityManagementTableViewCell") as!  MoreAuthorityManagementTableViewCell
        
        cell.item = items[indexPath.row]
        return cell
    }
}
