import QtQuick
import QtQuick.Layouts
import QtQuick.Window 2.2

Window {
    id: topLevelWindow
    visibility: Window.FullScreen
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Pixel Orbit")

    FontLoader {
        id: dBold
        source: "qrc:/fonts/Doto-Bold.ttf"
    }

    Rectangle {
        id: gameArea
        anchors.fill: parent
        visible: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#132330" }
            GradientStop { position: 1.0; color: "black" }
        }

        Rectangle {
            id: gameOverOverlay
            anchors.fill: parent
            visible: false
            color: "black"
            opacity: 0.8
            z: 1001

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    id: gameOver
                    text: qsTr("Game Over!\n" + control.showScore())
                    font.family: dBold.font.family
                    font.weight: dBold.font.weight
                    font.styleName: dBold.font.styleName
                    font.pixelSize: 60
                    Layout.alignment: Qt.AlignHCenter
                    color: "white"

                    Connections {
                        target: control
                        function onScoreChanged()
                        {
                            gameOver.text = qsTr("Game Over!\n" + control.showScore());
                        }
                    }
                }

                RowLayout {
                    spacing: 20

                    Rectangle {
                        id: closeBtn
                        width: 250
                        height: 45
                        color: "grey"
                        radius: 20

                        Text {
                            text: qsTr("Close")
                            color: "white"
                            font.family: dBold.font.family
                            font.weight: dBold.font.weight
                            font.styleName: dBold.font.styleName
                            font.pixelSize: 35
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            hoverEnabled: true
                            anchors.fill: parent

                            onEntered: {
                                closeBtn.color = "red"
                            }
                            onExited: {
                                closeBtn.color = "grey"
                            }
                            onClicked: {
                                Qt.quit();
                            }
                        }
                    }

                    Rectangle {
                        id: restartBtn
                        width: 250
                        height: 45
                        color: "grey"
                        radius: 20

                        Text {
                            text: qsTr("Restart")
                            color: "white"
                            font.family: dBold.font.family
                            font.weight: dBold.font.weight
                            font.styleName: dBold.font.styleName
                            font.pixelSize: 35
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            hoverEnabled: true
                            anchors.fill: parent

                            onEntered: {
                                restartBtn.color = "green"
                            }
                            onExited: {
                                restartBtn.color = "grey"
                            }
                            onClicked: {
                                control.restartGame();
                                gameOverOverlay.visible = false;
                            }
                        }
                    }
                }
            }
        }
    }


    Connections {
        target: control
        onGameOver: {
            gameOverOverlay.visible = true;
        }
    }

    Rectangle {
        id: move
        width: 50
        height: 50
        color: "transparent"
        x: control.x
        y: control.y
        focus: true

        Image {
            id: player
            source: "qrc:/player/rocket.png"
            width: 55
            height: 55
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }

        AnimatedImage {
            id: thruster
            source: "qrc:/player/thruster.gif"
            width: 30
            height: 30
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: player.bottom
            playing: true
        }

        Keys.onPressed: (event) => {
                            if (event.key === Qt.Key_Left) {
                                control.moveLeft();
                            }
                            if (event.key === Qt.Key_Right) {
                                control.moveRight();
                            }
                            if (event.key === Qt.Key_Up) {
                                control.applyThrust();
                            }
                            if (event.key === Qt.Key_Space) {
                                control.fireBullet();
                            }

                            thruster.playing = true;
                        }

        Keys.onReleased: (event) => {
                             if (event.key === Qt.Key_Left || event.key === Qt.Key_Right) {
                                 control.stopMovement();
                             }

                             thruster.playing = true;
                         }

        Component.onCompleted: {
            move.forceActiveFocus();
            thruster.playing = true;
        }
    }

    Text {
        id: scoreBoard
        text: "SCORE: " + control.showScore()
        font.family: dBold.font.family
        font.weight: dBold.font.weight
        font.styleName: dBold.font.styleName
        font.pixelSize: 40
        color: "white"
        x: 50
        y: 50

        Connections {
            target: control
            function onScoreChanged()
            {
                scoreBoard.text = "SCORE: " + control.showScore();
            }
        }
    }

    Repeater {
        model: control.bullets
        delegate: Bullet{}
    }

    Repeater {
        model: control.enemies
        delegate: Enemy{}
    }
}
