# @nodegui/plugin-title-bar

Hide macOS title bar and leave only traffic lights.

<p align="center">
<img src="https://raw.githubusercontent.com/dimitarnestorov/nodegui-plugin-title-bar/master/assets/showcaseDefault.png" width="190" height="179">
<img src="https://raw.githubusercontent.com/dimitarnestorov/nodegui-plugin-title-bar/master/assets/showcaseHidden.png" width="190" height="179">
<img src="https://raw.githubusercontent.com/dimitarnestorov/nodegui-plugin-title-bar/master/assets/showcaseHiddenInset.png" width="190" height="179">
</p>

```javascript
import { QMainWindow } from '@nodegui/nodegui'
import { setTitleBarStyle } from '@nodegui/plugin-title-bar'

const window = new QMainWindow()
window.show()
setTitleBarStyle(window.native, 'hidden') // or hiddenInset
```
