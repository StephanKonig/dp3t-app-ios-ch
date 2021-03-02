//
/*
 * Copyright (c) 2020 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import UIKit

class NSCovidCodesStatisticsModuleView: UIView {
    private let stackView = UIStackView()
    private let infoButton = UBButton()
    private let stat1 = NSSingleStatisticView(textColor: .ns_blue, header: "stats_covidcodes_total_header".ub_localized, description: "stats_covidcodes_total_label".ub_localized)
    private let stat2 = NSSingleStatisticView(textColor: .ns_blue, header: "stats_covidcodes_0to2days_header".ub_localized, description: "stats_covidcodes_0to2days_label".ub_localized)

    var infoButtonCallback: (() -> Void)? {
        get { infoButton.touchUpCallback }
        set { infoButton.touchUpCallback = newValue }
    }

    init() {
        super.init(frame: .zero)

        backgroundColor = .ns_moduleBackground
        isAccessibilityElement = true

        setupLayout()
        addContent()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: NSPadding.medium, left: NSPadding.medium, bottom: NSPadding.medium, right: NSPadding.medium)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Info button (added after stackView so it is on top)
        infoButton.setImage(UIImage(named: "ic-info-outline")?.withRenderingMode(.alwaysTemplate), for: .normal)
        infoButton.tintColor = .ns_blue
        addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(NSPadding.medium)
        }

        ub_addShadow(radius: 4, opacity: 0.1, xOffset: 0, yOffset: -1)
    }

    private func addContent() {
        let title = NSLabel(.title, textAlignment: .center)
        title.text = "stats_covidcodes_title".ub_localized

        stackView.addArrangedView(title)
        stackView.addSpacerView(NSPadding.medium)

        let statsStackView = UIStackView()
        statsStackView.spacing = NSPadding.small
        statsStackView.distribution = .fillEqually

        statsStackView.addArrangedView(stat1)
        statsStackView.addArrangedView(stat2)

        stackView.addArrangedView(statsStackView)
    }

    func setData(statisticData: StatisticsResponse?) {
        guard let data = statisticData else {
            stat1.formattedNumber = nil
            stat2.formattedNumber = nil
            return
        }

        stat1.formattedNumber = data.covidCodes
        stat2.formattedNumber = data.covidCodesAfter0to2d
    }
}
