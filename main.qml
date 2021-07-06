import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import QtQuick.Pdf 5.15
import QtQuick.Dialogs 1.3

//  Main window
ApplicationWindow {
    property string app_version : "2021.D1.1.0"

    property int scale_percentage : 75
    property string current_file : ""
    property bool selected: false
    property int xPos: 0

    property variant save_dialog
    property variant unsaved_warn
    property variant about

    property bool saved: true
    property string save_path: ""

    id: root
    visible: true
    title: "Source PDF  v" + app_version
    color: "#242424"

    width: 1280
    height: 720
    minimumWidth: 768
    minimumHeight: 432


    menuBar: MenuBar {
        Menu {
            title: "File"
            Action { text: "New"; onTriggered: { new_pdf() } }
            Action { text: "Open"; onTriggered: { pdfDialog.mode = 4; pdfDialog.open() } }
            Action { text: "Save"; enabled: has_pages(); onTriggered: { triggerSaveDialog(true) } }
            Action { text: "Save As"; enabled: has_pages(); onTriggered: { triggerSaveDialog(false) } }
            MenuSeparator { }
            Action { text: "Exit"; onTriggered: { exitApplication() } }
        }
        Menu {
            title: "Page"
            Action { text: "Move Current Up"; enabled: selected; onTriggered: moveCurrentPage(0) }
            Action { text: "Move Current Down"; enabled: selected; onTriggered: moveCurrentPage(1) }
            Action { text: "Remove Current"; enabled: selected; onTriggered: removeCurrentPage() }
        }
        Menu {
            title: "Document"
            Action { text: "Insert Before Current"; enabled: selected; onTriggered: { pdfDialog.mode = 2; pdfDialog.open() } }
            Action { text: "Insert After Current"; enabled: selected; onTriggered: { pdfDialog.mode = 3; pdfDialog.open() } }
            Action { text: "Add Before First Page"; onTriggered: { pdfDialog.mode = 0; pdfDialog.open() } }
            Action { text: "Add After Last Page"; onTriggered: { pdfDialog.mode = 1; pdfDialog.open() } }
        }
        Menu {
            title: "Image"
            Action { text: "Insert Before Current"; enabled: selected; onTriggered: { imageDialog.mode = 2; imageDialog.open() } }
            Action { text: "Insert After Current"; enabled: selected; onTriggered: { imageDialog.mode = 3; imageDialog.open() } }
            Action { text: "Add Before First Page"; onTriggered: { imageDialog.mode = 0; imageDialog.open() } }
            Action { text: "Add After Last Page"; onTriggered: { imageDialog.mode = 1; imageDialog.open() } }
        }
        Menu {
            title: "Help"
            Action { text: "About"; onTriggered: { triggerAbout() } }
            Action { text: "View License"; onTriggered: { manager.open_url('https://yeahlowflicker.com/sourcepdf/licenses') } }
            Action { text: "Terms and Privacy"; onTriggered: { manager.open_url('https://yeahlowflicker.com/terms') } }
            Action { text: "Yeahlowflicker Production"; onTriggered: { manager.open_url('https://yeahlowflicker.com') } }
        }
    }


    header: ToolBar {
        RowLayout {
            Slider {
                id: control
                from: 1
                value: 4
                to: 8
                stepSize: 1.0
                snapMode: Slider.SnapAlways
                onMoved: { scale_percentage = value * 25 }

                background: Rectangle {
                    x: control.leftPadding
                    y: control.topPadding + control.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: control.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#bbb"

                    Rectangle {
                        width: control.visualPosition * parent.width
                        height: parent.height
                        color: "#000"
                        radius: 2
                    }
                }
            }
            Label {
                text: scale_percentage + "%"
            }

            Label {
                Layout.leftMargin: 50
                text: "Selected page: " + (selected ? (listview.currentIndex+1) : "None") + "  (Double click to select/deselect)"
            }
        }
    }


    ScrollView {
        anchors.fill: parent
        ScrollBar.vertical.policy: has_pages() ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.minimumSize: 0.1

        ListView {
            id: listview
            anchors.fill: parent
            contentWidth: parent.width * scale_percentage * .01
            anchors.leftMargin: (parent.width * .5) - (parent.width * scale_percentage * .01) * .5 + (parent.width * scale_percentage*.01 *.5 * xPos * .01)
            orientation: Qt.Vertical
            spacing: 10
            reuseItems: true
            clip: true
            interactive: false

            property bool scroll_horizontal: false

            boundsBehavior: Flickable.StopAtBounds

            delegate:
                Rectangle {
                    width: listview.contentWidth
                    height: children[0].paintedHeight
                    color: "#fff"

                    Image {
                        asynchronous: true
                        antialiasing: true
                        cache: false
                        mipmap: true
                        fillMode: Image.PreserveAspectFit
                        source: modelData
                        sourceSize.width: parent.width

                        Rectangle {
                            anchors.fill: parent
                            color: '#ccc'
                            opacity: (selected && listview.currentIndex == index) ? 0.3 : 0.0
                        }
                    }


                    MouseArea {
                        anchors.fill: parent
                        preventStealing: true
                        onDoubleClicked: {
                            if (listview.currentIndex == index)
                                selected = !selected;
                            else selected = true;
                            listview.currentIndex = index;
                        }
                    }
                }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            property int moveSpeed: 50

            onWheel: {
                //  Horizontal scroll if shift modifiers. Very weird values but works
                if (wheel.modifiers == Qt.ShiftModifier) {
                    if (wheel.angleDelta.y > 0 && xPos < 100)
                        xPos += 10;
                    else if (wheel.angleDelta.y < 0 && xPos > -100)
                        xPos -= 10;
                }
                //  Zoom in or out if control modifiers
                else if (wheel.modifiers == Qt.ControlModifier) {
                    if (wheel.angleDelta.y > 0 && scale_percentage < 200)
                        scale_percentage += 25;
                    else if (wheel.angleDelta.y < 0 && scale_percentage > 25)
                        scale_percentage -= 25;
                    control.value = scale_percentage / 25;
                }
                //  Vertical scroll, otherwise
                else
                    listview.contentY -= wheel.angleDelta.y > 0 ? moveSpeed : -moveSpeed;
                listview.returnToBounds();
            }
        }
    }


    //  PDF Open Dialog
    FileDialog {
        property int mode: 0
        id: pdfDialog
        title: "Please choose a file"
        nameFilters: [ "PDF files (*.pdf)" ]

        onAccepted: {
            current_file = pdfDialog.fileUrl.toString()
            var path = pdfDialog.fileUrl.toString().replace('file://', '');

            var index = listview.currentIndex;
            if (pdfDialog.mode == 4)
                listview.model = manager.open_file(path, pdfDialog.mode, index);
            else
                listview.model = manager.add_page(path, pdfDialog.mode, index);

            switch (pdfDialog.mode) {
                case 0: index = 0; break;
                case 1: index = listview.model.length; break;
                case 2: index = index; break;
                case 3: index = index + 1; break;
                case 4: index = 0; break;
            }
            listview.positionViewAtIndex(index, ListView.Center);
            selected = false;
            if (pdfDialog.mode != 4)
                saved = false;
            this.close();
        }

        onRejected: this.close();
    }


    //  Image Open Dialog
    FileDialog {
        property int mode: 0
        id: imageDialog
        title: "Please choose an image file"
        nameFilters: [ "Image files (*.jpg *.jepg *.png)" ]

        onAccepted: {
            current_file = imageDialog.fileUrl.toString()
            var path = imageDialog.fileUrl.toString().replace('file://', '');

            var index = listview.currentIndex;
            listview.model = manager.add_image(path, imageDialog.mode, index);
            switch (imageDialog.mode) {
                case 0: index = 0; break;
                case 1: index = listview.model.length; break;
                case 2: index = index; break;
                case 3: index = index + 1; break;
            }
            listview.positionViewAtIndex(index, ListView.Center);
            selected = false;
            saved = false;
            this.close();
        }

        onRejected: this.close();
    }


    function add_page(mode, index) {
        pdfDialog.open()
    }


    function add_image(mode, index) {
        imageDialog.open()
    }


    function moveCurrentPage(mode) {
        var index = listview.currentIndex;
        listview.model = manager.move_page(mode, index);
        if (mode == 0) index--;
        else if (mode == 1) index++;
        listview.positionViewAtIndex(index, ListView.Center);
        selected = false;
        saved = false;
    }


    function removeCurrentPage() {
        var index = listview.currentIndex;
        listview.model = manager.remove_page(index);
        listview.currentIndex = index;
        listview.positionViewAtIndex(index, ListView.Center);
        selected = false;
        saved = false;
    }


    function exitApplication() {
        Qt.quit();
    }


    function new_pdf() {
        if (!saved) {
            return;
        }
        manager.clear_temp();
        listview.model = [];
        selected = false;
        saved = true;
    }


    function handler_save_pdf(path, compression) {
        manager.save_pdf(path, compression);
        root.save_path = path;
        root.saved = true;
    }


    function triggerSaveDialog(allow_skip_dialog) {
        if (root.save_path != "" && allow_skip_dialog) {
            handler_save_pdf(root.save_path);
            return;
        }
        var component = Qt.createComponent("./save_dialog.qml");
        save_dialog = component.createObject(root);
        save_dialog.show();
        save_dialog.raise();
    }


    //  Trigger unsaved warning
    function triggerUnsavedWarning() {
        if (unsaved_warn == null) {
            var component = Qt.createComponent("./unsaved_warning.qml");
            unsaved_warn = component.createObject(root);
            unsaved_warn.show();
            unsaved_warn.raise();
        }
    }


    function triggerAbout() {
        if (about == null) {
            var component = Qt.createComponent("./about.qml");
            about = component.createObject(root);
            about.show();
            about.raise();
        }
    }


    function has_pages() {
        return listview.count > 0;
    }

    onClosing: {
        if (!saved) {
            close.accepted = false;
            triggerUnsavedWarning();
            return
        }
        manager.clear_temp();
    }
}
