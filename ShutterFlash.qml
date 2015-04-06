import QtQuick 2.3

Rectangle {
    id: shutter

    property real maxHeight: parent.height*Math.SQRT2

    width: height
    height: 0
    radius: width/2

    visible: animation.running
    opacity: 1.0
    color: "#ffffff"

    ParallelAnimation {
        id: animation
        alwaysRunToEnd: true
        NumberAnimation { target: shutter; property: "height"; from: 0; to: shutter.maxHeight; duration: 300; easing: Easing.OutCubic }
        NumberAnimation { target: shutter; property: "opacity"; from: 1.0; to: 0; duration: 400; easing: Easing.InQuad  }
    }

    function start() {
        console.log("Shutter flash width:",maxHeight);
        animation.start();
    }
}

