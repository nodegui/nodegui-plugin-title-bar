# @nodegui/plugin-title-bar

[![npm version](https://img.shields.io/npm/v/@nodegui/plugin-title-bar.svg)](https://www.npmjs.com/package/@nodegui/plugin-title-bar)

Plugin for NodeGUI to hide macOS title bar and leave only traffic lights.

<p align="center">
<img src="https://raw.githubusercontent.com/nodegui/nodegui-plugin-title-bar/master/assets/showcaseDefault.png" width="250" height="193">
<img src="https://raw.githubusercontent.com/nodegui/nodegui-plugin-title-bar/master/assets/showcaseHidden.png" width="250" height="193">
<img src="https://raw.githubusercontent.com/nodegui/nodegui-plugin-title-bar/master/assets/showcaseHiddenInset.png" width="250" height="193">
</p>

## Installation

```sh
npm install @nodegui/plugin-title-bar
```

## Usage

```javascript
import { QMainWindow } from '@nodegui/nodegui'
import { setTitleBarStyle } from '@nodegui/plugin-title-bar'

const window = new QMainWindow()
window.show()
setTitleBarStyle(window.native, 'hidden') // or hiddenInset
global.win = window // Prevents window from being garbage collected
```
