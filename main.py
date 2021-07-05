from PySide2.QtCore import QObject, Slot
from PyPDF4 import PdfFileReader, PdfFileWriter
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import inch
from reportlab.pdfgen import canvas
from os import path, makedirs

ROOT_DIR = path.dirname(path.abspath(__file__))

class Main(QObject):

    engine = None

    pages = []
    selected_pages = []
    doc_count = 0
    img_count = 0

    #   Initialization
    def __init__(self, engine):
        super().__init__()
        self.engine = engine
        engine.rootContext().setContextProperty("manager", self)


    @Slot(str, result=list)
    def open_file(self, path):
        temp = f'{ROOT_DIR}/temp'

        self.clear_temp()

        pdf = PdfFileReader(path)

        for p in range(pdf.numPages):
            pdf = PdfFileReader(path)   # This line is redundant, but prevents stream error
            pdf_writer = PdfFileWriter()
            pdf_writer.addPage(pdf.getPage(p))
            _path = rf'{temp}/{self.doc_count}_page{p}.pdf'
            with open(_path, 'wb') as stream:
                pdf_writer.write(stream)
            self.pages.append(f'file://{_path}')
        self.doc_count = 1

        return self.pages



    @Slot(str)
    def save_pdf(self, path):
        pdf_writer = PdfFileWriter()

        for p in self.pages:
            pdf = PdfFileReader(p.replace('file://', ''))
            pdf_writer.addPage(pdf.getPage(0))

        with open(path, 'wb') as stream:
            pdf_writer.write(stream)


    @Slot(result=int)
    def clear_temp(self):
        temp = f'{ROOT_DIR}/temp'
        if path.exists(temp):
            import shutil
            shutil.rmtree(temp)
        if not path.exists(temp):
            makedirs(temp)
        self.pages = []
        self.doc_count = 0
        self.img_count = 0
        return 0


    @Slot(str, int, int, result=list)
    def add_page(self, path, mode, index):
        temp = f'{ROOT_DIR}/temp'

        if not path.exists(temp):
            makedirs(temp)

        pdf = PdfFileReader(path)

        collection = []

        for p in range(pdf.numPages):
            pdf = PdfFileReader(path)   # This line is redundant, but prevents stream error
            pdf_writer = PdfFileWriter()
            pdf_writer.addPage(pdf.getPage(p))
            _path = rf'{temp}/{self.doc_count}_page{p}.pdf'
            with open(_path, 'wb') as stream:
                pdf_writer.write(stream)
            collection.append(f'file://{_path}')

        if mode == 0:
            self.pages = collection + self.pages
        elif mode == 1:
            self.pages += collection
        elif mode == 2:
            prefix = self.pages[:index]
            suffix = self.pages[index:]
            self.pages = prefix + collection + suffix
        elif mode == 3:
            prefix = self.pages[:index+1]
            suffix = self.pages[index+1:]
            self.pages = prefix + collection + suffix

        self.doc_count += 1
        return self.pages


    @Slot(str, int, int, result=list)
    def add_image(self, filepath, mode, index):
        temp = rf'{ROOT_DIR}/temp'

        if not path.exists(temp):
            makedirs(temp)

        _path = rf'{temp}/img_{self.img_count}.pdf'
        cv = canvas.Canvas(_path, pagesize=A4)
        cv.drawInlineImage(filepath, inch*.25, inch*2, width=595-(.5*inch), height=595-(.316*inch), preserveAspectRatio=True, anchor='c')
        cv.save()

        img_path = f'file://{_path}'
        if mode == 0:
            self.pages.insert(0, img_path)
        elif mode == 1:
            self.pages.append(img_path)
        elif mode == 2:
            self.pages.insert(index, img_path)
        elif mode == 3:
            self.pages.insert(index+1, img_path)

        self.img_count += 1
        return self.pages


    @Slot(int, result=list)
    def remove_page(self, index):
        del self.pages[index]
        return self.pages


    @Slot(int, int, result=list)
    def move_page(self, mode, index):
        if mode == 0:
            self.pages[index-1], self.pages[index] = self.pages[index], self.pages[index-1]
        elif mode == 1:
            self.pages[index+1], self.pages[index] = self.pages[index], self.pages[index+1]
        return self.pages


    @Slot(str)
    def open_url(self, url):
        import webbrowser
        webbrowser.open(url)
