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
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.5 as T
import QtGraphicalEffects 1.0
import QtQuick.Controls.impl 2.12
import AkQml 1.0

T.TextArea {
    id: textArea
    color: ThemeSettings.colorText
    font.family: "Courier"
    placeholderTextColor: ThemeSettings.shade(ThemeSettings.colorBack, -0.5)
    selectedTextColor: ThemeSettings.colorText
    selectionColor: ThemeSettings.colorSecondary
    padding: Ak.newUnit(12 * ThemeSettings.constrolScale, "dp").pixels
    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            implicitBackgroundWidth + leftInset + rightInset,
                            placeholder.implicitWidth + leftPadding + rightPadding,
                            Ak.newUnit(280 * ThemeSettings.constrolScale,
                                       "dp").pixels)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight + topInset + bottomInset,
                             placeholder.implicitHeight + topPadding + bottomPadding,
                             Ak.newUnit(36 * ThemeSettings.constrolScale,
                                        "dp").pixels)

    readonly property int animationTime: 100
    readonly property real placeHolderPadding:
        Ak.newUnit(4 * ThemeSettings.constrolScale, "dp").pixels

    PlaceholderText {
        id: placeholder
        x: textArea.leftPadding
        y: textArea.topPadding

        text: textArea.placeholderText
        font: textArea.font
        color: ThemeSettings.colorText
        verticalAlignment: textArea.verticalAlignment
        elide: Text.ElideRight
        renderType: textArea.renderType
        opacity: 0
        visible: textArea.placeholderText.length
    }

    background: Rectangle {
        color: ThemeSettings.shade(ThemeSettings.colorBack, -0.1)
    }
}
