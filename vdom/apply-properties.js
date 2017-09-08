var isObject = require('is-object');
var isHook = require('../vnode/is-vhook');
var isSoftSetHook = require('./is-soft-set-hook');
var undefinedValue = require('./undefined-value');

module.exports = applyProperties;

function applyProperties(node, props, previous) {
  for (var propName in props) {
    var propValue = props[propName];

    if (undefinedValue.isUndefined(propValue)) {
      removeProperty(node, propName, propValue, previous);

    } else if (isHook(propValue)) {
      removeProperty(node, propName, propValue, previous);

      if (propValue.hook) {
        propValue.hook(node,
          propName,
          previous ? previous[propName] : undefined);
      }

    } else if (isSoftSetHook(propValue)) {
      removeProperty(node, propName, propValue, previous);
      setProperty(node, propName, propValue);

    } else {
      if (isObject(propValue)) {
        patchObject(node, previous, propName, propValue);
      } else {
        setProperty(node, propName, propValue);
      }
    }
  }
}

function removeProperty(node, propName, propValue, previous) {
  if (!previous) {
    return;
  }

  var previousValue = previous[propName];

  if (!isHook(previousValue)) {
    if (propName === "attributes") {
      for (var attrName in previousValue) {
        node.removeAttribute(attrName);
      }
    } else if (propName === "style") {
      for (var i in previousValue) {
        node.style[i] = "";
      }
    } else if (typeof previousValue === "string") {
      setProperty(node, propName, "");
    } else {
      setProperty(node, propName, null);
    }

  } else if (previousValue.unhook) {
    previousValue.unhook(node, propName, propValue);
  }
}

function setProperty(node, propName, value) {
  // this is a workaround in case of invalid value or readonly propName
  try {
    node[propName] = value;
  } catch(err) {}
}

function patchObject(node, previous, propName, propValue) {
  var previousValue = previous ? previous[propName] : undefined

  // Set attributes
  if (propName === "attributes") {
    for (var attrName in propValue) {
      var attrValue = propValue[attrName];

      if (attrValue === undefined) {
        node.removeAttribute(attrName);
      } else {
        node.setAttribute(attrName, attrValue);
      }
    }

    return;
  }

  if (previousValue && isObject(previousValue) &&
    getPrototype(previousValue) !== getPrototype(propValue)) {
    node[propName] = propValue;
    return;
  }

  if (!isObject(node[propName])) {
    node[propName] = {}
  }

  var replacer = propName === "style" ? "" : undefined;

  for (var k in propValue) {
    var value = propValue[k];
    node[propName][k] = undefinedValue.isUndefined(value) ? replacer : value;
  }
}

function getPrototype(value) {
  // getPrototypeOf shim for older browsers
  /* istanbul ignore else */
  if (Object.getPrototypeOf) {
    return Object.getPrototypeOf(value)
  } else {
    return value.__proto__ || value.constructor.prototype;
  }
}
