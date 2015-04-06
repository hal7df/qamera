import QtQuick 2.3

Item {
    id: drawer

    readonly property bool open: y == 0

    property real lastY: height-quickSettingsHeight
    property real quickSettingsHeight: 0.1*parent.height

    property real opacityCalc: 0.6*Math.sqrt(drawerPosition)
    property real drawerPosition: 1-(y/(height-quickSettingsHeight))

    property int orientation: 0
    property Settings config

    anchors {
        left: parent.left
        right: parent.right
    }

    height: parent.height
    y: 0.9*parent.height

    Drag.active: dragArea.drag.active || dragArea2.drag.active
    Drag.onDragFinished: {
            if (drawerPosition > 0.5)
                openDrawer();
            else
                closeDrawer();

            console.log("Drag finished");
    }

    Behavior on y {
        PropertyAnimation { easing: Easing.OutQuad }
    }

    Rectangle {
        id: background

        anchors.fill: parent

        color: "#000000"
        opacity: parent.opacityCalc
    }

    MouseArea {
        id: dragArea

        anchors.fill: parent

        drag {
            axis: Drag.YAxis
            target: parent
            minimumY: 0
            maximumY: parent.height - parent.quickSettingsHeight
            filterChildren: true
        }

        MouseArea {
            id: dragArea2

            anchors.fill: parent

            drag {
                axis: Drag.YAxis
                target: drawer
                minimumY: 0
                maximumY: drawer.height - drawer.quickSettingsHeight
            }
        }

        Item {
            id: quickSettingsBack

            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
            }

            height: drawer.quickSettingsHeight

            IconWidget {
                id: flash

                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }

                scale: 0.75

                iconName: getFlashName(drawer.config.flashType)

                onClicked: {
                    if (drawer.config.flashType < 2)
                        drawer.config.flashType++;
                    else
                        drawer.config.flashType = 0;
                }

                function getFlashName (index)
                {
                    if (index == 0)
                        return "flash-off";
                    else if (index == 1)
                        return "flash";
                    else if (index == 2)
                        return "flash-auto"
                }
            }

            IconWidget {
                id: whiteBalance

                anchors {
                    left: flash.right
                    top: parent.top
                    bottom: parent.bottom
                }

                scale: 0.75

                iconName: getWhiteBalance(drawer.config.whiteBalance)

                onClicked: {
                    if (drawer.config.whiteBalance < 4)
                        drawer.config.whiteBalance++;
                    else
                        drawer.config.whiteBalance = 0;
                }

                function getWhiteBalance (index)
                {
                    switch (index)
                    {
                    case 0:
                        return "wb-auto";
                        break;
                    case 1:
                        return "wb-cloudy";
                        break;
                    case 2:
                        return "wb-fluorescent"
                        break;
                    case 3:
                        return "wb-sunlight";
                        break;
                    case 4:
                        return "wb-tungsten";
                        break;
                    }
                }
            }

            IconWidget {
                id: switchMode

                anchors {
                    right: switchCam.left
                    top: parent.top
                    bottom: parent.bottom
                }

                scale: 0.75

                iconName: drawer.config.cameraMode == 0 ? "switch-video" : "switch-camera"

                onClicked: {
                    if (drawer.config.cameraMode == 0)
                        drawer.config.cameraMode = 1;
                    else
                        drawer.config.cameraMode = 0;
                }
            }

            IconWidget {
                id: switchCam

                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

                scale: 0.75

                iconName: drawer.config.cameraFace == 0 ? "camera-front" : "camera-rear"

                onClicked: {
                    if (drawer.config.cameraFace == 0)
                        drawer.config.cameraFace = 1;
                    else
                        drawer.config.cameraFace = 0;
                }
            }
        }

        Item {
            id: drawerContents

            anchors {
                top: quickSettingsBack.bottom
                right: parent.right
                left: parent.left
                bottom: parent.bottom
            }
        }
    }

    function openDrawer()
    {
        y = 0;
        lastY = y;
    }

    function closeDrawer()
    {
        y = height - quickSettingsHeight;
        lastY = y;
    }

    function returnToNearest()
    {
        if (drawerPosition < 0.5)
            closeDrawer();
        else
            openDrawer()
    }
}

