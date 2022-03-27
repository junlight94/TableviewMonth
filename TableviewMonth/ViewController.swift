//
//  ViewController.swift
//  TableviewMonth
//
//  Created by Junyoung Lee on 2022/03/27.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // 배열에 들어갈 데이터 구조체
    struct CellData {
        var SectionData = [String]()
        var title = String()
        var open = Bool()
    }
    
    // 전체 데이터를 보여줄 데이터소스
    var viewData = [CellData]()
    
    // 전체 데이터를 보여줄 데디터소스
    var allData = [CellData]()
    
    // 홀수 데이터소스
    var oddData = [CellData]()
    
    // 짝수 데이터소스
    var evenData = [CellData]()
    
    // 주말을 담을 배열
    var weekEndArray = [[String]]()
    
    // 1월 ~ 12월 배열
    let month = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate, dataSource 코드로 연결
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableViewCell의 xib 연결
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        
        //2022년 매월의 시작일 ~ 마지막일 구하기
        for i in 1 ... 12{
            var weekend:[String] = []
            var filterWeek:[String] = []
            let date = dateFormatter.date(from: "2022-\(i)-01")

            let components = calendar.dateComponents([.year, .month], from: date!)

            let startOfMonth = calendar.date(from: components)
            
            let comp1 = calendar.dateComponents([.day,.weekday,.weekOfMonth], from: startOfMonth!)

            let nextMonth = calendar.date(byAdding: .month, value: +1, to: startOfMonth!)!

            let endOfMonth = calendar.date(byAdding: .day, value: -1, to:nextMonth)

            let comp2 = calendar.dateComponents([.day,.weekday,.weekOfMonth], from: endOfMonth!)

            for j in comp1.day!...comp2.day! {
                //전체 주말
                weekend.append(weekEnd(iMonth: i, iDay: j))
                filterWeek = (weekend.filter( { (value: String) -> Bool in return (value != "") } ))
                
            }
            weekEndArray.append(filterWeek)
            
        }
        
        //전체 데이터
        for i in 0 ..< month.count {
            allData.append(CellData(SectionData: weekEndArray[i], title: month[i], open: false))
        }
        //홀수 데이터
        for i in 0 ..< month.count / 2 {
            oddData.append(CellData(SectionData: weekEndArray[(i*2)], title: month[(i*2)], open: false))
        }
        //짝수 데이터
        for i in 0 ..< month.count / 2 {
            evenData.append(CellData(SectionData: weekEndArray[(i*2)+1], title: month[(i*2)+1], open: false))
        }
        
        viewData = allData
    }
    
    //주말 반환 함수 (DateFormat, Calendar)
    func weekEnd(iMonth:Int, iDay:Int) -> String{
        let weekArray = ["일", "월", "화", "수", "목", "금", "토"]
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_kr")
        dateFormat.dateFormat = "yyyy-MM-dd"

        let inputDay = dateFormat.date(from: "2022-\(iMonth)-\(iDay)")
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: inputDay!)

        if weekArray[comps.weekday! - 1] == "토"{
            return "\(iDay) (토)"
        } else if weekArray[comps.weekday! - 1] == "일"{
            return "\(iDay) (일)"
        }
        return ""
    }
    
    @IBAction func allDataAction(_ sender: Any) {
        viewData = allData
        tableView.reloadData()
    }
    
    @IBAction func oddAction(_ sender: Any) {
        viewData = oddData
        tableView.reloadData()
    }
    
    @IBAction func evenAction(_ sender: Any) {
        viewData = evenData
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    // MARK: Section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewData.count
    }
    // MARK: Section 아래 Row의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // tableView Section이 열려있으면 Section 하나에 sectionData 개수만큼 추가
        // +1 은 title 포함하기 위해서
        if viewData[section].open == true{
            return viewData[section].SectionData.count + 1
        } else {
            // 닫혀있는 경우 title만 보여주기 위해서 return 1
            return 1
        }
        
    }
    // MARK: row에 들어갈 데이터
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        // indexPath.row 가 0인 경우 즉, 카테고리 제목인 경우에는 title을 뿌려줍니다
        if indexPath.row == 0{
            cell.cellLabel.text = viewData[indexPath.section].title
            return cell
        } else{
            cell.cellLabel.text = viewData[indexPath.section].SectionData[indexPath.row - 1]
            return cell
        }
        
    }
    // MARK: row가 눌렸을 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // section 부분 선택하면 열리게 설정
        viewData[indexPath.section].open = !viewData[indexPath.section].open
        
        // 해당하는 테이블의 section만 새로고침
        tableView.reloadSections([indexPath.section], with: .none)
    }
}

