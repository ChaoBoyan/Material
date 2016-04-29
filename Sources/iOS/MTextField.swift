/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit

public protocol MTextFieldDelegate : UITextFieldDelegate {}

@IBDesignable
public class MTextField : UITextField {
	public private(set) var animating: Bool = false
	
	/**
	This property is the same as clipsToBounds. It crops any of the view's
	contents from bleeding past the view's frame.
	*/
	@IBInspectable public var masksToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set(value) {
			layer.masksToBounds = value
		}
	}
	
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable public override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.CGColor
		}
	}
	
	/// A property that accesses the layer.frame.origin.x property.
	@IBInspectable public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	@IBInspectable public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/// A property that accesses the layer.frame.size.width property.
	@IBInspectable public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
		}
	}
	
	/// A property that accesses the layer.frame.size.height property.
	@IBInspectable public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/// A property that accesses the layer.position property.
	@IBInspectable public var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/// A property that accesses the layer.zPosition property.
	@IBInspectable public var zPosition: CGFloat {
		get {
			return layer.zPosition
		}
		set(value) {
			layer.zPosition = value
		}
	}
	
	/// Reference to the divider.
	public private(set) lazy var divider: CAShapeLayer = CAShapeLayer()
	
	/// Divider height.
	@IBInspectable public var dividerHeight: CGFloat = 1
	
	/// Divider active state height.
	@IBInspectable public var dividerActiveHeight: CGFloat = 2
	
	/// Sets the divider and tintColor.
	@IBInspectable public var dividerColor: UIColor = MaterialColor.darkText.dividers
	
	/// The placeholderLabel font value.
	@IBInspectable public override var font: UIFont? {
		get {
			return placeholderLabel.font
		}
		set(value) {
			placeholderLabel.font = value
		}
	}
	
	/// The placeholderLabel text value.
	@IBInspectable public override var placeholder: String? {
		get {
			return placeholderLabel.text
		}
		set(value) {
			placeholderLabel.text = value
			if let v: String = value {
				placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderColor])
			}
		}
	}
	
	/**
	The placeholderLabel UILabel that is displayed when there is text. The
	placeholderLabel text value is updated with the placeholder text
	value before being displayed.
	*/
	@IBInspectable public private(set) lazy var placeholderLabel: UILabel = UILabel(frame: CGRectZero)
	
	/// Placeholder textColor.
	@IBInspectable public var placeholderColor: UIColor = MaterialColor.darkText.others
	
	/// Placeholder active textColor.
	@IBInspectable public var placeholderActiveColor: UIColor = MaterialColor.blue.base
	
	/// The detailLabel UILabel that is displayed.
	@IBInspectable public private(set) lazy var detailLabel: UILabel = UILabel(frame: CGRectZero)
	
	
	/// The detailLabel text value.
	@IBInspectable public var detail: String? {
		get {
			return detailLabel.text
		}
		set(value) {
			detailLabel.text = value
			if let v: String = value {
				detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
			}
		}
	}
	
	/// Detail textColor.
	@IBInspectable public var detailColor: UIColor = MaterialColor.darkText.others
	
	/// Handles the textAlignment of the placeholderLabel.
	public override var textAlignment: NSTextAlignment {
		get {
			return placeholderLabel.textAlignment
		}
		set(value) {
			super.textAlignment = value
			placeholderLabel.textAlignment = value
		}
	}
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
	An initializer that initializes the object with a CGRect object.
	If AutoLayout is used, it is better to initilize the instance
	using the init() initializer.
	- Parameter frame: A CGRect instance.
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRectZero)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		if !editing && !animating {
			layoutPlaceholderLabel()
			layoutDetailLabel()
		}
	}
	
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			if !editing {
				layoutDivider()
			}
		}
	}
	
	/// Default size when using AutoLayout.
	public override func intrinsicContentSize() -> CGSize {
		return CGSizeMake(width, 32)
	}
	
	/**
	A method that accepts CAAnimation objects and executes them on the
	view's backing layer.
	- Parameter animation: A CAAnimation instance.
	*/
	public func animate(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			layer.addAnimation(a, forKey: a.keyPath!)
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			layer.addAnimation(a, forKey: nil)
		} else if let a: CATransition = animation as? CATransition {
			layer.addAnimation(a, forKey: kCATransition)
		}
	}
	
	/**
	A delegation method that is executed when the backing layer starts
	running an animation.
	- Parameter anim: The currently running CAAnimation instance.
	*/
	public override func animationDidStart(anim: CAAnimation) {
		(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStart?(anim)
	}
	
	/**
	A delegation method that is executed when the backing layer stops
	running an animation.
	- Parameter anim: The CAAnimation instance that stopped running.
	- Parameter flag: A boolean that indicates if the animation stopped
	because it was completed or interrupted. True if completed, false
	if interrupted.
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				if let v: AnyObject = b.toValue {
					if let k: String = b.keyPath {
						layer.setValue(v, forKeyPath: k)
						layer.removeAnimationForKey(k)
					}
				}
			}
			(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStop?(anim, finished: flag)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
	
	/// Handles the text editing did begin state.
	public func handleEditingDidBegin() {
		dividerEditingDidBeginAnimation()
		placeholderEditingDidBeginAnimation()
	}
	
	/// Handles the text editing did end state.
	public func handleEditingDidEnd() {
		dividerEditingDidEndAnimation()
		placeholderEditingDidEndAnimation()
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		masksToBounds = false
		borderStyle = .None
		backgroundColor = nil
		textColor = MaterialColor.darkText.primary
		font = RobotoFont.regularWithSize(16)
		prepareDivider()
		preparePlaceholderLabel()
		prepareDetailLabel()
		prepareTargetHandlers()
	}
	
	/// Layout the divider.
	public func layoutDivider() {
		divider.frame = CGRectMake(0, height, width, dividerHeight)
	}
	
	/// Layout the placeholderLabel.
	public func layoutPlaceholderLabel() {
		if true == text?.isEmpty {
			placeholderLabel.frame = bounds
		} else if CGAffineTransformIsIdentity(placeholderLabel.transform) {
			placeholderLabel.frame = bounds
			placeholderLabel.transform = CGAffineTransformMakeScale(0.75, 0.75)
			placeholderLabel.frame.origin.x = 0
			placeholderLabel.frame.origin.y = -placeholderLabel.frame.size.height
			placeholderLabel.textColor = placeholderColor
		}
	}
	
	/// Layout the detailLabel.
	public func layoutDetailLabel() {
		detailLabel.frame = CGRectMake(0, height + 8, width, 12)
		detailLabel.sizeToFit()
	}
	
	/// The animation for the divider when editing begins.
	public func dividerEditingDidBeginAnimation() {
		divider.frame.size.height = dividerActiveHeight
		divider.backgroundColor = placeholderActiveColor.CGColor
	}
	
	/// The animation for the divider when editing ends.
	public func dividerEditingDidEndAnimation() {
		divider.frame.size.height = dividerHeight
		divider.backgroundColor = dividerColor.CGColor
	}
	
	/// The animation for the placeholder when editing begins.
	public func placeholderEditingDidBeginAnimation() {
		if CGAffineTransformIsIdentity(placeholderLabel.transform) {
			animating = true
			UIView.animateWithDuration(0.15, animations: { [weak self] in
				if let v: MTextField = self {
					v.placeholderLabel.transform = CGAffineTransformMakeScale(0.75, 0.75)
					v.placeholderLabel.frame.origin.x = 0
					v.placeholderLabel.frame.origin.y = -v.placeholderLabel.frame.size.height
					v.placeholderLabel.textColor = v.placeholderActiveColor
				}
			}) { [weak self] _ in
				self?.animating = false
			}
		} else if editing {
			placeholderLabel.textColor = placeholderActiveColor
		}
	}
	
	/// The animation for the placeholder when editing ends.
	public func placeholderEditingDidEndAnimation() {
		if !CGAffineTransformIsIdentity(placeholderLabel.transform) && true == text?.isEmpty {
			animating = true
			UIView.animateWithDuration(0.15, animations: { [weak self] in
				if let v: MTextField = self {
					v.placeholderLabel.transform = CGAffineTransformIdentity
					v.placeholderLabel.frame.origin.x = 0
					v.placeholderLabel.frame.origin.y = 0
					v.placeholderLabel.textColor = v.placeholderColor
				}
			}) { [weak self] _ in
				self?.animating = false
			}
		} else if !editing {
			placeholderLabel.textColor = placeholderColor
		}
	}
	
	/// Prepares the divider.
	private func prepareDivider() {
		divider.backgroundColor = MaterialColor.darkText.dividers.CGColor
		layer.addSublayer(divider)
	}
	
	/// Prepares the placeholderLabel.
	private func preparePlaceholderLabel() {
		placeholderColor = MaterialColor.darkText.others
		addSubview(placeholderLabel)
	}
	
	/// Prepares the detailLabel.
	private func prepareDetailLabel() {
		detailLabel.font = RobotoFont.regularWithSize(12)
		detailColor = MaterialColor.darkText.others
		addSubview(detailLabel)
	}
	
	/// Prepares the target handlers.
	private func prepareTargetHandlers() {
		addTarget(self, action: #selector(handleEditingDidBegin), forControlEvents: .EditingDidBegin)
		addTarget(self, action: #selector(handleEditingDidEnd), forControlEvents: .EditingDidEnd)
	}
}