//
//  UserTableViewCell.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 13/12/2021.
//

import UIKit

protocol Configurable {
    
    associatedtype T
    var viewModel: T? { get set }
    func configureWithModel(_: T)
}

final class UserTableViewCell: UITableViewCell, Configurable {
    typealias T = UserCellViewModel
    var viewModel: UserCellViewModel?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var loginNamelbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    func configureWithModel(_ vm: UserCellViewModel) {
        self.viewModel = vm
        setData()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUI()
    }
    
    func setData() {
        loginNamelbl.text = viewModel?.userName
        typeLbl.text = viewModel?.userType
        avatarImgView.loadImage(withUrlStr: viewModel?.userImageUrlStr)
    }
    
    func setUI(){
        containerView.backgroundColor = .appColor(.cellBackgroundColor)
        containerView.layer.cornerRadius = 10.0
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 6.0
        containerView.layer.shadowOpacity = 0.6
    }
    
}
