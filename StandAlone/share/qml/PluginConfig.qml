/* Webcamoid, webcam capture application.
 * Copyright (C) 2016  Gonzalo Exequiel Pedone
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

import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import AkQml 1.0

ColumnLayout {
    id: pluginConfigs

    function fillSearchPaths()
    {
        searchPathsTable.model.clear()
        let searchPaths = globalElement.searchPaths()

        for (let path in searchPaths) {
            searchPathsTable.model.append({
                path: searchPaths[path]
            })
        }
    }

    function fillPluginList()
    {
        pluginsTable.model.clear()
        let pluginsPaths = globalElement.listPluginPaths()

        for (let path in pluginsPaths) {
            pluginsTable.model.append({
                path: pluginsPaths[path],
                pluginEnabled: true
            })
        }

        let blackList = globalElement.pluginsBlackList()

        for (let path in blackList) {
            pluginsTable.model.append({
                path: blackList[path],
                pluginEnabled: false
            })
        }
    }

    function refreshCache()
    {
        globalElement.clearCache()
        fillPluginList()
        PluginConfigs.saveProperties()
    }

    function refreshAll()
    {
        fillSearchPaths()
        refreshCache()
    }

    function colorForIndex(index, pluginEnabled, table) {
        let pal = pluginEnabled? palette: paletteDisabled;

        return index === table.currentIndex?
                           pal.highlight: index & 1?
                               pal.alternateBase: pal.base
    }

    AkElement {
        id: globalElement
    }
    SystemPalette {
        id: palette
    }
    SystemPalette {
        id: paletteDisabled
        colorGroup: SystemPalette.Disabled
    }

    Component.onCompleted: {
        fillSearchPaths()
        fillPluginList()
    }

    Label {
        text: qsTr("Use this page for configuring the plugins search paths.<br /><b>Don't touch nothing unless you know what you are doing</b>.")
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }
    GroupBox {
        title: qsTr("Extra search paths")
        Layout.fillWidth: true
        clip: true

        GridLayout {
            columns: 4
            anchors.fill: parent

            Label {
                text: qsTr("Search plugins in subfolders.")
                Layout.fillWidth: true
            }
            Switch {
                checked: globalElement.recursiveSearch()

                onCheckedChanged: {
                    globalElement.setRecursiveSearch(checked)
                    refreshCache()
                }
            }
            Button {
                text: qsTr("Add")
                icon.source: "image://icons/add"

                onClicked: fileDialog.open()
            }
            Button {
                id: btnRemove
                text: qsTr("Remove")
                icon.source: "image://icons/no"
                enabled: searchPathsTable.currentIndex >= 0

                onClicked: {
                    let searchPaths = globalElement.searchPaths();
                    let sp = []

                    for (let path in searchPaths)
                        if (path != searchPathsTable.currentIndex)
                            sp.push(searchPaths[path])

                    globalElement.setSearchPaths(sp);
                    refreshAll()
                    searchPathsTable.currentIndex = -1
                }
            }
            Rectangle {
                color: palette.base
                height: 150
                Layout.columnSpan: 4
                Layout.fillWidth: true

                ScrollView {
                    id: searchPathsTableScroll
                    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    clip: true
                    contentHeight: searchPathsTable.height
                    anchors.fill: parent

                    ListView {
                        id: searchPathsTable
                        height: contentHeight
                        width: searchPathsTableScroll.width
                               - (searchPathsTableScroll.ScrollBar.vertical.visible?
                                      searchPathsTableScroll.ScrollBar.vertical.width: 0)

                        model: ListModel {
                            id: searchPathsModel
                        }
                        delegate: Rectangle {
                            color: colorForIndex(index, true, searchPathsTable)
                            width: parent.width
                            height: lblPluginSearchPath.height

                            Label {
                                id: lblPluginSearchPath
                                text: path
                                elide: Text.ElideLeft
                                width: parent.width
                            }
                            MouseArea {
                                preventStealing: true
                                anchors.fill: parent

                                onClicked: {
                                    searchPathsTable.currentIndex = index
                                    searchPathsTable.positionViewAtIndex(index, ListView.Contain)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    GroupBox {
        title: qsTr("Plugins list")
        Layout.fillWidth: true
        clip: true

        GridLayout {
            columns: 3
            anchors.fill: parent

            Button {
                text: qsTr("Refresh")
                icon.source: "image://icons/reset"

                onClicked: refreshCache()
            }
            Label {
                Layout.fillWidth: true
            }
            Button {
                id: btnEnableDisable
                text: pluginIsEnabled? qsTr("Disable"): qsTr("Enable")
                enabled: pluginsTable.currentIndex >= 0

                property bool pluginIsEnabled: false

                onClicked: {
                    let blackList = globalElement.pluginsBlackList()
                    let path = pluginsTable.model.get(pluginsTable.currentIndex).path
                    let index = blackList.indexOf(path)

                    if (pluginIsEnabled) {
                        if (index < 0)
                            blackList.push(path)
                    } else {
                        if (index >= 0)
                            blackList.splice(index, 1)
                    }

                    globalElement.setPluginsBlackList(blackList)
                    refreshCache()
                    pluginsTable.currentIndex = -1
                }
            }
            Rectangle {
                color: palette.base
                height: 150
                Layout.columnSpan: 3
                Layout.fillWidth: true

                ScrollView {
                    id: pluginsTableScroll
                    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    clip: true
                    contentHeight: pluginsTable.height
                    anchors.fill: parent

                    ListView {
                        id: pluginsTable
                        height: contentHeight
                        width: pluginsTableScroll.width
                               - (pluginsTableScroll.ScrollBar.vertical.visible?
                                      pluginsTableScroll.ScrollBar.vertical.width: 0)

                        model: ListModel {
                            id: pluginsModel
                        }

                        delegate: Rectangle {
                            color: colorForIndex(index, pluginEnabled, pluginsTable)
                            width: parent.width
                            height: lblPluginPath.height

                            Label {
                                id: lblPluginPath
                                text: path
                                elide: Text.ElideLeft
                                width: parent.width
                                enabled: pluginEnabled
                            }
                            MouseArea {
                                preventStealing: true
                                anchors.fill: parent

                                onClicked: {
                                    pluginsTable.currentIndex = index
                                    pluginsTable.positionViewAtIndex(index, ListView.Contain)
                                }
                            }
                        }

                        onCurrentIndexChanged: {
                            btnEnableDisable.pluginIsEnabled =
                                currentIndex < 0? false: pluginsTable.model.get(currentIndex).pluginEnabled
                        }
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Add plugins search path")
        selectFolder: true

        onAccepted: {
            let path = Webcamoid.urlToLocalFile(folder)
            globalElement.addSearchPath(path)
            refreshAll()
        }
    }
}
