//
//  AllTest3ViewController.swift
//  TangramKit
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 youngsoft. All rights reserved.
//

import UIKit

class AllTest3ViewController: UIViewController {
    
    
    var frameLayout:TGFrameLayout!
    
    var  popmenuLayout:TGLinearLayout!
    var  popmenuContainerLayout:TGLinearLayout!
    var popmenuScrollView:UIScrollView!
    var popmenuItemLayout:TGFlowLayout!
    
    
    //用来测试隐藏子视图时重新布局一些视图
    var hideSubviewRelayoutLayout:TGBaseLayout!
    var hiddenTestButton:UIButton!
    
    //浮动文本的布局
    var flexedLayout:TGBaseLayout!
    var leftFlexedLabel:UILabel!
    var rightFlexedLabel:UILabel!
    
    //伸缩布局
    var shrinkLayout:TGBaseLayout!
    
    
    override func loadView() {
        
        let frameLayout = TGFrameLayout()
        frameLayout.backgroundColor = UIColor.gray
        self.view = frameLayout
        self.frameLayout = frameLayout
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.tg_width.equal(.fill)
        scrollView.tg_height.equal(.fill) //scrollView的尺寸和frameLayout的尺寸一致，因为这里用了填充属性。
        frameLayout.addSubview(scrollView)
        
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle(NSLocalizedString("Logout", comment:""), for: .normal)
        button.tg_height.equal(50);
        button.tg_width.equal(.fill)
        button.tg_bottom.equal(0) //按钮定位在框架布局的底部并且宽度填充。
        frameLayout.addSubview(button)
        
        //整体一个线性布局，实现各种片段。
        let  contentLayout = TGLinearLayout(.vert)
        contentLayout.tg_width.equal(.fill)
        contentLayout.tg_height.equal(.wrap)
        contentLayout.tg_gravity = TGGravity.horz.fill; //子视图里面的内容的宽度跟布局视图相等，这样子视图就不需要设置宽度了。
        contentLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10)
        scrollView.addSubview(contentLayout)
        
        //头部布局。
        self.addHeaderLayout(contentLayout)
        //添加，弹出菜单的布局
        self.addPopmenuLayout(contentLayout)
        //添加事件处理，以及高亮背景，边界线的布局
        self.addHighlightedBackgroundAndBorderLineLayout(contentLayout)
        //添加，左右浮动间距，以及宽度最大限制的布局
        self.addFlexedWidthLayout(contentLayout)
        //添加，隐藏重新布局的布局。
        self.addHideSubviewReLayoutLayout(contentLayout)
        //添加，自动伸缩布局
        self.addShrinkLayout(contentLayout)

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AllTest3ViewController
{
    
    //添加头部布局。里面用的相对布局实现。
    
    func addHeaderLayout(_ contentLayout: TGLinearLayout) {
        
        let headerLayout = TGRelativeLayout()
        headerLayout.tg_backgroundImage = UIImage(named: "bk1")  //可以为布局直接设备背景图片。
        headerLayout.tg_height.equal(.wrap)
        contentLayout.addSubview(headerLayout)
        
        let headerImageView = UIImageView(image: UIImage(named: "head2"))
        headerImageView.backgroundColor = .white
        headerImageView.sizeToFit()
        headerImageView.tg_centerX.equal(0)
        headerImageView.tg_centerY.equal(0) //在父视图中居中。
        headerImageView.layer.cornerRadius = headerImageView.tg_estimatedFrame.height / 2
        headerLayout.addSubview(headerImageView)
        
        let headerNameLabel = UILabel()
        headerNameLabel.text = "欧阳大哥"
        headerNameLabel.sizeToFit()
        headerNameLabel.tg_centerX.equal(0)
        headerNameLabel.tg_top.equal(headerImageView.tg_bottom, offset:10)
        headerLayout.addSubview(headerNameLabel)
        
        //将tg_useFrame属性设置为true后。即使是布局里面的子视图也不会参与自动布局，而是可以通过最原始的设置frame的值来进行位置定位和尺寸的确定。
        let imageView2 = UIImageView(image: UIImage(named: "user"))
        imageView2.backgroundColor = UIColor.white
        imageView2.frame = CGRect(x:5, y:5, width:30, height:30)
        imageView2.tg_useFrame = true  //设置了这个属性后，这个子视图将不会被布局控制，而是直接用frame设置的为准。
        contentLayout.addSubview(imageView2)
    }
    
    //添加高亮，以及边界线效果的布局
    func addHighlightedBackgroundAndBorderLineLayout(_ contentLayout: TGLinearLayout)
    {
        //如果您只想要高亮效果而不想处理事件则方法：setTarget中的action为nil即可。
        //具有事件处理的layout,以及边界线效果的layout
        let layout1 = self.createActionLayout(title: NSLocalizedString("please touch here(no highlighted)", comment:""), action: #selector(handleTap))
        layout1.tg_top.equal(10)
        layout1.tg_topBorderline = TGLayoutBorderline(color: UIColor.yellow, headIndent:-10, tailIndent:-10) //底部边界线如果为负数则外部缩进
        layout1.tg_bottomBorderline = TGLayoutBorderline(color: UIColor.red) //设置底部和顶部都有红色的线
        contentLayout.addSubview(layout1)
        
        //具有事件处理的layout,高亮背景色的设置。
        let layout2 = self.createActionLayout(title:NSLocalizedString("please touch here(highlighted background)", comment:""), action: #selector(handleTap))
        layout2.tg_highlightedBackgroundColor = .lightGray //可以设置高亮的背景色用于单击事件
        layout2.tg_bottomBorderline = TGLayoutBorderline(color: UIColor.red, thick:4) //设置底部有红色的线，并且粗细为4
        //您还可以为布局视图设置按下、按下取消的事件处理逻辑。
        layout2.tg_setTarget(self, action: #selector(handleTouchDown), for:.touchDown)
        layout2.tg_setTarget(self, action: #selector(handleTouchCancel), for:.touchCancel)
        contentLayout.addSubview(layout2)
        
        
        //具有事件处理的layout, 可以设置触摸时的高亮背景图。虚线边界线。
        let layout3 = self.createActionLayout(title:NSLocalizedString("please touch here(highlighted background image)", comment:""), action: #selector(handleTap))
        layout3.tg_highlightedBackgroundImage = UIImage(named: "image2") //设置单击时的高亮背景图片。
        let dashLine = TGLayoutBorderline(color: UIColor.green, dash:3) //设置为非0表示虚线边界线。
        layout3.tg_leftBorderline = dashLine
        layout3.tg_rightBorderline = dashLine //设置左右边绿色的虚线
        contentLayout.addSubview(layout3)
    }
    
    func addPopmenuLayout(_ contentLayout: TGLinearLayout)
    {
        let layout = self.createActionLayout(title: NSLocalizedString("please touch here(will pop menu)", comment:""), action: #selector(handleShowPopMenu))
        layout.tg_highlightedOpacity = 0.2 //按下时的高亮透明度。为1全部透明。
        layout.tg_top.equal(10)
        contentLayout.addSubview(layout)
    }
    
    //添加隐藏重新布局的布局
    func addHideSubviewReLayoutLayout(_ contentLayout: TGLinearLayout)
    {
        //下面两个布局用来测试布局视图的hideSubviewReLayout属性。
        let switchLayout = self.createSwitchLayout(title: NSLocalizedString("relayout switch when subview hidden&show", comment:""), action: #selector(handleReLayoutSwitch))
        switchLayout.tg_bottomBorderline = TGLayoutBorderline(color: UIColor.red, headIndent:10, tailIndent:10) //底部边界线设置可以缩进
        switchLayout.tg_top.equal(10)
        contentLayout.addSubview(switchLayout)
        
        let testLayout = TGLinearLayout(.horz)
        testLayout.backgroundColor = UIColor.white
        testLayout.tg_leftPadding = 10
        testLayout.tg_rightPadding = 10
        testLayout.tg_height.equal(50)
        testLayout.tg_gravity = TGGravity.vert.fill
        testLayout.tg_hspace = 10
        contentLayout.addSubview(testLayout)
        self.hideSubviewRelayoutLayout = testLayout
        
        let leftButton = UIButton()
        leftButton.tg_width.equal(50)
        leftButton.backgroundColor = UIColor.green
        testLayout.addSubview(leftButton)
        
        let centerButton = UIButton()
        centerButton.setTitle(NSLocalizedString("touch hide me", comment:""), for: .normal)
        centerButton.addTarget(self, action: #selector(handleHideSelf), for: .touchUpInside)
        centerButton.backgroundColor = .red
        centerButton.sizeToFit()
        centerButton.tg_width.equal(.average)
        testLayout.addSubview(centerButton)
        self.hiddenTestButton = centerButton
        
        let rightButton = UIButton()
        rightButton.setTitle(NSLocalizedString("touch show me", comment:""), for: .normal)
        rightButton.addTarget(self, action: #selector(handleShowBrother), for: .touchUpInside)
        rightButton.backgroundColor = UIColor.blue
        rightButton.sizeToFit()
        rightButton.tg_width.equal(.average)
        testLayout.addSubview(rightButton)
    }
    
    //添加，一个浮动宽度的布局，里面的子视图的宽度是浮动的，会进行宽度的合适的分配。您可以尝试着点击加减按钮测试结果。
    func addFlexedWidthLayout(_ contentLayout: TGLinearLayout)
    {
        let flexedLayout = self.createSegmentedLayout(leftAction: #selector(self.handleLeftFlexed), rightAction: #selector(self.handleRightFlexed))
        flexedLayout.tg_bottomBorderline = TGLayoutBorderline(color: UIColor.red, headIndent:10, tailIndent:10)  //底部边界线设置可以缩进
        flexedLayout.tg_top.equal(10)
        contentLayout.addSubview(flexedLayout)
        
        let testLayout = TGLinearLayout(.horz)
        testLayout.backgroundColor = UIColor.white
        testLayout.tg_leftPadding = 10
        testLayout.tg_rightPadding = 10
        testLayout.tg_height.equal(50)
        testLayout.tg_gravity = TGGravity.vert.fill
        contentLayout.addSubview(testLayout)
        self.flexedLayout = testLayout
        
        let leftLabel = UILabel()
        leftLabel.text = "abc"
        leftLabel.textAlignment = .right
        leftLabel.lineBreakMode = .byTruncatingMiddle
        leftLabel.textColor = UIColor.white
        leftLabel.backgroundColor = UIColor.red
        leftLabel.sizeToFit()
        leftLabel.tg_right.equal(50%)
        leftLabel.tg_right.min(0) //右边浮动间距为0.5,最小为0
        leftLabel.tg_width.min(10)
        leftLabel.tg_width.max(testLayout.tg_width, increment:-10) //宽度最小为10，最大为布局视图的宽度减10
        testLayout.addSubview(leftLabel)
        self.leftFlexedLabel = leftLabel
        
        let rightLabel = UILabel()
        rightLabel.text = "123"
        rightLabel.textAlignment = .right
        rightLabel.lineBreakMode = .byTruncatingMiddle
        rightLabel.textColor = UIColor.white
        rightLabel.backgroundColor = UIColor.blue
        rightLabel.sizeToFit()
        rightLabel.tg_left.equal(50%)
        rightLabel.tg_left.min(0) //左边浮动间距为0.5，最小为0
        rightLabel.tg_width.min(10)
        rightLabel.tg_width.max(testLayout.tg_width, increment:-10) //宽度最小为10，最大为布局视图的宽度减10
        testLayout.addSubview(rightLabel)
        self.rightFlexedLabel = rightLabel
    }
    
    //添加一个能伸缩的布局
    func addShrinkLayout(_ contentLayout: TGLinearLayout)
    {
        //下面两个布局用来测试布局视图的hideSubviewReLayout属性。
        let switchLayout = self.createSwitchLayout(title: NSLocalizedString("show all switch", comment:""), action: #selector(self.handleShrinkSwitch))
        switchLayout.tg_bottomBorderline = TGLayoutBorderline(color: UIColor.red, headIndent:10, tailIndent:10)  //底部边界线设置可以缩进
        switchLayout.tg_top.equal(10)
        contentLayout.addSubview(switchLayout)
        
        let testLayout = TGFlowLayout(.vert, arrangedCount:3)
        testLayout.backgroundColor = UIColor.white
        testLayout.tg_averageArrange = true
        testLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10)
        testLayout.tg_space = 10
        testLayout.tg_bottom.equal(50) //这里设置底部间距的原因是登录按钮在最底部。为了使得滚动到底部时不被覆盖。
        testLayout.tg_height.equal(50)
        testLayout.clipsToBounds = true
        contentLayout.addSubview(testLayout)
        self.shrinkLayout = testLayout
        for i in 0..<10 {
            let label = UILabel()
            label.backgroundColor = UIColor.blue
            label.text = "\(i)"
            label.textAlignment = .center
            label.sizeToFit()
            testLayout.addSubview(label)
        }
    }
    
    //创建可执动作事件的布局
    func createActionLayout(title: String, action: Selector) -> TGLinearLayout {
        let actionLayout = TGLinearLayout(.horz)
        actionLayout.backgroundColor = UIColor.white
        actionLayout.tg_setTarget(self, action: action, for:.touchUpInside) //这里设置布局的触摸事件处理。
        actionLayout.tg_leftPadding = 10
        actionLayout.tg_rightPadding = 10
        actionLayout.tg_height.equal(50)
        actionLayout.tg_gravity = TGGravity.vert.center //左右内边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.tag = 1000
        label.tg_right.equal(50%) //水平线性布局通过相对间距来实现左右分开排列。
        actionLayout.addSubview(label)
        
        let imageView = UIImageView(image: UIImage(named: "next"))
        imageView.sizeToFit()
        imageView.tg_left.equal(50%)
        actionLayout.addSubview(imageView)
        return actionLayout
    }
    
    //创建具有开关的布局
    func createSwitchLayout(title: String, action: Selector) -> TGLinearLayout
    {
        let switchLayout = TGLinearLayout(.horz)
        switchLayout.backgroundColor = .white
        switchLayout.tg_leftPadding = 10
        switchLayout.tg_rightPadding = 10
        switchLayout.tg_height.equal(50)
        switchLayout.tg_gravity = TGGravity.vert.center //左右边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.tg_width.equal(.fill)
        switchLayout.addSubview(label)
        
        let switchCtrl = UISwitch()
        switchCtrl.addTarget(self, action: action, for: .valueChanged)
        switchCtrl.tg_right.min(5)
        switchLayout.addSubview(switchCtrl)
        return switchLayout
    }
    
    func createSegmentedLayout(leftAction: Selector, rightAction: Selector) -> TGFloatLayout
    {
        //建立一个左右浮动布局(注意左右浮动布局的orientation是.vert)
        let segmentedLayout = TGFloatLayout(.vert)
        segmentedLayout.backgroundColor = UIColor.white
        segmentedLayout.tg_leftPadding = 10
        segmentedLayout.tg_rightPadding = 10
        segmentedLayout.tg_height.equal(50)
        segmentedLayout.tg_gravity = TGGravity.vert.center //左右边距都是10，不包裹子视图，整体高度为50，里面的子布局垂直居中对齐。
        //向左浮动
        let leftSegmented = UISegmentedControl(items: ["  -  ", "  +  "])
        leftSegmented.isMomentary = true
        leftSegmented.addTarget(self, action: leftAction, for: .valueChanged)
        segmentedLayout.addSubview(leftSegmented)
        
        let rightSegmented = UISegmentedControl(items: ["  +  ", "  -  "])
        rightSegmented.isMomentary = true
        rightSegmented.addTarget(self, action: rightAction, for: .valueChanged)
        segmentedLayout.addSubview(rightSegmented)
        rightSegmented.tg_reverseFloat = true  //反向浮动也就是向右浮动。
        return segmentedLayout
    }
}

extension AllTest3ViewController
{
    
    func handleTap(sender:TGBaseLayout)
    {
        UIAlertView(title:"test", message:"you touched this section", delegate:nil, cancelButtonTitle:"OK").show()
    }
    
    func handleTouchDown(sender:TGBaseLayout)
    {
        let label = sender.viewWithTag(1000) as! UILabel
        label.textColor = UIColor.blue
         print("按下动作")
    }
    
    func handleTouchCancel(sender:TGBaseLayout)
    {
        let label = sender.viewWithTag(1000) as! UILabel
        label.textColor = UIColor.black
        print("按下取消")
    }
    
    func handleReLayoutSwitch(sender:TGBaseLayout)
    {
        self.hideSubviewRelayoutLayout.tg_layoutHiddenSubviews = !self.hideSubviewRelayoutLayout.tg_layoutHiddenSubviews
    }
    
    func handleHideSelf(sender:UIButton)
    {
        self.hiddenTestButton.isHidden = true
    }
    
    func handleShowBrother(sender:UIButton)
    {
        self.hiddenTestButton.isHidden = false
    }
    
    func handleLeftFlexed(segmented: UISegmentedControl)
    {
    
    if (segmented.selectedSegmentIndex == 0)
    {
    if (self.leftFlexedLabel.text!.characters.count > 1)
    {
        let text = self.leftFlexedLabel.text!
        self.leftFlexedLabel.text =  text.substring(to: text.index(text.endIndex, offsetBy: -1))
    }
    }
    else
    {
        let strs = "abcdefghijklmnopqrstuvwxyz";
        //真他妈的扯，取一个子字符串还这么麻烦。swift也有够垃圾的。
        let rand = arc4random_uniform(UInt32(strs.characters.count))
        let start = strs.index(strs.startIndex, offsetBy: String.IndexDistance(rand))
        let end = strs.index(strs.startIndex, offsetBy: String.IndexDistance(rand) + 1)
        let rg = Range(uncheckedBounds: (lower: start, upper: end))
        let str = strs.substring(with: rg)
        self.leftFlexedLabel.text = self.leftFlexedLabel.text!.appending(str)
    }
    
    self.leftFlexedLabel.sizeToFit()
    
    
    //我们可以在布局视图布局结束后，计算如果包裹文字的真实宽度都超过布局视图的一半时，我们将二者的宽度都设置为布局视图的宽度一半。
    //而一旦不满足条件时我们将宽度的设置清除，而保持子视图的真实尺寸。
    //如果我们想要获得某个布局视图下所有子视图在布局完成后的真实frame，则可以为布局的tg_endLayoutDo进行设置。
        weak var weakSelf = self
        self.flexedLayout.tg_endLayoutDo({
            //算出左右的实际宽度。如果二者的宽度都超过一半，则将二者的宽度都设置为一半。
            let leftRealSize = weakSelf!.leftFlexedLabel.sizeThatFits(.zero)
            let rightRealSize = weakSelf!.rightFlexedLabel.sizeThatFits(.zero)
            let halfWidth: CGFloat = (weakSelf!.flexedLayout.frame.width - 20) / 2
            if leftRealSize.width > halfWidth && rightRealSize.width > halfWidth {
                weakSelf!.leftFlexedLabel.tg_width.equal(halfWidth)
                weakSelf!.rightFlexedLabel.tg_width.equal(halfWidth)
            }
            else {
                weakSelf!.leftFlexedLabel.tg_width.equal(nil)
                weakSelf!.rightFlexedLabel.tg_width.equal(nil)
                weakSelf!.rightFlexedLabel.sizeToFit()
            }
        })
    }

    
    func handleRightFlexed(segmented: UISegmentedControl) {
        if segmented.selectedSegmentIndex == 0 {
            let strs = "01234567890"
    
            //真他妈的扯，取一个子字符串还这么麻烦。swift也有够垃圾的。
            let rand = arc4random_uniform(UInt32(strs.characters.count))
            let start = strs.index(strs.startIndex, offsetBy: String.IndexDistance(rand))
            let end = strs.index(strs.startIndex, offsetBy: String.IndexDistance(rand) + 1)
            let rg = Range(uncheckedBounds: (lower: start, upper: end))
            let str = strs.substring(with: rg)
            self.rightFlexedLabel.text = self.rightFlexedLabel.text!.appending(str)
        }
        else {
            if self.rightFlexedLabel.text!.characters.count > 1 {
                
                let text = self.rightFlexedLabel.text!
                self.rightFlexedLabel.text =  text.substring(to: text.index(text.endIndex, offsetBy: -1))
            }
        }
        self.rightFlexedLabel.sizeToFit()
        weak var weakSelf = self
        self.flexedLayout.tg_endLayoutDo({
            //算出左右的实际宽度。如果二者的宽度都超过一半，则将二者的宽度都设置为一半。
            let leftRealSize = weakSelf!.leftFlexedLabel.sizeThatFits(.zero)
            let rightRealSize = weakSelf!.rightFlexedLabel.sizeThatFits(.zero)
            let halfWidth: CGFloat = (weakSelf!.flexedLayout.frame.width - 20) / 2
            if leftRealSize.width > halfWidth && rightRealSize.width > halfWidth {
                weakSelf!.leftFlexedLabel.tg_width.equal(halfWidth)
                weakSelf!.rightFlexedLabel.tg_width.equal(halfWidth)
            }
            else {
                weakSelf!.leftFlexedLabel.tg_width.equal(nil)
                weakSelf!.rightFlexedLabel.tg_width.equal(nil)
                weakSelf!.leftFlexedLabel.sizeToFit()
            }
        })
    }
    
    func handleShrinkSwitch(sender: UISwitch) {
        if sender.isOn {
            self.shrinkLayout.tg_height.equal(.wrap)
        }
        else {
            self.shrinkLayout.tg_height.equal(50)
        }
        
        self.shrinkLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    func handleShowPopMenu(sender: TGBaseLayout) {
        let rc = sender.convert(sender.bounds, to: self.frameLayout)
        // 计算应该弹出的位置。要转化为框架布局的rect
        let menuLayout = TGLinearLayout(.vert)
        menuLayout.tg_width.equal(rc.width - 20) //宽度是sender的宽度减20
        menuLayout.tg_height.equal(.wrap);
        menuLayout.tg_centerX.equal(0) //因为我们是把弹出菜单展示在self.view下，这时候self.view是一个框架布局。所以这里这是水平居中。
        menuLayout.tg_top.equal(rc.maxY + 5)//弹出菜单的顶部位置。
       
        let arrowImageView = UIImageView(image: UIImage(named: "uptip"))
        arrowImageView.tg_centerX.equal(0)
        menuLayout.addSubview(arrowImageView)
        
        let containerLayout = TGLinearLayout(.vert)
        containerLayout.backgroundColor = UIColor(red: 0xBF / 255.0, green: 0xBD / 255.0, blue: 0xBF / 255.0, alpha: 1)
        containerLayout.layer.cornerRadius = 4
        containerLayout.tg_width.equal(.fill)
        containerLayout.tg_height.equal(.wrap);
        containerLayout.tg_padding = UIEdgeInsetsMake(10, 10, 10, 10)
        containerLayout.tg_gravity = TGGravity.horz.fill
        menuLayout.addSubview(containerLayout)
        self.popmenuContainerLayout = containerLayout
        
        let scrollView = UIScrollView()
        containerLayout.addSubview(scrollView)
        self.popmenuScrollView = scrollView
        
        let itemLayout = TGFlowLayout(.vert, arrangedCount:3)
        itemLayout.tg_width.equal(.fill)
        itemLayout.tg_height.equal(.wrap)
        itemLayout.tg_averageArrange = true
        itemLayout.tg_space = 10
        scrollView.addSubview(itemLayout)
        self.popmenuItemLayout = itemLayout
        
        for i in 0..<6
        {
            let button = UIButton()
            if i == 5 {
                button.setTitle(NSLocalizedString("add item", comment:""), for: .normal)
                button.addTarget(self, action: #selector(self.handleAddMe), for: .touchUpInside)
                button.backgroundColor = UIColor.red
            }
            else {
                button.setTitle(NSLocalizedString("double tap remove:\(i)", comment:""), for: .normal)
                button.titleLabel!.adjustsFontSizeToFitWidth = true
                button.addTarget(self, action: #selector(self.handleDelMe), for: .touchDownRepeat)
                button.backgroundColor = UIColor.blue
            }
            button.sizeToFit()
            itemLayout.addSubview(button)
        }
        
        //评估出itemLayout的尺寸，注意这里要明确指定itemLayout的宽度，因为弹出菜单的宽度是sender的宽度-20，而itemLayout的父容器又有20的左右内边距，因此这里要减去40.
        let size = itemLayout.tg_sizeThatFits(CGSize(width:rc.width - 40, height:0))
        scrollView.tg_height.equal(size.height)
        scrollView.tg_height.min(50)
        scrollView.tg_height.max(155)
        //设置scrollView的高度，以及最大最小高度。正是这个实现了拉伸限制功能。
        let closeButton = UIButton()
        closeButton.layer.borderColor = UIColor.darkGray.cgColor
        closeButton.layer.borderWidth = 1
        closeButton.setTitle(NSLocalizedString("close pop menu", comment:""), for: .normal)
        closeButton.setTitleColor(UIColor.red, for: .normal)
        closeButton.backgroundColor = UIColor.white
        closeButton.addTarget(self, action: #selector(self.handleClosePopmenu), for: .touchUpInside)
        closeButton.tg_top.equal(5)
        closeButton.sizeToFit()
        containerLayout.addSubview(closeButton)
        
        let tipLabel = UILabel()
        tipLabel.text = NSLocalizedString("you can add and remove item to shrink the pop menu.", comment:"")
        tipLabel.adjustsFontSizeToFitWidth = true
        tipLabel.sizeToFit()
        containerLayout.addSubview(tipLabel)
        
        //注意这里的self.view是框架布局实现的。
        self.frameLayout.addSubview(menuLayout)
        //为实现动画效果定义初始位置和尺寸。
        menuLayout.frame = CGRect(x:10, y:self.frameLayout.bounds.height, width:rc.width - 20, height:0)
        self.popmenuLayout = menuLayout
        
        self.frameLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    func handleAddMe(sender: UIButton) {
        
        let button = UIButton()
        button.setTitle(NSLocalizedString("double tap remove:\(sender.superview!.subviews.count)", comment:""), for: .normal)
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(self.handleDelMe), for: .touchDownRepeat)
        button.backgroundColor = UIColor.blue
        button.sizeToFit()
        
        self.popmenuItemLayout.insertSubview(button, belowSubview: sender)
        //重新评估popmenuItemLayout的高度，这里宽度是0的原因是因为宽度已经明确了，也就是在现有的宽度下评估。而前面是因为popmenuItemLayout的宽度还没有明确所以要指定宽度。
        let size = self.popmenuItemLayout.tg_sizeThatFits()
        self.popmenuScrollView.tg_height.equal(size.height)
        //多个布局同时动画。
        self.popmenuItemLayout.tg_layoutAnimationWithDuration(0.3)
        self.popmenuLayout.tg_layoutAnimationWithDuration(0.3)
        self.popmenuContainerLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    func handleDelMe(sender: UIButton!)
    {
        sender.removeFromSuperview()
        let size = self.popmenuItemLayout.tg_sizeThatFits()
        self.popmenuScrollView.tg_height.equal(size.height)
        self.popmenuItemLayout.tg_layoutAnimationWithDuration(0.3)
        self.popmenuLayout.tg_layoutAnimationWithDuration(0.3)
        self.popmenuContainerLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    func handleClosePopmenu(sender: UIButton!) {
        //因为popmenuLayout的设置会激发frameLayout的重新布局，所以这里用这个方法进行动画消失处理。
        self.popmenuLayout.tg_top.equal(self.frameLayout.frame.size.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.frameLayout.layoutIfNeeded()
            }, completion: {(finished: Bool) in
                self.popmenuLayout.removeFromSuperview()
        })
    }
}
