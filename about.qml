import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14


//  Warning window
Window {
    id: about

    minimumWidth: 600
    minimumHeight: 200
    maximumWidth: 600
    maximumHeight: 200

    visible: true
    title: "About"


    ColumnLayout {
        anchors.fill: parent


        //  Main content label
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "SourcePDF" + "\n" + "Version " + root.app_version + "\n\n" + "Developed and Published by Yeahlowflicker Production. All rights reserved.";
        }
    }



    //  Set position and hide root window when self is ready
    Component.onCompleted: {
        x = root.x + root.width / 2 - about.width / 2;
        y = root.y + root.height / 2 - about.height / 2;
        root.hide();
    }


    //  Clear root reference when closing
    onClosing: { root.about = null; root.show(); }
}
