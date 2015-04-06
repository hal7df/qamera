import QtQuick 2.3
import QtQuick.Window 2.1
import QtMultimedia 5.4

Rectangle {
    width: 400
    height: 800

    color: "#000000"

    Component.onCompleted: {
        camera.start();
    }

    Settings {
        id: settings
        onFlashTypeChanged: camera.getFlash()
        onWhiteBalanceChanged: camera.getWhiteBalance()
    }

    Text {
        anchors.centerIn: parent

        text: "Starting camera..."
        color: "#ffffff"
    }

    Camera {
        id: camera

        captureMode: settings.cameraMode == 0 ? Camera.CaptureStillImage : Camera.CaptureVideo

        position: settings.cameraFace == 0 ? Camera.BackFace : Camera.FrontFace

        exposure {
            exposureCompensation: 0
            exposureMode: Camera.ExposurePortrait
        }

        imageCapture {
            resolution: "4128x2322"
            onImageCaptured: {
                shutter.start();
            }
        }

        videoRecorder {
            resolution: "1920x1080"
            frameRate: 29.97
        }

        Component.onCompleted: {
            getFlash();
            getWhiteBalance();
        }

        function getFlash ()
        {
            switch (settings.flashType)
            {
            case 0:
                flash.mode = Camera.FlashOff;
                break;
            case 1:
                flash.mode = Camera.FlashOn;
                break;
            case 2:
                flash.mode = Camera.FlashAuto;
                break;
            }
        }

        function getWhiteBalance ()
        {
            switch (settings.whiteBalance)
            {
            case 0:
                imageProcessing.whiteBalanceMode = CameraImageProcessing.WhiteBalanceAuto;
                break;
            case 1:
                imageProcessing.whiteBalanceMode = CameraImageProcessing.WhiteBalanceCloudy;
                break;
            case 2:
                imageProcessing.whiteBalanceMode = CameraImageProcessing.WhiteBalanceFluorescent;
                break;
            case 3:
                imageProcessing.whiteBalanceMode = CameraImageProcessing.WhiteBalanceSunlight;
                break;
            case 4:
                imageProcessing.whiteBalanceMode = CameraImageProcessing.WhiteBalanceTungsten;
                break;
            }
        }
    }

    VideoOutput {
        id: viewer

        source: camera
        anchors.fill: parent
        visible: true

        width: parent.width
        height: parent.height
        z: 0

        fillMode: VideoOutput.PreserveAspectCrop

        autoOrientation: true
    }

    MultiPointTouchArea {
        id: zoomArea

        minimumTouchPoints: 2
        maximumTouchPoints: 2
    }

    QuickDrawer {
        id: drawer

        config: settings
    }

    ShutterFlash {
        id: shutter
        z: 1

        anchors { horizontalCenter: cameraAction.horizontalCenter; verticalCenter: cameraAction.verticalCenter }
    }

    FloatingActionButton {
        id: cameraAction

        z: 10
        visible: !drawer.open

        scale: 1-drawer.drawerPosition
        opacity: drawer.drawerPosition < 0.25 ? 1-(4*drawer.drawerPosition) : 0

        iconName: settings.cameraMode == 0 ? "capture" : (camera.videoRecorder.recorderState == CameraRecorder.StoppedState ? "record" : "stop")
        color: settings.cameraMode == 0 ? "#0099CC" : "#CC0000"

        onClicked: {
            if (settings.cameraMode == 0)
                camera.imageCapture.capture();
            else
            {
                if (camera.videoRecorder.recorderState == CameraRecorder.StoppedState)
                    camera.videoRecorder.record();
                else
                    camera.videoRecorder.stop();
            }
        }

        Behavior on rotation {
            RotationAnimation { easing: Easing.InOutQuad }
        }
    }
}
