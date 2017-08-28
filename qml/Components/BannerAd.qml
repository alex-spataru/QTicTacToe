/*
 * Copyright (c) 2017 Alex Spataru <alex_spataru@outlook.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import QtQuick 2.0
import com.dreamdev.QtAdMobBanner 1.0

Item {
    id: container
    onVisibleChanged: configureAd()
    onEnabledChanged: configureAd()

    property string bannerId: ""

    function configureAd() {
        ad.unitId = bannerId
        ad.size = AdMobBanner.Banner
        ad.visible = container.visible && container.enabled && app.adsEnabled
        locateBanner()
    }

    function locateBanner() {
        var width = ad.width / DevicePixelRatio
        var height = ad.height / DevicePixelRatio

        container.width = width
        container.height = height

        ad.x = ((app.width - width) / 2) * DevicePixelRatio
        ad.y = (app.height - height + (x / DevicePixelRatio) / 2) * DevicePixelRatio
    }

    Connections {
        target: app
        onWidthChanged: locateBanner()
        onHeightChanged: locateBanner()
        onAdsEnabledChanged: configureAd()
    }
}