import { QMainWindow } from '@nodegui/nodegui'

const { setTitleBarStyle } = require('../build/Release/nodegui_plugin_title_bar.node') as {
	setTitleBarStyle(window: QMainWindow['native'], style: 'hidden' | 'hiddenInset' | 'default'): void
}

export { setTitleBarStyle }
