[1mdiff --git a/package.json b/package.json[m
[1mindex 7f0c998..956764d 100644[m
[1m--- a/package.json[m
[1m+++ b/package.json[m
[36m@@ -32,8 +32,7 @@[m
     "is-object": "^1.0.1",[m
     "next-tick": "^0.2.2",[m
     "x-is-array": "0.1.0",[m
[31m-    "x-is-string": "0.1.0",[m
[31m-    "vdom-as-json": "CrazyEggInc/vdom-as-json"[m
[32m+[m[32m    "x-is-string": "0.1.0"[m
   },[m
   "devDependencies": {[m
     "browserify": "^9.0.7",[m
[1mdiff --git a/vdom/create-element.js b/vdom/create-element.js[m
[1mindex 3662036..896a450 100644[m
[1m--- a/vdom/create-element.js[m
[1m+++ b/vdom/create-element.js[m
[36m@@ -6,7 +6,6 @@[m [mvar isVNode = require("../vnode/is-vnode.js")[m
 var isVText = require("../vnode/is-vtext.js")[m
 var isWidget = require("../vnode/is-widget.js")[m
 var handleThunk = require("../vnode/handle-thunk.js")[m
[31m-var hookProperties = require('vdom-as-json/hookProperties')[m
 [m
 module.exports = createElement[m
 [m
[36m@@ -32,10 +31,6 @@[m [mfunction createElement(vnode, opts) {[m
 [m
     var props = vnode.properties[m
 [m
[31m-    if (props) {[m
[31m-      hookProperties(vnode.namespace, props);[m
[31m-    }[m
[31m-[m
     applyProperties(node, props)[m
 [m
     var children = vnode.children[m
