import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14


//  Warning window
Window {
    id: licenses

    minimumWidth: 600
    minimumHeight: 200
    maximumWidth: 600
    maximumHeight: 200

    visible: true
    title: "Licenses"


    ColumnLayout {
        anchors.fill: parent


        //  Main content label
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Copyright (c) 2006-2008, Mathieu Fenniak Some contributions copyright (c) 2007, Ashish Kulkarni kulkarni.ashish@gmail.com Some contributions copyright (c) 2014, Steve Witham switham_github@mac-guyver.com
            \n
            All rights reserved.
            \n
            Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
            \n
            Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
            Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
            The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.
            THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.";
        }
    }



    //  Set position and hide root window when self is ready
    Component.onCompleted: {
        x = root.x + root.width / 2 - licenses.width / 2;
        y = root.y + root.height / 2 - licenses.height / 2;
        root.hide();
    }


    //  Clear root reference when closing
    onClosing: { root.licenses = null; root.show(); }
}
