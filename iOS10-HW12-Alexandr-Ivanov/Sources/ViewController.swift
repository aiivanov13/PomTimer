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
    private var duration = 25.0
    private var fromValue: CGFloat = 1
    private var toValue: CGFloat = 0
    private var workingTime = 25.0
    private var restTime = 10.0

    // MARK: - UI Elements

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = String(Int(duration))
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 60, weight: .thin)
        label.textColor = .white
        label.textAlignment = .center
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
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60, weight: .thin)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "WORK"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
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
        view.addSubview(titleLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            circularProgressBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularProgressBarView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            timeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startStopButton.heightAnchor.constraint(equalToConstant: 45),
            startStopButton.widthAnchor.constraint(equalToConstant: 45),
            startStopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height / 3.5),
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.bounds.height / 3.5)
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
        let rounded = runCount.rounded(.up)
        let date = Date(timeIntervalSince1970: TimeInterval(rounded))

        formatter.dateFormat = "ss"
        timeLabel.text = formatter.string(from: date)

        guard rounded == 0 else {
            runCount -= 0.01
            return
        }

        if isWorkTime {
            fromValue = 1
            toValue = 0
            duration = workingTime
            titleLabel.text = "WORK"
            runCount = workingTime
        } else {
            fromValue = 0
            toValue = 1
            duration = restTime
            titleLabel.text = "REST"
            runCount = restTime
        }

        isWorkTime.toggle()
        circularProgressBarView.progressAnimation(duration: duration, from: fromValue, to: toValue)
    }
}
