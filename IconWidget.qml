import QtQuick 2.3

Rectangle {
    id: iconWidget

    property string iconName
    property alias label: iconLabel.text
    property bool toggle: false
    property bool toggled: false

    signal clicked
    signal pressAndHold

    width: height
    radius: width/2

    color: "#00000000"

    states: State {
        name: "active"
        when: toggled || button.pressed
        PropertyChanges { target: iconWidget; color: "#44000000" }
    }

    onToggleChanged: {
        if (!toggle)
            toggled = false;
    }

    Image {
        id: icon

        anchors {
            centerIn: parent.label == "" ? parent : undefined
            top: parent.label == "" ? undefined : parent.top
            horizontalCenter: parent.label == "" ? undefined : parent.horizontalCenter
            topMargin: parent.label == "" ? 0 : parent.height/5
        }

        width: parent.label == "" ? parent.width/Math.SQRT2 : (3*parent.width)/(Math.SQRT2*4)
        height: width

        fillMode: Image.PreserveAspectFit
        smooth: true

        source: {
            if (height < 24)
                return "qrc:///img/img/ic_"+iconWidget.iconName+"-18dp.png";
            else if (height >= 24 && height < 36)
                return "qrc:///img/img/ic_"+iconWidget.iconName+"-24dp.png";
            else if (height >= 36 && height < 48)
                return "qrc:///img/img/ic_"+iconWidget.iconName+"-36dp.png";
            else if (height >= 48 && height < 72)
                return "qrc:///img/img/ic_"+iconWidget.iconName+"-48dp.png";
            else if (height >= 72 && height < 96)
                return "qrc:///img/img/ic_"+iconWidget.iconName+"-72dp.png";
            else
                return "qrc:///img/img/ic_"+iconWidget.iconName+"-96dp.png";
        }
    }

    Text {
        id: iconLabel

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            bottomMargin: parent.height/5
        }

        visible: text != ""
        width: parent.width

        text: ""
        font.pixelSize: parent.height/4
        wrapMode: Text.WordWrap

        color: "#ffffff"
    }

    MouseArea {
        id: button

        anchors.fill: parent

        Component.onCompleted: {
            clicked.connect(iconWidget.clicked);
            pressAndHold.connect(iconWidget.pressAndHold);
        }

        onClicked: {
            if (toggle)
                toggled = !toggled;
        }
    }
}
