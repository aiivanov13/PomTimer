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

    // MARK: - UI Elements

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var startStopButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .systemGreen
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
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
        view.backgroundColor = .blue
    }

    private func setupHierarchy() {
        view.addSubview(circularProgressBarView)
        view.addSubview(startStopButton)
        view.addSubview(timeLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            startStopButton.heightAnchor.constraint(equalToConstant: 40),
            startStopButton.widthAnchor.constraint(equalToConstant: 40),
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startStopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func buttonTapped() {
        isStarted.toggle()

        switch isStarted {
        case true:
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            startStopButton.tintColor = .systemRed
            startStopButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
            timeLabel.textColor = .systemRed
        default:
            timer?.invalidate()
            startStopButton.tintColor = .systemGreen
            startStopButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
            timeLabel.textColor = .systemGreen
        }
    }

    @objc private func update() {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        let date = Date(timeIntervalSince1970: TimeInterval(runCount))
        timeLabel.text = formatter.string(from: date)

        if runCount == 5 && isWorkTime {
            isWorkTime.toggle()
            runCount = -1
        } else if runCount == 10 && !isWorkTime {
            isWorkTime.toggle()
            runCount = -1
        }

        runCount += 1
    }
}
