//
//  OneTimeCodeTextField.swift
//  One Time Code
//
//  Created by Peter Bassem on 12/8/20.
//

import UIKit

@objc protocol OneTimeCodeTextFieldDelegate: AnyObject {
    @objc optional func didCompleteOTPText(otpText text: String)
    func isValidCode(isValid valid: Bool)
}

@IBDesignable
class OneTimeCodeTextField: UITextField {
    
    // MARK: - IBInspectable
    @IBInspectable var digitsCount: Int = 6 {
        didSet { configure(with: digitsCount) }
    }
    @IBInspectable var spacing: CGFloat = 8 {
        didSet { configure(with: digitsCount) }
    }
    @IBInspectable var textBackgroundColor: UIColor? {
        didSet { updateView() }
    }
    @IBInspectable var digitTextColor: UIColor? {
        didSet { updateView() }
    }
    @IBInspectable var defaultCharacter: String = "" {
        didSet { updateView() }
    }
    @IBInspectable var digitLabelCornerRadius: CGFloat = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var digitLabelBorderWidth: CGFloat = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var digitLabelBorderColor: UIColor = .clear {
        didSet { updateView() }
    }
    @IBInspectable internal var digitLabelShadowColor: UIColor = .clear {
        didSet { updateView() }
    }
    @IBInspectable var digitLabelShadowOpacity: Float = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var digitLabelShadowRadius: CGFloat = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var digitLabelShadowOffsetX: CGFloat = 0.0 {
        didSet { updateView() }
    }
    @IBInspectable var digitLabelShadowOffsetY: CGFloat = 0.0 {
        didSet { updateView() }
    }
    
    var digitFont: UIFont? {
        didSet { updateView() }
    }
    
    // MARK: - Closures (maybe change to delegates sooner..)
    var didEnterLastDigit: ((String) -> Void)?
    
    weak var otpDelegate: OneTimeCodeTextFieldDelegate?
    
    // MARK: - Private Variables
    private var isConfigured: Bool = false
    private lazy var stackView = UIStackView()
    private var digitLabels = [UILabel]()
    private var digitLabelViews = [UIView]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
       let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    private(set) var validCode = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure(with: digitsCount)
    }
    
    // MARK: - Helpers
    func configure(with slotCount: Int) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .asciiCapableNumberPad
        textContentType = .oneTimeCode
        borderStyle = .none
        becomeFirstResponder()
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
        
        semanticContentAttribute = .unspecified

    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1 ... count {
            let view = UIView()
            view.backgroundColor = .clear
            view.layer.masksToBounds = false
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            label.clipsToBounds = true
            label.layer.masksToBounds = false
            
            view.addSubview(label)
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            stackView.addArrangedSubview(view)
            
            digitLabels.append(label)
            digitLabelViews.append(view)
        }
        setNeedsDisplay()
        return stackView
    }
    
    // MARK: - Selectors
    @objc
    private func textDidChange() {
        
        guard let text = text, text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                if defaultCharacter != "" {
                    currentLabel.text = defaultCharacter
                } else {
                    currentLabel.text?.removeAll()
                }
            }
        }
        
        if text.count == digitLabels.count {
            otpDelegate?.didCompleteOTPText?(otpText: text)
            otpDelegate?.isValidCode(isValid: true)
        } else {
            otpDelegate?.isValidCode(isValid: false)
        }
        validCode = text.count == digitLabels.count
    }
    
    private func updateView() {
        guard digitLabels.count > 0 else { return }
        stackView.spacing = spacing
        if let textBackgroundColor = textBackgroundColor {
            digitLabelViews.forEach { $0.backgroundColor = textBackgroundColor }
            setNeedsDisplay()
        }
        if let digitTextColor = digitTextColor {
            digitLabels.forEach { $0.textColor = digitTextColor }
            setNeedsDisplay()
        }
        if let digitFont = digitFont {
            digitLabels.forEach { $0.font = digitFont }
        }
        if defaultCharacter != "" {
            digitLabels.forEach { $0.text = defaultCharacter }
        }
        
        digitLabelViews.forEach { $0.layer.cornerRadius = digitLabelCornerRadius }
        digitLabels.forEach { $0.layer.borderWidth = digitLabelBorderWidth }
        digitLabelViews.forEach { $0.layer.borderColor = digitLabelBorderColor.cgColor }
        digitLabelViews.forEach { $0.layer.shadowColor = digitLabelShadowColor.cgColor }
        digitLabelViews.forEach { $0.layer.shadowOpacity = digitLabelShadowOpacity }
        digitLabelViews.forEach { $0.layer.shadowRadius = digitLabelShadowRadius }
        digitLabelViews.forEach { $0.layer.shadowOffset = .init(width: digitLabelShadowOffsetX, height: digitLabelShadowOffsetY) }
    }
}

// MARK: - UITextFieldDelegate
extension OneTimeCodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}
