//
//  ViewController.swift
//  iOS10-HW12-Alexandr-Ivanov
//
//  Created by Александр Иванов on 17.06.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Flags

    private var isWorkTime = true
    private var isStarted = false

    // MARK: - Timer

    private var timer: Timer?
    private var runCount = 0.0
    private var duration: TimeInterval = 25


    // MARK: - UI Elements

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 60, weight: .thin)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var startStopButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var circularProgressBarView: CircularProgressBarView = {
        let view = CircularProgressBarView()
        view.createCircularPath()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setups
    private func setupView() {
        view.backgroundColor = .black
    }

    private func setupHierarchy() {
        view.addSubview(circularProgressBarView)
        view.addSubview(timeLabel)
        view.addSubview(startStopButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            circularProgressBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularProgressBarView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 1),
            timeLabel.widthAnchor.constraint(equalToConstant: 156),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startStopButton.heightAnchor.constraint(equalToConstant: 45),
            startStopButton.widthAnchor.constraint(equalToConstant: 45),
            startStopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: (((view.bounds.height / 2) + 60) / 2)),
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func buttonTapped() {
        isStarted.toggle()

        switch isStarted {
        case true:
            circularProgressBarView.resumeAnimation()
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            startStopButton.tintColor = .systemOrange
            startStopButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
        default:
            circularProgressBarView.pauseAnimation()
            timer?.invalidate()
            startStopButton.tintColor = .white
            startStopButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        }
    }

    @objc private func update() {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        let date = Date(timeIntervalSince1970: TimeInterval(runCount))
        timeLabel.text = formatter.string(from: date)
        let rounded = round(runCount * pow(10, 2)) / pow(10, 2)

        if rounded == 25.0 && isWorkTime {
            duration = 10
            isWorkTime.toggle()
            runCount = 0
        } else if rounded == 10.0 && !isWorkTime {
            duration = 25
            isWorkTime.toggle()
            runCount = 0
        } else if rounded == 0.01 {
            circularProgressBarView.progressAnimation(duration: duration)
        }

        runCount += 0.01
    }
}
