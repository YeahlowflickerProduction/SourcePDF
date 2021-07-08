# -*- mode: python ; coding: utf-8 -*-


block_cipher = None


a = Analysis(['bootstrap.py'],
             pathex=['C:\\Users\\YF\\Desktop\\New folder\\SourcePDF'],
             binaries=None,
             datas=[
		('C:\\Users\\YF\\Desktop\\SourcePDF\\SourcePDF\\*.py', '.'),
		('C:\\Users\\YF\\Desktop\\SourcePDF\\SourcePDF\\*.qml', '.'),
		('C:\\Users\\YF\\Desktop\\SourcePDF\\SourcePDF\\sourcepdf_icon.ico', '.'),
	     ],
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
	  a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          [],
          name='SourcePDF',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          upx_exclude=[],
          runtime_tmpdir=None,
	  icon='C:\\Users\\YF\\Desktop\\SourcePDF\\SourcePDF\\sourcepdf_icon.ico',
          console=False )
