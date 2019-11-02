import { QMainWindow, QPushButton, FlexLayout, QWidget } from '@nodegui/nodegui'

import { setTitleBarStyle } from '.'

const win = new QMainWindow()
const rootView = new QWidget()

rootView.setObjectName('root')
rootView.setLayout(new FlexLayout())

const buttonDefault = new QPushButton()
buttonDefault.setText('Default')
buttonDefault.addEventListener('clicked', () => {
	setTitleBarStyle(win.native, 'default')
})

const buttonHidden = new QPushButton()
buttonHidden.setText('Hidden')
buttonHidden.addEventListener('clicked', () => {
	setTitleBarStyle(win.native, 'hidden')
})

const buttonHiddenInset = new QPushButton()
buttonHiddenInset.setText('Hidden Inset')
buttonHiddenInset.addEventListener('clicked', () => {
	setTitleBarStyle(win.native, 'hiddenInset')
})

if (rootView.layout) {
	rootView.layout.addWidget(buttonDefault)
	rootView.layout.addWidget(buttonHidden)
	rootView.layout.addWidget(buttonHiddenInset)
}

win.setCentralWidget(rootView)
win.setStyleSheet(`
  #root {
    flex: 1;
    height: '100%';
    align-items: 'center';
    justify-content: 'center';
  }
`)
win.setWindowTitle('NodeGUI Demo')
win.resize(400, 700)
win.show()
setTitleBarStyle(win.native, 'hidden')
;(global as any).win = win // To prevent win from being garbage collected.
