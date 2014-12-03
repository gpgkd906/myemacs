/**
 * @singleton
 * @aside guide %s
 * @author Copyright (c) %s %s. All rights reserved
 *
 * @description
 *
 * ## Examples
 * ###
 * @example
 */
(function (root, factory) {
    'use strict';
    if (typeof exports === 'object') {
        factory(exports);
    } else if (typeof define === 'function' && define.amd) {
        define(['exports'], factory);
    } else {
        factory(root);
    }
} (this, function (exports) {
    'use strict';
    var defineProperty = Object.defineProperty;
    //ie7,ie8 start
    if(!Function.prototype.bind) {
	Function.prototype.bind = function (scope) {
	    var func = this;
	    return function () {
		return func.call(scope);
	    }
	}
    }
    if (!Object.create) {
	Object.create = function(prototype, properties){
	    var polyfill = function Polyfill () {};
	    polyfill.prototype = prototype;
	    var object = new polyfill();
	    if(typeof properties === 'object') {
		for(var key in properties) {
		    object[key] = properties[key].value;
		}
	    }
	    return object;
	}
	defineProperty = function (object, propertyName, property) {
	    return object[propertyName] = property.value;
	};
    }
    //ie7, ie8 end
    if(exports.defClass === undefined) {
	exports.defClass = function(className, definition) {
	    //define util
	    var constructor, prototype, extend, include, prototypeObject
	    , properties = {}, propertiesMerger = function(properties, merger) {
		for(var idx in merger) {
		    properties[idx] = {
			value: merger[idx],
			writable: true
		    }
		}
		return properties;
	    }
	    , idx;
	    //constructor
	    if(definition.hasOwnProperty("constructor") && typeof definition.constructor === "function") {
		constructor = definition.constructor;
		delete definition.constructor;
	    }
	    //extend
	    if(definition.hasOwnProperty("extend") && typeof definition.extend === "function") {
		extend = definition.extend;
		prototype = extend.prototype;
		if(constructor === undefined) {
		    constructor = eval("var constructor = function " + className + " () { this.parentCall('constructor', arguments); }; constructor;");
		}
		for(idx in extend) {
		    if(extend.hasOwnProperty(idx)) {
			constructor[idx] = extend[idx];
		    }
		}
		delete definition.extend;
	    } else {
		if(constructor === undefined) {
		    constructor = eval("var constructor = function " + className + " () {}; constructor;");
		}
		prototype = constructor.prototype;
	    }
	    //statics
	    if(definition.hasOwnProperty("statics") && typeof definition.statics === "object") {
		for(idx in definition.statics) {
		    constructor[idx] = definition.statics[idx];
		}
		delete definition.statics;
	    }
	    //instance
	    //mix-in.instance
	    if (typeof definition.include === "object") {
		include = definition.include;
		if(include instanceof Array) {
		    for(idx in include) {
			properties = propertiesMerger(properties, include[idx]);
		    }
		} else {
		    properties = propertiesMerger(properties, include);
		}
		delete definition.include;
	    }
	    //public.instance
	    properties = propertiesMerger(properties, definition);
	    properties.constructor = { value: constructor };
	    properties.parentCall = {
		value: function(method, args) {
		    if(method === "constructor") {
			return prototype.constructor();
		    }
		    if(typeof prototype[method] === "function") {
			return prototype[method].apply(this, args);
		    }
		}
	    }
	    prototypeObject = Object.create(prototype, properties);
	    //for nodejs
	    constructor.prototype = prototypeObject;
	    //for browser
	    defineProperty(constructor, 'prototype', {
		value: prototypeObject,
		writable: false,
		enumerable: false,
		configurable: false
	    });
	    exports[className] = constructor;
	    return constructor;
	}
    }
    
    return exports.defClass("%s", {
	%s,
	
	constructor: function %s () {},
	
	statics : {
	    'new': function () {
		return new this;
	    },
	
	    staticMethod: function () {
		console.log('このようにスタティックメソッドを定義する');
	    }
	},
	
	instanceMethod: function () {
	    console.log('[メソッド名.value]：このようにインスタンスメソッドを定義する');
	},
	
	toString: (function toString () {
	    return '[object %s]';
	}).bind(this)
	
    });
}));