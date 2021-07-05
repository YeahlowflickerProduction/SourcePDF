import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtQuick.Pdf 5.15
import QtQuick.Dialogs 1.3

//  Main window
ApplicationWindow {
    property int scale_percentage : 50
    property string current_file : ""

    id: root
    visible: true
    title: current_file == "" ? "SourcePDF" : "SourcePDF " + current_file
    color: "#242424"

    width: 1280
    height: 720
    minimumWidth: 768
    minimumHeight: 432


    menuBar: MenuBar {
        Menu {
            title: "File"
            Action { text: "New" }
            Action { text: "Open"; onTriggered: fileDialog.open() }
            Action { text: "Save"; onTriggered: saveDialog.open() }
            Action { text: "Save As" }
            MenuSeparator { }
            Action { text: "Exit" }
        }
        Menu {
            title: "Edit"
            Action { text: "Add Page Before" }
            Action { text: "Add Page After" }
            Action { text: "Remove Current Page" }
            MenuSeparator { }
            Action { text: "Cut" }
            Action { text: "Copy" }
            Action { text: "Paste" }
        }
        Menu {
            title: "Help"
            Action { text: "About" }
        }
    }


    ScrollView {
        id: viewArea
        anchors.fill: parent
        background: Rectangle { color: "#333" }
        spacing: 50

        Repeater {
            id: images
            model: []

            Rectangle {
                width: children[0].paintedWidth
                height: children[0].paintedHeight
                color: "#fff"

                Image {
                    asynchronous: true
                    antialiasing: true
                    cache: false
                    mipmap: true
                    fillMode: Image.PreserveAspectFit
                    source: images.model[index]
                    sourceSize.width: root.width * scale_percentage * .01
                }
            }
        }
    }


    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        nameFilters: [ "PDF files (*.pdf)" ]

        onAccepted: {
            current_file = fileDialog.fileUrl.toString()
            var path = fileDialog.fileUrl.toString().replace('file://', '');
            images.model = manager.generate_pages(path);
            this.close();
        }

        onRejected: this.close();
    }


    FileDialog {
        id: saveDialog
        title: "Choose save location"
        nameFilters: [ "PDF files (*.pdf)" ]
        selectExisting: false

        onAccepted: {
            var path = saveDialog.fileUrl.toString().replace('file://', '');
            manager.save_pdf(path);
            this.close();
        }

        onRejected: this.close();
    }
}
