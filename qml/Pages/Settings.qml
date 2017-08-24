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
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0

import Qt.labs.settings 1.0

import "../Components"

Page {
    id: page
    opacity: 0
    visible: opacity > 0
    enabled: opacity > 0
    anchors.verticalCenterOffset: app.height
    Behavior on opacity { NumberAnimation{} }
    Behavior on anchors.verticalCenterOffset { NumberAnimation{} }

    //
    // Properties
    //
    property bool useCross: false
    property bool humanFirst: true
    property bool enableMusic: true
    property bool enableSoundEffects: true

    //
    // Shows the page
    //
    function open() {
        opacity = app.overlayOpacity
        anchors.verticalCenterOffset = 0
    }

    //
    // Hides the page
    //
    function hide() {
        opacity = 0
        anchors.verticalCenterOffset = app.height
    }

    //
    // Updates the board and AI config bases on selected UI options
    //
    function applySettings() {
        Board.boardSize = _boardSize.value + 3

        switch (_aiLevel.value) {
        case 0:
            AiPlayer.randomness = 7
            break
        case 1:
            AiPlayer.randomness = 3
            break
        case 2:
            AiPlayer.randomness = 0
            break
        }
    }

    //
    // Transparent bacground
    //
    background: Item {}

    //
    // Background overlay
    //
    Item {
        width: 2 * app.width
        height: 2 * app.height
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -1/2 * toolbar.height

        Rectangle {
            color: "#000"
            anchors.fill: parent
        }

        MouseArea {
            anchors.fill: parent
        }
    }

    //
    // Load settings on generation
    //
    Component.onCompleted: applySettings()

    //
    // Save settings between app runs
    //
    Settings {
        category: "Settings"
        property alias cross: page.useCross
        property alias music: page.enableMusic
        property alias humanFirst: page.humanFirst
        property alias boardSize: _boardSize.value
        property alias aiDifficulty: _aiLevel.value
        property alias effects: page.enableSoundEffects
        property alias fieldsToAllign: _fieldsToAllign.value
    }

    //
    // Main layout
    //
    ColumnLayout {
        id: layout
        spacing: app.spacing
        anchors.centerIn: parent

        //
        // Title
        //
        Label {
            font.bold: true
            font.pixelSize: 32
            text: qsTr ("Settings")
            font.capitalization: Font.AllUppercase
            horizontalAlignment: Label.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //
        // Spacer
        //
        Item {
            Layout.preferredHeight: app.spacing
        }

        //
        // Sound and music
        //
        RowLayout {
            spacing: app.spacing
            Layout.preferredWidth: app.paneWidth
            anchors.horizontalCenter: parent.horizontalCenter

            ImageButton {
                btSize: 0
                text: qsTr ("Piece")
                onClicked: useCross = !useCross
                source: useCross ? "qrc:/images/settings/cross.svg" :
                                   "qrc:/images/settings/circle.svg"
            }

            ImageButton {
                btSize: 0
                text: qsTr ("First Turn")
                onClicked: humanFirst = !humanFirst
                source: humanFirst ? "qrc:/images/settings/human.svg" :
                                     "qrc:/images/settings/ai.svg"
            }

            ImageButton {
                btSize: 0
                text: qsTr ("Music")
                onClicked: enableMusic = !enableMusic
                Behavior on opacity { NumberAnimation {duration: 150} }
                source: enableMusic ? "qrc:/images/settings/music-on.svg" :
                                      "qrc:/images/settings/music-off.svg"
            }

            ImageButton {
                btSize: 0
                text: qsTr ("Effects")
                onClicked: enableSoundEffects = !enableSoundEffects
                Behavior on opacity { NumberAnimation {duration: 150} }
                source: enableSoundEffects ? "qrc:/images/settings/volume-on.svg" :
                                             "qrc:/images/settings/volume-off.svg"
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.preferredHeight: app.spacing
        }

        //
        // Map size
        //
        Label {
            text: qsTr ("Map Dimension") + ":"
        } TextSpinBox {
            id: _boardSize
            Layout.preferredWidth: app.paneWidth
            anchors.horizontalCenter: parent.horizontalCenter
            model: ["3x3", "4x4", "5x5", "6x6", "7x7", "8x8", "9x9", "10x10"]

            onValueChanged: {
                applySettings()
                if (page.visible)
                    app.playSoundEffect ("click.wav")
            }
        }

        //
        // AI difficulty
        //
        Label {
            text: qsTr ("AI Level") + ":"
        } TextSpinBox {
            id: _aiLevel
            Layout.preferredWidth: app.paneWidth
            anchors.horizontalCenter: parent.horizontalCenter

            model: [
                qsTr ("Easy"),
                qsTr ("Normal"),
                qsTr ("Hard"),
            ]

            onValueChanged: {
                applySettings()
                if (page.visible)
                    app.playSoundEffect ("click.wav")
            }
        }

        //
        // Fields to Allign
        //
        Label {
            text: qsTr ("Pieces to Allign") + ":"
        } SpinBox {
            from: 3
            id: _fieldsToAllign
            to: Board.boardSize
            Layout.preferredWidth: app.paneWidth
            anchors.horizontalCenter: parent.horizontalCenter
            onValueChanged: {
                if (value >= 3)
                    Board.fieldsToAllign = value

                if (page.visible)
                    app.playSoundEffect ("click.wav")
            }
        }

        //
        // Spacer
        //
        Item {
            Layout.preferredHeight: app.spacing
        }

        //
        // Button
        //
        Button {
            flat: true
            Layout.preferredWidth: app.paneWidth
            anchors.horizontalCenter: parent.horizontalCentercd

            RowLayout {
                spacing: app.spacing
                anchors.centerIn: parent

                SvgImage {
                    fillMode: Image.Pad
                    source: "qrc:/images/settings/back.svg"
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    text: qsTr ("Back")
                    font.capitalization: Font.AllUppercase
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            onClicked: {
                page.hide()
                app.playSoundEffect ("click.wav")
            }
        }
    }
}