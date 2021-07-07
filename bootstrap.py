import sys
from PySide2.QtCore import Qt, QCoreApplication
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import QQmlApplicationEngine
from main import Main
from os import path

ROOT_DIR = path.dirname(path.abspath(__file__))

if __name__ == "__main__":

    #   Set attributes
    QApplication.setAttribute(Qt.AA_EnableHighDpiScaling)
    QCoreApplication.setAttribute(Qt.AA_UseHighDpiPixmaps)

    #   Define application
    app = QApplication(sys.argv)
    app.setOrganizationName("Yeahlowflicker Production")

    #   Define engine
    from os.path import dirname, abspath
    engine = QQmlApplicationEngine()
    engine.load(f'{ROOT_DIR}/main.qml')

    #   Define Main
    manager = Main(engine)

    #   Exit handler
    sys.exit(app.exec_())
