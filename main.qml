import QtQuick 2.2
import QtQuick.Window 2.1
import QtMultimedia 5.4

Rectangle {
    width: 400
    height: 800

    state: "PhotoCapture"

    color: "#000000"

    Text {
        anchors.centerIn: parent

        text: "Starting camera..."
        color: "#ffffff"
    }

    states: [
        State {
            name: "PhotoCapture"
            StateChangeScript {
                script: {
                    camera.captureMode = Camera.CaptureStillImage
                    camera.start()
                }
            }
        },
        State {
            name: "VideoCapture"
            StateChangeScript {
                script: {
                    camera.captureMode = Camera.CaptureVideo
                    camera.start()
                }
            }
        }
    ]

    Camera {
        id: camera

        captureMode: Camera.CaptureStillImage

        position: Camera.BackFace

        imageProcessing {
            whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
        }

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

    ShutterFlash {
        id: shutter
        z: 1

        anchors { horizontalCenter: cameraAction.horizontalCenter; verticalCenter: cameraAction.verticalCenter }
    }

    FloatingActionButton {
        id: cameraAction

        z: 10

        iconName: "capture"
        color: "#0099CC"

        onClicked: {
            camera.imageCapture.capture();
        }
    }
}
