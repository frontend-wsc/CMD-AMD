
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

浏览器端，加载 JavaScript 最佳、最容易的方式是在 document 中插入<script>标签。但脚本标签天生异步，传统 CommonJS 模块在浏览器环境中无法正常加载。

解决思路之一是，开发一个服务器端组件，对模块代码作静态分析，将模块与它的依赖列表一起返回给浏览器端。 这很好使，但需要服务器安装额外的组件，并因此要调整一系列底层架构。

另一种解决思路是，用一套标准模板来封装模块定义：

```
	define(function(require, exports, module) {

       // The module code goes here

    });
	
```
这套模板代码为模块加载器提供了机会，使其能在模块代码执行之前，对模块代码进行静态分析，并动态生成依赖列表。


##捐助开发者
在兴趣的驱动下,写一个`免费`的东西，有欣喜，也还有汗水，希望你喜欢我的作品，同时也能支持一下。
当然，有钱捧个钱场（右上角的爱心标志，支持支付宝和PayPal捐助），没钱捧个人场，谢谢各位。

##感激
感谢以下的项目,排名不分先后

* [mou](http://mouapp.com/) 
* [ace](http://ace.ajax.org/)
* [jquery](http://jquery.com)

##关于作者

```javascript
  var ihubo = {
    nickName  : "草依山",
    site : "http://jser.me"
  }
```
