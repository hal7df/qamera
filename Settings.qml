import QtQuick 2.3

Item {
    property int flashType: 0
        /** 0: Off
          * 1: Auto
          * 2: On
          */

    property int whiteBalance: 0
        /** 0: Auto
          * 1: Cloudy
          * 2: Fluorescent
          * 3: Sunlight
          * 4: Tungsten
          */

    property int timerDuration: 0
        /** The number of seconds for the
          * capture timer to wait for
          */

    property bool redEye: false
        /** Enables the flash red eye reduction mode. **/

    property int cameraMode: 0
        /** 0: Photo capture mode
          * 1: Video recording mode
          */

    property int cameraFace: 0
        /** 0: Back-facing camera
          * 1: Front-facing camera
          */
}

