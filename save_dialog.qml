import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14
import QtQuick.Dialogs 1.3


//  Warning window
Window {
    id: save_dialog

    property string path: ""
    property int compression: 0

    minimumWidth: 600
    minimumHeight: 300
    maximumWidth: 600
    maximumHeight: 300

    visible: true
    title: "Save PDF"


    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        Label {
            text: "Save path"
        }
        RowLayout {
            width: parent.width

            Button {
                text: "Browse"
                onClicked: { save_file_dialog.open() }
            }
            Label {
                Layout.leftMargin: 15
                text: save_dialog.path.length > 0 ? save_dialog.path : "(Not Set)"
            }
        }


        Label {
            Layout.topMargin: 20
            text: "Compression level. (Higher = Greater Compression)"
        }
        RowLayout {
            Slider {
                id: slider_compression
                from: 0
                value: 1
                to: 4
                stepSize: 1.0
                snapMode: Slider.SnapAlways
                onValueChanged: { compression = this.value }
            }
            Label {
                Layout.leftMargin: 25
                text: slider_compression.value
            }
        }

        RowLayout {
            Layout.topMargin: 20
            Button {
                enabled: save_dialog.path.length > 0
                text: "Save"
                onClicked: { root.handler_save_pdf(save_dialog.path, save_dialog.compression); save_dialog.close() }
            }
            Button {
                text: "Cancel"
                onClicked: { save_dialog.close() }
            }
        }
    }


    //  PDF Save Dialog
    FileDialog {
        id: save_file_dialog
        title: "Choose save location"
        nameFilters: [ "PDF files (*.pdf)" ]
        selectExisting: false

        onAccepted: {
            save_dialog.path = `${save_file_dialog.fileUrl}.pdf`.replace('file://', '');
            this.close();
        }

        onRejected: this.close();
    }






    //  Set position and hide root window when self is ready
    Component.onCompleted: {
        x = root.x + root.width / 2 - save_dialog.width / 2;
        y = root.y + root.height / 2 - save_dialog.height / 2;
        root.hide();
    }


    //  Clear root reference when closing
    onClosing: { root.save_dialog = null; root.show(); }
}
