/* Webcamoid, webcam capture application.
 * Copyright (C) 2019  Gonzalo Exequiel Pedone
 *
 * Webcamoid is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Webcamoid is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Webcamoid. If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: http://webcamoid.github.io/
 */

import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Templates 2.5 as T
import AkQml 1.0

T.ScrollView {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            Ak.newUnit(250 * ThemeSettings.constrolScale, "dp").pixels)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    padding: 0

    background: Rectangle {
        color: Qt.hsla(ThemeSettings.colorBack.hslHue,
                       ThemeSettings.colorBack.hslSaturation,
                       ThemeSettings.colorBack.hslLightness,
                       0.9)
    }

    ScrollBar.vertical: ScrollBar {
        parent: control
        x: control.mirrored ? 0 : control.width - width
        y: control.topPadding
        height: control.availableHeight
        active: control.ScrollBar.horizontal.active
    }

    ScrollBar.horizontal: ScrollBar {
        parent: control
        x: control.leftPadding
        y: control.height - height
        width: control.availableWidth
        active: control.ScrollBar.vertical.active
    }
}
