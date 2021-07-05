import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14


//  Warning window
Window {
    id: unsaved_warning

    minimumWidth: 300
    minimumHeight: 100
    maximumWidth: 300
    maximumHeight: 100

    visible: true
    title: "Warning"


    ColumnLayout {
        anchors.fill: parent


        //  Main content label
        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 15

            text: "File is not saved. Are you sure to quit?";
        }


        RowLayout {
            Layout.margins: 5

            Item { Layout.fillWidth: true; }



            //  Save button
            Button {
                implicitWidth: 75
                implicitHeight: 25

                contentItem: Text {
                    text: "Save";
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle { color: "#000" }

                onClicked: {
                    unsaved_warn.close();
                    root.save_pdf();
                }
            }





            //  Quit button
            Button {
                implicitWidth: 100
                implicitHeight: 25

                contentItem: Text {
                    text: "Don't Save";
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle { color: root.isDarkTheme ? "#303030" : "#EAEAEA" }

                //  Force quit
                onClicked: Qt.quit()
            }




            //  Cancel button
            Button {
                implicitWidth: 75
                implicitHeight: 25

                contentItem: Text {
                    text: "Cancel";
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: unsaved_warn.close();
            }

            Item { Layout.fillWidth: true; }
        }
    }



    //  Set position and hide root window when self is ready
    Component.onCompleted: {
        x = root.x + root.width / 2 - unsaved_warning.width / 2;
        y = root.y + root.height / 2 - unsaved_warning.height / 2;
        root.hide();
    }


    //  Clear root reference when closing
    onClosing: { root.unsaved_warn = null; root.show(); }
}
