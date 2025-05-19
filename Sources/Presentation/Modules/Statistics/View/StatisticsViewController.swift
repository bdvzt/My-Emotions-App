//
//  StatisticsViewController.swift
//  LAB1
//
//  Created by Zayata Budaeva on 20.02.2025.
//

import UIKit
import SnapKit
// TODO: - асинхронная загрузка статистики
// TODO: - если неделя пустая, то добавить плейсхолдер
class StatisticsViewController: UIViewController {
    
    // MARK: - Dependencies
    let statisticsViewModel: StatisticsViewModel
    
    // MARK: - Private properties
    
    private var weeks: [StatWeek] = []
    private var currentIndex: Int = 0
    private var stats: WeekStatistic?
    
    private let chooseWeekScrollView = UIScrollView()
    private let chooseWeekButtons = UIStackView()
    private let indicatorLine = UIView()
    private let weeksLine = UIView()
    
    private lazy var statisticsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StatisticsSectionCell.self, forCellWithReuseIdentifier: "StatisticsSectionCell")
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 4
        control.currentPage = 0
        control.currentPageIndicatorTintColor = .white
        control.pageIndicatorTintColor = .gray
        control.backgroundColor = .clear
        control.transform = CGAffineTransform(scaleX: 0.6, y: 0.6).rotated(by: .pi / 2)
        return control
    }()
    
    // MARK: - Init
    init(statisticsViewModel: StatisticsViewModel) {
        self.statisticsViewModel = statisticsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        showStatistics()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupWeeks()
        setupView()
        setupPageControl()
    }
    
    private func setupView() {
        view.backgroundColor = .black
        setupWeekScrollView()
        setupIndicatorLine()
        updateIndicatorLinePosition()
        setupWeeksLine()
        setupMainScrollView()
    }
    
    private func setupWeeks() {
        statisticsViewModel.loadWeeks()
        weeks = statisticsViewModel.weeks
        
        chooseWeekButtons.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for index in 0..<weeks.count {
            let week = weeks[index]
            let button = setupWeekButton(for: week, index: index)
            chooseWeekButtons.addArrangedSubview(button)
        }
    }
    
    private func setupWeekButton(for week: StatWeek, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(week.week, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "VelaSans-Regular", size: 16)
        button.tag = index
        button.addTarget(self, action: #selector(weekButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func setupWeekScrollView() {
        view.addSubview(chooseWeekScrollView)
        chooseWeekScrollView.addSubview(chooseWeekButtons)
        
        chooseWeekScrollView.showsHorizontalScrollIndicator = false
        chooseWeekScrollView.alwaysBounceHorizontal = true
        chooseWeekScrollView.bounces = true
        
        chooseWeekButtons.axis = .horizontal
        chooseWeekButtons.spacing = 16
        
        chooseWeekScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(50)
        }
        
        chooseWeekButtons.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupIndicatorLine() {
        indicatorLine.backgroundColor = .white
        chooseWeekButtons.addSubview(indicatorLine)
        updateIndicatorLinePosition()
    }
    
    private func updateIndicatorLinePosition() {
        guard let button = chooseWeekButtons.arrangedSubviews[currentIndex] as? UIButton else {
            return
        }
        
        let buttonWidth = button.frame.width
        
        indicatorLine.snp.remakeConstraints { make in
            make.top.equalTo(button.snp.bottom)
            make.height.equalTo(3)
            make.width.equalTo(buttonWidth)
            make.leading.equalTo(button.snp.leading)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.chooseWeekButtons.layoutIfNeeded()
        }
    }
    
    private func setupWeeksLine() {
        weeksLine.backgroundColor = .lightGray
        view.addSubview(weeksLine)
        weeksLine.snp.makeConstraints { make in
            make.top.equalTo(indicatorLine.snp.bottom)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
    }
    
    private func setupMainScrollView() {
        view.addSubview(statisticsCollectionView)
        statisticsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chooseWeekScrollView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(8)
        }
    }
    
    @objc private func weekButtonTapped(_ sender: UIButton) {
        currentIndex = sender.tag
        updateIndicatorLinePosition()
        showStatistics()
    }
    
    private func showStatistics() {
        let week = weeks[currentIndex]
        stats = statisticsViewModel.loadStatistics(for: week.interval)
        statisticsCollectionView.reloadData()
        
        // MARK: - Debug Output
        guard let stats = stats else {
            print("[Statistics] 🚫 Статистика не найдена")
            return
        }
        
        print("\n🧩 [Statistics] Категории:")
        print("Заметок: \(stats.categoryData.amountOfNotes)")
        print("Красные: \(stats.categoryData.redPercent)%")
        print("Синие: \(stats.categoryData.bluePercent)%")
        print("Зелёные: \(stats.categoryData.greenPercent)%")
        print("Оранжевые: \(stats.categoryData.orangePercent)%")
        
        print("\n📅 [Statistics] По дням недели:")
        for day in stats.dayData {
            print("- \(day.day) (\(day.date)): \(day.moodsTitles.joined(separator: ", "))")
        }
        
        print("\n📊 [Statistics] Самые частые эмоции:")
        for emotion in stats.frequencyData {
            print("- \(emotion.emotion): \(emotion.amount) раз")
        }
        
        print("\n🕓 [Statistics] Части дня:")
        let parts = stats.partsOfDayData
        let map: [(String, [PartOdDayColor])] = [
            ("Раннее утро", parts.earlyMorning),
            ("Утро", parts.morning),
            ("День", parts.day),
            ("Вечер", parts.evening),
            ("Поздний вечер", parts.lateEvening)
        ]
        
        for (label, values) in map {
            print("- \(label):")
            for color in values {
                print("   • \(color.color) — \(color.percentage)%")
            }
        }
        
        print("--------------------------------------------------\n")
    }
}

extension StatisticsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsSectionCell", for: indexPath) as? StatisticsSectionCell else {
            return UICollectionViewCell()
        }
        
        guard let stats = stats else { return cell }
        
        switch indexPath.item {
        case 0:
            cell.setContent(CategoryView(
                viewModel: CategoryStatisticsViewModel(categoryData: stats.categoryData))
            )
        case 1:
            cell.setContent(DayStatisticView(
                viewModel: DayStatisticsViewModel(dayData: stats.dayData))
            )
        case 2:
            cell.setContent(MostFrequentlyView(
                viewModel: MostFrequentViewModel(data: stats.frequencyData))
            )
        case 3:
            cell.setContent(DuringDayView(
                viewModel: PartOfDayStatisticsViewModel(data: stats.partsOfDayData))
            )
        default:
            break
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.y / scrollView.bounds.height + 0.5)
        pageControl.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = collectionView.bounds.width
        return CGSize(width: width, height: height)
    }
}
