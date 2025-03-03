import UIKit
import SnapKit

final class ReminderTime: UIView {

    // MARK: - Private properties

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 20)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    private let trashBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .circleProgressBarGray
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()

    private let trashIcon: UIButton = {
        let button = UIButton()
        button.setImage(.trash, for: .normal)
        button.tintColor = .white
        return button
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 12
        return stack
    }()

    var onDelete: (() -> Void)?

    // MARK: - Inits

    init(time: String) {
        super.init(frame: .zero)
        setup()
        setTime(time)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .tabBar
        layer.cornerRadius = 36
        addSubview(stackView)

        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(trashBackgroundView)
        trashBackgroundView.addSubview(trashIcon)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
            make.height.equalTo(48)
        }

        trashBackgroundView.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }

        trashIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(24)
        }

        trashIcon.addTarget(self, action: #selector(trashTapped), for: .touchUpInside)
    }

    // MARK: - Public Methods

    func setTime(_ time: String) {
        timeLabel.text = time
    }

    @objc private func trashTapped() {
        onDelete?()
    }
}
