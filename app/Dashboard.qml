/*
 * Copyright (c) 2018 TOYOTA MOTOR CORPORATION
 * Copyright (C) 2016 The Qt Company Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import Translator 1.0

import QtQuick.Window 2.13

ApplicationWindow {
    id: root

    width: container.width * container.scale
    height: container.height * container.scale

    Translator {
        id: translator
    }

    property double vehicleSpeed: 0
    property double engineSpeed: 0

    Connections {
        target: SignalComposer

        onSignalEvent: {
            if (uid === "event.vehicle.speed") {
                var speed_tmp = parseFloat(value)
                if(units == "km/h") {
                    speed_tmp /= 1.609
                }
                vehicleSpeed = speed_tmp
            }
            else if (uid === "event.engine.speed") {
                engineSpeed = parseFloat(value)
                tachometer.value = engineSpeed / 7000
            }
        }
    }

    Item {
        id: container
        anchors.centerIn: parent
        width: Window.width
        height: Window.height
        //scale: screenInfo.scale_factor()
        scale: 1

    Label {
        id: speed
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        text: vehicleSpeed.toFixed(0)         /* MPH */
        font.pixelSize: 256
    }
    Label {
        id: unit
        anchors.left: speed.right
        anchors.baseline: speed.baseline
        text: 'MPH'
        font.pixelSize: 64
    }
    Label {
        anchors.left: unit.left
        anchors.top: unit.bottom
        text: '10,000.5 miles'
        font.pixelSize: 32
        opacity: 0.5
    }

    Image {
        id: car
        anchors.centerIn: parent
        source: './images/HMI_Dashboard_Car.png'
    }

    TirePressure {
        anchors.right: car.left
        anchors.rightMargin: -20
        anchors.top: car.top
        anchors.topMargin: 150
        title: translator.translate(qsTr('LEFT FRONT TIRE'), translator.language)
        pressure: translator.translate(qsTr('%1 PSI').arg(23.1), translator.language)
    }

    TirePressure {
        anchors.right: car.left
        anchors.rightMargin: -20
        anchors.bottom: car.bottom
        anchors.bottomMargin: 120
        title: translator.translate(qsTr('LEFT REAR TIRE'), translator.language)
        pressure: translator.translate(qsTr('%1 PSI').arg(31.35), translator.language)
    }

    TirePressure {
        mirror: true
        anchors.left: car.right
        anchors.leftMargin: -20
        anchors.top: car.top
        anchors.topMargin: 150
        title: translator.translate(qsTr('RIGHT FRONT TIRE'), translator.language)
        pressure: translator.translate(qsTr('%1 PSI').arg(24.2), translator.language)
    }

    TirePressure {
        mirror: true
        anchors.left: car.right
        anchors.leftMargin: -20
        anchors.bottom : car.bottom
        anchors.bottomMargin: 120
        title: translator.translate(qsTr('RIGHT REAR TIRE'), translator.language)
        pressure: translator.translate(qsTr('%1 PSI').arg(33.0), translator.language)
    }

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 100

        Image {
            id: speedIcon
            source: './images/HMI_Dashboard_Speed_Icon.svg'
        }
        ProgressBar {
            id: tachometer
            Layout.fillWidth: true
            value: engineSpeed / 65535
            Label {
                anchors.left: parent.left
                anchors.top: parent.bottom
                anchors.topMargin: 10
                text: translator.translate(qsTr('(RPM)'), translator.language)
                font.pixelSize: 26
            }
        }
        Item {
            width: 30
            height: 30
        }
        Image {
            id: fuelIcon
            source: './images/HMI_Dashboard_Fuel_Icon.svg'
        }
        ProgressBar {
            Layout.fillWidth: true
            value: 0.66
            Image {
                anchors.left: parent.left
                anchors.leftMargin: -40
                anchors.bottom: parent.top
                source: './images/HMI_Dashboard_Fuel_Details.svg'
                GridLayout {
                    anchors.fill: parent
                    columns: 2
                    rowSpacing: -10
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 3
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignRight
                        text: translator.translate(qsTr('LEVEL:'), translator.language)
                        font.pixelSize: 24
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignLeft
                        text: translator.translate(qsTr('%1 GALLONS').arg(9), translator.language)
                        font.pixelSize: 24
                        color: '#00ADDC'
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 3
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignRight
                        text: translator.translate(qsTr('RANGE:'), translator.language)
                        font.pixelSize: 24
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignLeft
                        text: translator.translate(qsTr('%1 MI').arg(9), translator.language)
                        font.pixelSize: 24
                        color: '#00ADDC'
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 3
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignRight
                        text: translator.translate(qsTr('AVG:'), translator.language)
                        font.pixelSize: 24
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignLeft
                        text: translator.translate(qsTr('%1 MPG').arg(25.5), translator.language)
                        font.pixelSize: 24
                        color: '#00ADDC'
                    }
                }
            }

            Label {
                anchors.left: parent.left
                anchors.top: parent.bottom
                anchors.topMargin: 10
                text: translator.translate(qsTr('FUEL'), translator.language)
                font.pixelSize: 26
            }
        }
    }

    RowLayout {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: ListModel {
                ListElement {
                    code: 'C'
                    language: QT_TR_NOOP('English')
                }
                ListElement {
                    code: 'fr_FR'
                    language: QT_TR_NOOP('Français')
                }
                ListElement {
                    code: 'ja_JP'
                    language: QT_TR_NOOP('日本語')
                }
                ListElement {
                    code: 'zh_CN'
                    language: QT_TR_NOOP('中文简体')
                }
            }

            Button {
                text: qsTr(model.language)
                onClicked: {
                    translator.language = model.code
                    console.log ("Scale = " + screenInfo.scale_factor())
                }
            }
        }
    }
}
}
