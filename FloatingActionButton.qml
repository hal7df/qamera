import QtQuick 2.3
import QtGraphicalEffects 1.0

Item {
    id: fabContain

    property alias color: fab.color
    property string iconName: "capture"
    property real  circleWidth: (43/270)*parent.width
    property string location: "center"

    anchors { margins: 0.5*width; bottom: parent.bottom }

    anchors.right: location == "right" ? parent.right : undefined
    anchors.horizontalCenter: location == "center" ? parent.horizontalCenter : undefined
    anchors.left: location == "left" ? parent.left : undefined

    width: circleWidth
    height: width

    signal clicked
    signal pressAndHold

    Rectangle {
        id: fab

        anchors.fill: parent

        radius: 0.5*width

        Image {
            id: icon

            anchors.centerIn: parent
            width: parent.width/Math.SQRT2
            height: width

            source: getIconResolution (fabContain.iconName)
            fillMode: Image.PreserveAspectFit
            smooth: true

            function getIconResolution (name) {
                if (height < 24)
                    return "img/ic_"+name+"-18dp.png";
                else if (height >= 24 && height < 36)
                    return "img/ic_"+name+"-24dp.png";
                else if (height >= 36 && height < 48)
                    return "img/ic_"+name+"-36dp.png";
                else if (height >= 48 && height < 72)
                    return "img/ic_"+name+"-48dp.png";
                else if (height >= 72 && height < 96)
                    return "img/ic_"+name+"-72dp.png";
                else
                    return "img/ic_"+name+"-96dp.png";
            }
        }

        Rectangle {
            id: ripple

            visible: rippleAnimation.running
            anchors.fill: parent

            width: 0
            height: width
            radius: width/2
            color: "#000000"

            opacity: 0.25

            ParallelAnimation {
                id: rippleAnimation
                alwaysRunToEnd: true
                NumberAnimation { id: widthAnimation; target: ripple; property: "width"; from: 0; to: fab.width; duration: 250 }
                NumberAnimation { id: xAnimation; target: ripple; property: "x"; to: 0; duration: 250 }
                NumberAnimation { id: yAnimation; target: ripple; property: "y"; to: 0; duration: 250 }
                NumberAnimation { id: opacityAnimation; target: ripple; property: "opacity"; from: 0.25; to: 0; duration: 250 }
            }
        }

        MouseArea {
            id: button

            anchors.fill: parent

            Component.onCompleted: {
                clicked.connect(fabContain.clicked);
                pressAndHold.connect(fabContain.pressAndHold);
            }

            onPressAndHold: {
                ripple.x = mouse.x-(Math.SQRT2*fab.width);
                ripple.y = mouse.y-(Math.SQRT2*fab.width);

                mouse.accepted = true;

                widthAnimation.duration = 1000;
                xAnimation.duration = 1000;
                yAnimation.duration = 1000;
                opacityAnimation.duration = 1000;

                rippleAnimation.start();
            }

            onClicked: {
                ripple.x = mouse.x-(Math.SQRT2*fab.width);
                ripple.y = mouse.y-(Math.SQRT2*fab.width);

                mouse.accepted = true;

                widthAnimation.duration = 250;
                xAnimation.duration = 250;
                yAnimation.duration = 250;
                opacityAnimation.duration = 250;

                rippleAnimation.start();
            }
        }
    }

    DropShadow {
        id: shadow

        anchors.fill: fab
        source: fab

        color: "#33000000"
        scale: 1.15
        samples:  10
        radius: 8
        verticalOffset: fab.height/20
        z: -1
    }
}
