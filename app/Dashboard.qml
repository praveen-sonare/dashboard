/*
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
import QtWebSockets 1.0

ApplicationWindow {
    id: root

    WebSocket {
        property string api_str: "api/canivi"
        property string verb_str: "subscribe"
        property var msgid_enu: { "call":2, "retok":3, "reterr":4, "event":5 }
        property string request_str: ""
        property string status_str: ""

        id: websocket
        url: bindingAddress

        onTextMessageReceived: {
            var message_json = JSON.parse (message);
            /*
            console.log ("Raw response: " + message)
            console.log ("JSON response: " + message_json)
             */

            if (message_json[0] == msgid_enu.event) {
                if (message_json[1] == "canivi/VehicleSpeed")
                    speed.text = message_json[2].data.value
                else
                if (message_json[1] == "canivi/EngineSpeed")
                    tachometer.value = message_json[2].data.value / 7000
                return
            } else
            if (message_json[0] != msgid_enu.retok) {
                console.log ("Return value is not ok !")
                return
            }
             /* refresh happen */
        }
        onStatusChanged: {
            if (websocket.status == WebSocket.Error) {
                status_str = "Error: " + websocket.errorString
            }
            else
            if (websocket.status == WebSocket.Open) {
                status_str = "Socket opened; sending message..."
                if (verb_str == "subscribe") {
                    request_str ='[' + msgid_enu.call + ',"99999","' + api_str +'/'+ verb_str +'",{ \"event\" : \"VehicleSpeed\" } ]';
                    websocket.sendTextMessage (request_str)
                    request_str ='[' + msgid_enu.call + ',"99999","' + api_str +'/'+ verb_str +'",{ \"event\" : \"EngineSpeed\" } ]';
                    websocket.sendTextMessage (request_str)
                }
            } else
            if (websocket.status == WebSocket.Closed) {
                status_str = "Socket closed"
            }
            console.log (status_str)
        }
        active: true
    }

    Label {
        id: speed
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        text: '0'
        font.pixelSize: 256
    }
    Label {
        id: unit
        anchors.left: speed.right
        anchors.baseline: speed.baseline
        text: 'Km/h'
        font.pixelSize: 64
    }
    Label {
        anchors.left: unit.left
        anchors.top: unit.bottom
        text: '100,000.5 km'
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
        title: 'LEFT FRONT TIRE'
        pressure: '23.1 PSI'
    }

    TirePressure {
        anchors.right: car.left
        anchors.rightMargin: -20
        anchors.bottom: car.bottom
        anchors.bottomMargin: 120
        title: 'LEFT REAR TIRE'
        pressure: '31.35 PSI'
    }

    TirePressure {
        mirror: true
        anchors.left: car.right
        anchors.leftMargin: -20
        anchors.top: car.top
        anchors.topMargin: 150
        title: 'RIGHT FRONT TIRE'
        pressure: '24.2 PSI'
    }

    TirePressure {
        mirror: true
        anchors.left: car.right
        anchors.leftMargin: -20
        anchors.bottom : car.bottom
        anchors.bottomMargin: 120
        title: 'RIGHT REAR TIRE'
        pressure: '33.0 PSI'
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
            value: 0
            Label {
                anchors.left: parent.left
                anchors.top: parent.bottom
                anchors.topMargin: 10
                text: '(RPM)'
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
                        text: 'LEVEL:'
                        font.pixelSize: 24
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignLeft
                        text: '9 GALLONS'
                        font.pixelSize: 24
                        color: '#00ADDC'
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 3
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignRight
                        text: 'RANGE:'
                        font.pixelSize: 24
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignLeft
                        text: '229 MI'
                        font.pixelSize: 24
                        color: '#00ADDC'
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 3
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignRight
                        text: 'AVG:'
                        font.pixelSize: 24
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        verticalAlignment: Label.AlignVCenter
                        horizontalAlignment: Label.AlignLeft
                        text: '25.5 MPG'
                        font.pixelSize: 24
                        color: '#00ADDC'
                    }
                }
            }

            Label {
                anchors.left: parent.left
                anchors.top: parent.bottom
                anchors.topMargin: 10
                text: 'FUEL'
                font.pixelSize: 26
            }
        }
    }
}
