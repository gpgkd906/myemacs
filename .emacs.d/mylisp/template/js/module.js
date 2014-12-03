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
    if(window.defClass === undefined) {
	window.defClass = function(className, config) {
	    //define util
	    var constructor, prototype, extend, include
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
	    if(config.hasOwnProperty("constructor") && typeof config.constructor === "function") {
		constructor = config.constructor;
		delete config.constructor;
	    }
	    //extend
	    if(config.hasOwnProperty("extend") && typeof config.extend === "function") {
		extend = config.extend;
		prototype = extend.prototype;
		if(constructor === undefined) {
		    constructor = eval("var constructor = function " + className + " () { this.parentCall('constructor', arguments); }; constructor;");
		}
		for(idx in extend) {
		    if(extend.hasOwnProperty(idx)) {
			constructor[idx] = extend[idx];
		    }
		}
		delete config.extend;
	    } else {
		if(constructor === undefined) {
		    constructor = eval("var constructor = function " + className + " () {}; constructor;");
		}
		prototype = constructor.prototype;
	    }
	    //statics
	    if(config.hasOwnProperty("statics") && typeof config.statics === "object") {
		for(idx in config.statics) {
		    constructor[idx] = config.statics[idx];
		}
		delete config.statics;
	    }
	    //instance
	    //mix-in.instance
	    if (typeof config.include === "object") {
		include = config.include;
		if(include instanceof Array) {
		    for(idx in include) {
			properties = propertiesMerger(properties, include[idx]);
		    }
		} else {
		    properties = propertiesMerger(properties, include);
		}
		delete config.include;
	    }
	    //public.instance
	    properties = propertiesMerger(properties, config);
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
	    defineProperty(constructor, 'prototype', {
		value: Object.create(prototype, properties),
		writable: false,
		enumerable: false,
		configurable: false
	    });
	    exports[className] = constructor;
	    return constructor;
	}
    }
    
    return defClass("%s", {
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