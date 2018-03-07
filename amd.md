
##前端模块规范有三种：CommonJs,AMD和CMD
CommonJs用在服务器端，AMD和CMD用在浏览器环境

AMD 是 RequireJS 在推广过程中对模块定义的规范化产出。

CMD 是 SeaJS 在推广过程中对模块定义的规范化产出。

AMD:提前执行（异步加载：依赖先执行）+延迟执行

CMD:延迟执行（运行到需加载，根据顺序执行）

作者：frontend-wsc


##CommonJS规范

* CommonJS是服务器端模块的规范，由Node推广使用。由于服务端编程的复杂性，如果没有模块很难与操作系统及其他应用程序互动。使用方法如下：
```javascript
  math.js
  exports.add = function() {
      var sum = 0, i = 0, args = arguments, l = args.length;
      while (i < l) {
        sum += args[i++];
      }
      return sum;
  };

  increment.js
  var add = require('math').add;
  exports.increment = function(val) {
      return add(val, 1);
  };

  index.js
  var increment = require('increment').increment;
  var a = increment(1); //2
```
* 根据CommonJS规范:
  * 一个单独的文件就是一个模块。每一个模块都是一个单独的作用域，也就是说，在该模块内部定义的变量，无法被其他模块读取，	 除非定义为global对象的属性。
  * 输出模块变量的最好方法是使用module.exports对象。
  * 加载模块使用require方法，该方法读取一个文件并执行，返回文件内部的module.exports对象
  仔细看上面的代码，您会注意到 require 是同步的。模块系统需要同步读取模块文件内容，并编译执行以得到模块接口。
  然而， 这在浏览器端问题多多。

  浏览器端，加载 JavaScript 最佳、最容易的方式是在 document 中插入<script>标签。但脚本标签天生异步，传统 	  	CommonJS 模块在浏览器环境中无法正常加载。

  解决思路之一是，开发一个服务器端组件，对模块代码作静态分析，将模块与它的依赖列表一起返回给浏览器端。 这很好使，但需要服务器安装额外的组件，并因此要调整一系列底层架构。

  另一种解决思路是，用一套标准模板来封装模块定义：

```javascript
	define(function(require, exports, module) {

       // The module code goes here

    });
	
```
这套模板代码为模块加载器提供了机会，使其能在模块代码执行之前，对模块代码进行静态分析，并动态生成依赖列表。
```javascript
	math.js
define(function(require, exports, module) {
  exports.add = function() {
    var sum = 0, i = 0, args = arguments, l = args.length;
    while (i < l) {
      sum += args[i++];
    }
    return sum;
  };
});

increment.js
define(function(require, exports, module) {
  var add = require('math').add;
  exports.increment = function(val) {
    return add(val, 1);
  };
});

index.js
define(function(require, exports, module) {
  var inc = require('increment').increment;
  inc(1); // 2
});


```

##AMD规范
* AMD是"Asynchronous Module Definition"的缩写，意思就是"异步模块定义"。由于不是JavaScript原生支持，使用AMD规范进行页面开发需要用到对应的库函数，也就是大名鼎鼎RequireJS，实际上AMD 是 RequireJS 在推广过程中对模块定义的规范化的产出
* 它采用异步方式加载模块，模块的加载不影响它后面语句的运行。所有依赖这个模块的语句，都定义在一个回调函数中，等到加载完成之后，这个回调函数才会运行。
* RequireJS主要解决两个问题
	* 多个js文件可能有依赖关系，被依赖的文件需要早于依赖它的文件加载到浏览器
    * js加载的时候浏览器会停止页面渲染，加载文件越多，页面失去响应时间越长
* RequireJs也采用require()语句加载模块，但是不同于CommonJS，它要求两个参数:
	* 第一个参数[module]，是一个数组，里面的成员就是要加载的模块；
    * 第二个参数callback，则是加载成功之后的回调函数。math.add()与math模块加载不是同步的，浏览器不会发生假死。
    
	```javascript
    require([module], callback);

    require(['increment'], function (increment) {
        increment.add(1);
    });
    
    ``` 
    * define函数   
    * RequireJS定义了一个函数 define，它是全局变量，用来定义模块:
	```javascript
    	define(id?, dependencies?, factory);
    ```
	* 参数说明：

      * id：指定义中模块的名字，可选；如果没有提供该参数，模块的名字应该默认为模块加载器请求的指定脚本的名字。如果提供了该参数，模块名必须是“顶级”的和绝对的（不允许相对名字）。
      * 依赖dependencies：是一个当前模块依赖的，已被模块定义的模块标识的数组字面量。依赖参数是可选的，如果忽略此参数，它应该默认为["require", "exports", "module"]。然而，如果工厂方法的长度属性小于3，加载器会选择以函数的长度属性指定的参数个数调用工厂方法。
      * 工厂方法factory，模块初始化要执行的函数或对象。如果为函数，它应该只被执行一次。如果是对象，此对象应该为模块的输出值。
	举个例子看看
    ```javascript
		define('alpha',['require','exports','beta'],function(require,exports,beta){
        	exports.veba = function(){
            	return beta.verb()
              	//Or:
          		//return require("beta").verb();
            }
        })
    ```
	```javascript
    	math.js
    	define('math',['jquery'],function($){
        	return {
            	add:function(x,y){
                	return x + y
                }
            }
        })
    ```
       将该模块命名为math.js保存。
    ```javascript
    	main.js
      	require(['jquery','math'],function($,math){
        	console.log(math.add(10,100)) //110
        })
    ```
       将该模块命名为main.js保存。 

##CMD规范
 * CMD 即Common Module Definition通用模块定义，CMD规范是国内发展出来的，就像AMD有个requireJS，CMD有个浏览器的实现SeaJS，SeaJS要解决的问题和requireJS一样，只不过在模块定义方式和模块加载（可以说运行、解析）时机上有所不同。
* 在 CMD 规范中，一个模块就是一个文件。代码的书写格式如下:
	```javascript
    	define(function(require,exports,module){
        	// 模块代码
        })
    ```
    * require是可以把其他模块导入进来的一个参数;
    * exports是可以把模块内的一些属性和方法导出的;
    * module 是一个对象，上面存储了与当前模块相关联的一些属性和方法。
    
##AMD和CMD区别
* AMD是依赖关系前置,在定义模块的时候就要声明其依赖的模块;
* CMD是按需加载依赖就近,只有在用到某个模块的时候再去require：
 ```javascript
	/ CMD 写法
    define(function(require, exports, module) {
      var a = require('./a')
      a.doSomething()
      // 此处略去 100 行
      var b = require('./b') // 依赖可以就近书写
      b.doSomething()
      // ... 
    })

    // AMD 默认推荐的是  
    define(['./a', './b'], function(a, b) { // 依赖必须一开始就写好
      a.doSomething()
      // 此处略去 100 行
      b.doSomething()
      ...
    })
 ```
 # seajs使用例子
 	
```javascript
	//定义模块
	define(function(require,exports,module){
		var $ = require('jquery')
        $('div').addClass('active')
        exports.data = 1
    })
	// 加载模块
	seajs.ues(['mymodule'],function(my){
		console.log(my.data) //1
    })
	
 ```




