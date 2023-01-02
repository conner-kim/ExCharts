//
//  CustomMarkerView.swift
//  ChartsApp
//
//  Created by Conner on 2023/01/02.
//

import UIKit
import Charts

class CustomMarkerView: MarkerView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    
    private func initUI() {
        
        Bundle.main.loadNibNamed("CustomMarkerView", owner: self,options: nil)
        
        self.addSubview(self.contentView)
        
        self.boxView.backgroundColor = .orange
        self.boxView.layer.cornerRadius = 8
        
        self.contentView.backgroundColor = .clear
        self.frame = CGRect(x: 0, y: 0, width: 79, height: 63)
        self.offset = CGPoint(x: -(self.frame.width / 2), y: -(self.frame.height))
    }
    
    public func setMarkerValue(title: String?, value: String?) {
        self.titleLabel.text = title
        self.valueLabel.text = value
    }
}
