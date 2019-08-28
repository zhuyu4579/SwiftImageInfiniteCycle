//
//  ViewController.swift
//  SwiftImageCycle
//
//  Created by 浙大网新中研软件 on 2019/8/28.
//  Copyright © 2019 浙大网新中研软件. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {
    //图片名称
    let imgs : [String] = ["1","2","3","4","5"]
    //轮播定时器
    var autoTimer : Timer?
    //滑动View
    var scroolView = UIScrollView()
    //轮播图片
    var lefImage,midImage,rightImage : UIImageView?
    //分页器
    var pageControl = UIPageControl()
    
    let mainW = UIScreen.main.bounds.size.width
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        scroolView = UIScrollView(frame:CGRect(x: 0, y: 0, width: mainW, height: mainW + 20))
        scroolView.delegate = self
        scroolView.contentSize = CGSize(width: mainW * 5, height: mainW)
        scroolView.contentOffset = CGPoint(x: mainW, y: 0)
        scroolView.bounces = false
        scroolView.isPagingEnabled = true
        scroolView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scroolView)
        
        pageControl = UIPageControl(frame: CGRect(x: mainW/2-60, y: mainW, width: 120, height: 20))
        pageControl.numberOfPages = self.imgs.count
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
        
        lefImage = UIImageView(frame: CGRect(x: 0, y: 0, width: mainW, height: mainW))
        midImage = UIImageView(frame: CGRect(x: mainW, y: 0, width: mainW, height: mainW))
        rightImage = UIImageView(frame: CGRect(x: mainW*2, y: 0, width: mainW, height: mainW))
        setImage()
        scroolView.addSubview(lefImage!)
        scroolView.addSubview(midImage!)
        scroolView.addSubview(rightImage!)
        autoScrollAction()
        
    }
    //设置轮播定时器
    func autoScrollAction(){
        autoTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollAction), userInfo: nil, repeats: true)
    }
    //滑动距离
    @objc func scrollAction(){
        let offset = CGPoint(x: self.view.frame.width * 2, y: 0)
        scroolView.setContentOffset(offset, animated: true)
        
    }
    //设置图片
    func setImage(){
        if index == 0 {
            lefImage?.image = UIImage(named: imgs.last!)
            midImage?.image = UIImage(named: imgs.first!)
            rightImage?.image = UIImage(named: imgs[1])
        }else if index == imgs.count-1{
            lefImage?.image = UIImage(named: imgs[index - 1])
            midImage?.image = UIImage(named: imgs.last!)
            rightImage?.image = UIImage(named: imgs.first!)
        }else{
            lefImage?.image = UIImage(named: imgs[index - 1])
            midImage?.image = UIImage(named: imgs[index])
            rightImage?.image = UIImage(named: imgs[index + 1])
        }
    }
    //scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scroolView.contentOffset.x
        if imgs.count != 0 {
            if(offset >= mainW * 2){
                scrollView.contentOffset = CGPoint(x: mainW, y: 0)
                index = index + 1
                if index == imgs.count{
                    index = 0
                }
            }
            if(offset <= 0){
                scrollView.contentOffset = CGPoint(x: mainW, y: 0)
                index = index - 1
                if index == -1 {
                    index = imgs.count - 1
                }
            }
            setImage()
            self.pageControl.currentPage = index
        }
        
    }
  //当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        autoTimer?.invalidate()
    }
      // 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
  //decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        autoScrollAction()
    }
}

