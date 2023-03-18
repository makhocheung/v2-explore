//
//  TopicContentView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2023/3/18.
//

import Foundation
import Kingfisher
import SwiftSoup
import SwiftUI

struct TopicContentView: View {
    let html: String?
    let isMarkdown: Bool

    var body: some View {
        if let html {
            if isMarkdown {
                MarkdownTopicContentView(html: html)
            } else {
                PlainTopicContentView(html: html)
            }
        } else {
            Text("无内容")
                .foregroundColor(.secondary)
        }
    }
}

struct ReplyContentView: View {
    let html: String?

    var body: some View {
        if let html {
            ReplyHtmlContentView(html: html)
        } else {
            Text("无内容")
                .foregroundColor(.secondary)
        }
    }
}

struct MarkdownTopicContentView: View {
    let html: String
    var body: some View {
        VStack(alignment: .leading) {
            ContentConverter.shared.convertMarkdownContent(html: html)
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PlainTopicContentView: View {
    let html: String
    var body: some View {
        VStack(alignment: .leading) {
            ContentConverter.shared.convertPlainContent(html: html)
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ReplyHtmlContentView: View {
    let html: String
    var body: some View {
        VStack(alignment: .leading) {
            ContentConverter.shared.convertPlainContent(html: html)
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// struct TopicContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TopicContentView(html: html2)
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
// }

class ContentConverter {
    static let shared = ContentConverter()

    @ViewBuilder
    func convertMarkdownContent(html: String) -> some View {
        let doc = try! SwiftSoup.parseBodyFragment(html)
        let divElement = try! doc.getElementsByTag("div").first()!
        let elements = divElement.children()
        ForEach(0 ..< elements.count, id: \.self) { index in
            self.blockView(elements[index])
        }
    }

    func convertPlainContent(html: String) -> some View {
        let doc = try! SwiftSoup.parseBodyFragment(html)
        let divElement = try! doc.getElementsByTag("div").first()!
        var text = Text("")
        for node in divElement.getChildNodes() {
            if let textNode = node as? TextNode {
                text = text + Text(textNode.text().trimmingCharacters(in: .whitespaces))
            } else if let elementNode = node as? Element {
                if elementNode.tagName() == "br" {
                    text = text + Text("\n")
                } else {
                    try! text = text + dispatchInline(elementNode)
                }
            }
        }
        return text
            .lineSpacing(2)
    }

    @ViewBuilder
    func blockView(_ element: Element, index: Int? = nil) -> some View {
        switch element.tagName() {
        case "p":
            try! AnyView(handleP(element).padding(.vertical, 1))
        case "h1":
            try! AnyView(handleH1(element).padding(.vertical, 4))
        case "h2":
            try! AnyView(handleH2(element).padding(.vertical, 4))
        case "h3":
            try! AnyView(handleH3(element).padding(.vertical, 4))
        case "h4":
            try! AnyView(handleH4(element).padding(.vertical, 4))
        case "h5":
            try! AnyView(handleH5(element).padding(.vertical, 4))
        case "h6":
            try! AnyView(handleH6(element).padding(.vertical, 4))
        case "hr":
            AnyView(handleHr())
        case "blockquote":
            try! AnyView(handleBlockquote(element))
        case "ul":
            AnyView(handleUl(element))
        case "li":
            AnyView(handleLi(element, index: index))
        case "ol":
            AnyView(handleOl(element))
        case "pre":
            AnyView(try! handlePre(element))
        default:
            AnyView(handleUnkown(""))
        }
    }

    func handleP(_ p: Element) throws -> some View {
        if p.children().first()?.tagName() == "img" {
            var images: [KFImage] = []
            for element in p.children() {
                if element.tagName() == "img" {
                    try images.append(KFImage(URL(string: element.attr("src"))!))
                }
            }
            return AnyView(ForEach(0 ..< images.count, id: \.self) { index in
                images[index]
                    .resizable()
                    .scaledToFit()
            })
        } else {
            var text = Text("")
            for node in p.getChildNodes() {
                if let textNode = node as? TextNode {
                    text = text + Text(textNode.text())
                } else if let elementNode = node as? Element {
                    try text = text + dispatchInline(elementNode)
                }
            }
            return AnyView(text)
        }
    }

    func handleMix(_ mix: Element) throws -> some View {
        if mix.children().first()?.tagName() == "img" {
            var images: [KFImage] = []
            for element in mix.children() {
                if element.tagName() == "img" {
                    try images.append(KFImage(URL(string: element.attr("src"))!))
                }
            }
            return AnyView(ForEach(0 ..< images.count, id: \.self) { index in
                images[index]
                    .resizable()
                    .scaledToFit()
            })
        } else {
            var text = Text("")
            for node in mix.getChildNodes() {
                if let textNode = node as? TextNode {
                    text = text + Text(textNode.text())
                } else if let elementNode = node as? Element {
                    try text = text + dispatchInline(elementNode)
                }
            }
            return AnyView(text)
        }
    }

    func handleH1(_ element: Element) throws -> some View {
        Text(try element.text())
            .font(.largeTitle)
    }

    func handleH2(_ element: Element) throws -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(try! element.text())
                .font(.title)
                .bold()
            Divider()
        }
    }

    func handleH3(_ element: Element) throws -> some View {
        Text(try element.text())
            .font(.title2)
            .bold()
    }

    func handleH4(_ element: Element) throws -> some View {
        Text(try element.text())
            .font(.title3)
    }

    func handleH5(_ element: Element) throws -> some View {
        Text(try element.text())
            .font(.headline)
    }

    func handleH6(_ element: Element) throws -> some View {
        Text(try element.text())
            .font(.subheadline)
    }

    func handleHr() -> some View {
        Rectangle()
            .fill(.quaternary)
            .frame(height: 2)
    }

    func handleBlockquote(_ element: Element) throws -> some View {
        blockView(element.children().first()!)
            .foregroundColor(.secondary)
            .padding(.horizontal, 5)
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(Color.indigo)
                    .frame(width: 2.5)
            }
    }

    func handlePre(_ element: Element) throws -> some View {
        try dispatchInline(element.children().first()!)
            .padding()
            .background(.thinMaterial)
    }

    func handleUl(_ ul: Element) -> some View {
        let liElements = ul.children()
        return VStack(alignment: .leading, spacing: 4) {
            ForEach(0 ..< liElements.count, id: \.self) { index in
                self.blockView(liElements[index])
            }
        }
    }

    func handleLi(_ li: Element, index: Int?) -> some View {
        HStack(alignment: .top, spacing: 0) {
            if let index {
                Text("\(index). ")
                    .monospacedDigit()
            } else {
                Image(systemName: "circle.fill")
                    .scaleEffect(0.4)
            }
            if li.children().count == 1 && li.children().first()!.tagName() == "p" {
                try! handleP(li.children().first()!)
            } else {
                try! handleMix(li)
            }
        }
    }

    func handleOl(_ ol: Element) -> some View {
        let olElements = ol.children()
        return VStack(alignment: .leading, spacing: 4) {
            ForEach(0 ..< olElements.count, id: \.self) { index in
                self.blockView(olElements[index], index: index + 1)
            }
        }
    }

    func handleUnkown(_ tagName: String) -> some View {
        Text("Mak \(tagName)")
    }

    func dispatchInline(_ element: Element) throws -> Text {
        if element.tagName() == "a" {
            return try handleA(element)
        } else if element.tagName() == "strong" {
            return try handleStrong(element)
        } else if element.tagName() == "em" {
            return try handleEm(element)
        } else if element.tagName() == "code" {
            return try handleCode(element)
        } else {
            return Text("遇到无法处理的 DOM \(element.tagName())")
        }
    }

    func handleA(_ a: Element) throws -> Text {
        var attributedString = AttributedString((try? a.text()) ?? "")
        attributedString.link = URL(string: (try? a.attr("href")) ?? "")
        attributedString.cursor = NSCursor.openHand
        return Text(attributedString)
    }

    func handleStrong(_ strong: Element) throws -> Text {
        Text(try strong.text())
            .bold()
    }

    func handleEm(_ em: Element) throws -> Text {
        Text(try em.text())
            .italic()
    }

    func handleCode(_ code: Element) throws -> Text {
        Text(try code.text())
            .fontWeight(.semibold)
    }
}

let html = #"""
<div class="markdown_body"><p>[内推]小米公司-社招内推-互联网业务部-南京区域专场-前端开发工程师-3 年及以上工作经验</p>
<ul>
<li>南京市·全职·职位 ID：L1217</li>
</ul>
<h2>职位描述</h2>
<p>1. 负责小米移动核心业务开发、关键技术选型、难点攻坚、代码编写和维护等工作(pc/小程序 /H5)；</p>
<p>2. 负责维护现有系统和新系统的平稳运行，适时做出改进和重构，能够保证质量的同时较为快速的响应产品业务需求；</p>
<p>3. 负责前端基础体系建设、公共组件的设计开发、内部效率工具平台建设，</p>
<p>4. 参与团队技术研讨和分享，促进团队进步和个人能力提升；</p>
<h2>职位要求</h2>
<p>1. 本科及以上学历，计算机相关专业，3 年以上工作经验；</p>
<p>2. 熟练掌握 JS 、CSS 、HTML 、协议、安全、网络、性能优化等前端技术；</p>
<p>3. 熟练掌握 ES6 ，熟悉 NodesJS ，熟悉前端工程化；</p>
<p>4. 对主流前端框架（ React Vue ）至少对一种有深入应用，并深入理解其设计原理；</p>
<p>5. 具有快速定位和解决问题的能力；</p>
<p>6. 能对具体的产品进行性能优化，实现极致的页面加载、执行和渲染时间；</p>
<p>7. 良好的沟通和团队协作能力、热爱技术、责任心强、能推动新技术框架的落地使用；</p>
<p>8. 有混合开发经验着优先；</p>
<p>9. 有 LowCode 平台开发经验优先；</p>
<h2>薪资面议</h2>
<h2>内推码</h2>
<ul>
<li>
<p>小米公司社招内推码: TCE22UT</p>
</li>
<li>
<p>投递链接: <a href="https://xiaomi.jobs.f.mioffice.cn/referral/m/position/detail/?token=MTsxNjc5MDQ5MDI3NDk4OzcwMTE2MDM4NjYwNjgyNzEyMTM7NzE5NzcwODMwNzA3NDM2NzU5Nw" rel="nofollow">https://xiaomi.jobs.f.mioffice.cn/referral/m/position/detail/?token=MTsxNjc5MDQ5MDI3NDk4OzcwMTE2MDM4NjYwNjgyNzEyMTM7NzE5NzcwODMwNzA3NDM2NzU5Nw</a></p>
</li>
</ul>
<hr>
<h2>其他岗位也可以内推：</h2>
<p>小米公司-社招内推-互联网业务部-南京区域专场，其他岗位也在招聘，比如产品、设计、研发、测试、项目管理。欢迎大家留言或者私聊我，找我内推 :-)</p>
<h3>Java 开发工程师</h3>
<ul>
<li>小米公司社招内推码: TCE22UT</li>
<li> 投递链接: <a href="https://xiaomi.jobs.f.mioffice.cn/referral/m/position/detail/?token=MTsxNjc5MDQ5MjYzMjk5OzcwMTE2MDM4NjYwNjgyNzEyMTM7NzE5NzcxMDEyMjYwMDM0OTgwNA" rel="nofollow">https://xiaomi.jobs.f.mioffice.cn/referral/m/position/detail/?token=MTsxNjc5MDQ5MjYzMjk5OzcwMTE2MDM4NjYwNjgyNzEyMTM7NzE5NzcxMDEyMjYwMDM0OTgwNA</a></li>
</ul>
<h3>测试开发工程师：</h3>
<ul>
<li>
<p>小米公司社招内推码: TCE22UT</p>
</li>
<li>
<p>投递链接: <a href="https://xiaomi.jobs.f.mioffice.cn/referral/m/position/detail/?token=MTsxNjc4NDUwNjA5ODMzOzcwMTE2MDM4NjYwNjgyNzEyMTM7NzE5NzY1Njc0MTQxNjA1ODk4OA" rel="nofollow">https://xiaomi.jobs.f.mioffice.cn/referral/m/position/detail/?token=MTsxNjc4NDUwNjA5ODMzOzcwMTE2MDM4NjYwNjgyNzEyMTM7NzE5NzY1Njc0MTQxNjA1ODk4OA</a></p>
</li>
</ul>
<h3>产品经理：</h3>
<ul>
<li>
<p>小米公司社招内推码: TCE22UT</p>
</li>
<li>
<p>投递链接: <a href="https://xiaomi.jobs.f.mioffice.cn/referral/m/position/detail/?token=MTsxNjc4NDUwNjYxMzMwOzcwMTE2MDM4NjYwNjgyNzEyMTM7NzE5NzczMDU4OTA0NjU4NzUwMA" rel="nofollow">https://xiaomi.jobs.f.mioffice.cn/referral/m/position/detail/?token=MTsxNjc4NDUwNjYxMzMwOzcwMTE2MDM4NjYwNjgyNzEyMTM7NzE5NzczMDU4OTA0NjU4NzUwMA</a></p>
</li>
</ul>
</div>
"""#

let html2 = #"""
<div class="markdown_body"><h1>寻求跳槽的原因</h1>
<ol>
<li>希望寻求更高的薪资，公司加薪难</li>
<li>希望寻求一个更有竞争力的平台，当前平台的竞争力比较低，算是养老公司，看着两位在公司多年的老员工被裁难以找工作，危机感爆满</li>
</ol>
<h1>求职结果</h1>
<p>20 年毕业的 Java 后端，原先做的是偏物联网的层面，一共拿的 Offer 大致如下：</p>
<ul>
<li>物联网 15k</li>
<li>日本派遣 26w</li>
<li>日本正社员，不用派遣 30w</li>
<li>互联网 SASS ，类似链家业务，14k</li>
<li>某银行外包 16k</li>
<li>某创业公司，单休，还在 argue17k ，大概率不考虑了</li>
</ul>
<p>现在的选择是决定互联网 SASS ，从薪酬层面上来说是降薪，原公司年薪在 20w 上下，考虑到奖金的不稳定性，都去掉奖金的情况下来看是平跳。从平台上来看是，原公司做的偏底层以及在并发量、性能考虑这些上有所欠缺，也是此次找工作中最大的短板。从工作强度上来说，原公司的工作强度我个人觉得翻遍整个中国互联网应该都是算极少的，个人通常一个月的工作量就是几个小时就能完成。</p>
<h1>面试复习思路</h1>
<p>个人在进入当前公司的第一年就有想法两年工作期限满跳槽，由于工作比较清闲，所以平时有保持算法学习、阅读 CSAPP 等书籍的习惯。</p>
<p>所以复习主体知识的时间拉的比较短，年前决定年后跳槽开始之后，遂停掉了打基础的学习方法，直接开启复习模式。</p>
<p>复习模式主要是借助思维导图以及面试模拟来做，具体实施是首先列出需要复习的技术点的大体框架，以 redis 为例，首先大的层面划分为高可用机制、持久化机制、数据结构、应用等等，再针对每个层面去搜索博客进行细化。</p>
<p>所有知识点通过思维导图图谱复习，这个时期是边复习边面试，面试过程中遇到了新的问题进行记录，并重点复习。</p>
<p>此外建立了一个面试模拟文档，自己根据知识点进行提问，普通的知识点是搜索博客已经文档后自行补充。针对于项目这块提问，借助 chatGpt 来帮忙完善，由于公司所涉及的业务并不算复杂，很多针对项目的提问如果回答的太简单直接被 pass ，如设计模式的应用可以告诉 ChatGpt 业务，使其帮忙进行设想，如消息中心以及缓存的一些边界问题考虑，我首先是研究自己的项目是否有这些强需求，即使没有，也会结合项目业务以及 ChatGpt 来编造。</p>
<p>一个月下来完善的思维导图以及面试模拟文档都已经很庞大了。</p>
<h1>求职总结</h1>
<ol>
<li>
<p>早期准备不充分的时候不要害怕面试，面试没有准备好了一说，只有去面了你才能知道你的能力以及当前市场你能匹配上的面试是怎样的。</p>
</li>
<li>
<p>不要有练手的想法去面试，降维面试是无效面试。一开始我考虑先拿小公司（当然后面我面的也基本都是中小公司）练手面试，但根据我实际体验下来，我考虑不会去的公司通常不仅仅是公司小以及薪资低，更重要的是能留在这些公司不走的面试官很可能自身水平就不高，面试内容对你后续面试毫无帮助。简单理解就是这部分面试官可能会问你 API ，甚至在你答不上的情况下进行 PUA 。当然这点也有可能是因为我个人只能对标中小公司，再进行降温就是特小公司，可能这只是特小公司的问题。如果您对标的是上市企业、独角兽，再进行降温面试中型例如 D 轮互联网可能会避免这个问题。</p>
</li>
<li>
<p>面试一定会遇到无效面试，如果遇到无效面试不要自我怀疑，负面情绪对于找工作没有任何帮助，今早学会调整。举例以下无效面试场景以及提名两家公司避雷。</p>
<p>无效面试包含不限于以下场景：</p>
<ul>
<li>面试官面试水平差，只能通过面试题来面，题目跳脱没有逻辑性，完全是根据面试题提问。</li>
<li>面试官不看简历提问，这个不论面试官水平如何，完全不看简历面试，会出现没有接触过的知识或场景。</li>
<li>面试官体验差，避雷深圳某云科技（需加班，周六加班无调休）一面面试官，全程八股文提问（个人不反感八股文，我也是八股文选手），但是面试官体验很差，具体体现在如下几点：JVM 有答不上的题，直接嘲讽只是了解，为什么要写熟知。面试犹如背题，你只能回答标准答案，当遇到没记住的点希望能拓展或者从理解的角度来说会被打断。</li>
<li>HR PUA ，这种我觉得首先要避免小外包就能极力避免这种情况了。点名深圳容大数字，HR 面上来不谈任何内容，直接开始一顿输出 PUA ，甚至说我 96 的年龄大了，技术差（技术官面试评分 7 ，技术面试相对于深圳的面试来说约等于无），输出玩 PUA 之后问了期望薪资，一句给不到直接扭头就走。</li>
</ul>
</li>
<li>
<p>平台很重要，我的短板主要就是经验欠缺，八股文、算法这些都是人人只要付出努力就可以卷的因素，此时履历以及经验就是你刷掉别人的手段</p>
</li>
<li>
<p>现在的程度就是很卷，我指的并不是大家要学习很多东西的卷，而是市场人太多导致的恶性竞争。有多个公式我通过了所有技术面试，部分面试过程中面试官也直言对技术很满意，然而说了期望之后，有一个面试官直言他们只需要能干活的，希望我降低期望，有一个面试官直言需要等待其他候选人面完再挑选，剩下的也不少面试官表示会让 HR 后续进行沟通薪资，然后没有后续。我个人理解，对于高级工程师可能您不具备替代性，公司可能会付出您的期望薪资，我个人对自己的评价是能干活，在对标这个层级上我相信公司的选择也是选择性价比更高的，都是能干活的在面试层面也无法确定谁能干的更好，那么出价低就是你的竞争力。</p>
<p>所以我也是降低期望薪资后开始不断地拿 offer ，但仍然遭遇 HR 不断砍价，由于是裸辞一个多月以及考虑到坑位少担心捡了芝麻丢了西瓜，已决定入职下家，如果您对上面所述有不同看法，欢迎指正以及讨论，不接受人声攻击，如您对我个人有建议，我会慎重考虑，以及提前表示致谢！</p>
</li>
</ol>
</div>
"""#
