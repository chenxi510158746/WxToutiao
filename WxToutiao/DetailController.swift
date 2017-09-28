//
//  DetailController.swift
//  WxToutiao
//
//  Created by chenxi on 2017/9/25.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import UIKit
import WebKit
import LeoDanmakuKit
import LLSwitch
import WZLBadge

class DetailController: UIViewController, LLSwitchDelegate {
    
    var webView : WKWebView!
    var post: Post!
    var isDanmuOn = true
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var danmuView: LeoDanmakuView!
    
    @IBOutlet weak var danmuSwitch: LLSwitch!
    
    @IBAction func commentBtnTap(_ sender: UIButton) {
        print("点击了评论显示按钮！")
        doJavaScriptFunction()
    }
    
    @IBAction func editBegin(_ sender: UITextField) {
        danmuSwitch.isHidden = true
        commentBtn.isHidden = true
    }
    
    @IBAction func editDone(_ sender: UITextField) {
        danmuSwitch.isHidden = false
        commentBtn.isHidden = false
        
        guard let commentText = sender.text else {
            return
        }
        
        loadDanmu(postAComment: commentText)
        
        Post.submitComment(postId: post.id, name: "晨晨希", email: "chenxi510158746@qq.com", content: commentText) { (finish) in
            if finish {
                print("评论保存成功！")
                OperationQueue.main.addOperation {
                    self.showCommentBadge(self.post.comment_count + 1)
                    
                    NotificationCenter.default.post(name: NotificationHelper.updateList, object: nil)
                }
            }
        }
        
        sender.text = ""
    }
    
    func didTap(_ llSwitch: LLSwitch!) {
        if isDanmuOn {
            danmuSwitch.setOn(false, animated: true)
            danmuView.stop()
            danmuView.isHidden = true
        } else {
            danmuSwitch.setOn(true, animated: true)
            danmuView.resume()
            danmuView.isHidden = false
        }
        isDanmuOn = !isDanmuOn
    }
    
    func showCommentBadge(_ count: Int) {
        if count > 0 {
            commentBtn.badgeCenterOffset = CGPoint(x: -4, y: 5)
            commentBtn.showBadge(with: .number, value: count, animationType: .bounce)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = post.title
        
        danmuSwitch.delegate = self
        
        showCommentBadge(post.comment_count)
        
        loadHtml()
        
        loadDanmu(comments: post.comments)
    }

    func loadDanmu(comments: [Comment]? = nil, postAComment: String? = nil) {
        if isDanmuOn {
            danmuView.resume()
            
            if let comments = comments {
                let danmus : [LeoDanmakuModel] = comments.map{
                    
                    let model = LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 15)
                    
                    model?.text = $0.content.html2String
                    
                    return model!
                }
                
                danmuView.addDanmaku(with: danmus)
            }
            
            if let comment = postAComment {
                
                let model = LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 15)
                
                model?.text = comment
                
                danmuView.addDanmaku(model)
            }
            
        } else {
            danmuView.stop()
        }
    }
    
    func loadHtml() {
        let frame = CGRect(x: 0, y: 44, width: view.frame.width, height: view.frame.height - 44 - 20)
        
        webView = WKWebView(frame: frame)
        
        view.insertSubview(webView, at: 0)
        
        let header = """
<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"><style type="text/css">img {width:100%;}</style><script src="https://code.jquery.com/jquery-3.2.1.min.js"></script></head><body>
"""
        let footer = """
</body></html>
"""
        
        let comments = commentHtml(comments: post.comments)
        
        webView.loadHTMLString(header + post.content + comments + footer, baseURL: nil)
    }
    
    func doJavaScriptFunction() {
        let js = "$(\"html,body\").animate({scrollTop: $(\"#comments\").offset().top}, 1000);"
        
        webView.evaluateJavaScript(js) { (result, error) in
            print("js执行结果：", result ?? "nil", error ?? "nil")
        }
        
    }
    
    func commentHtml(comments: [Comment]) -> String {
        var result = "<div id=\"comments\"> <h2>评论：</h2> </div>"
        
        for comment in comments {
            let paragraph = "<p> <h6>\(comment.name!)</h6> <h5>\(comment.content!)</h5> <hr size=1></p>"
            result += paragraph
        }
        
        return result
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
