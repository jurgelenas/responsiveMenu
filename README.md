# jQuery.responsiveMenu

A responsive navigation jQuery plugin. It converts `<ul>` and `<ol>` menus to `<select>` dropdowns for small screen devices. It also automatically selects the current page and adds selected="selected" for that item.

There are many other different plugins to do this job, but I couldn't find anything that suited my needs and I created my own. I discovered that I am using this plugin over and over again on my projects and I thought that It could be useful for somebody else and decided to open-source it.


### Features:

* Simple and easy to use
* Unlimited levels of submenus
* Variety of configuration options
* Works on all major desktop and mobile browsers
* Weighs only 1098 bytes minified and Gzip'ed
* Well tested (TDD)
* Free to use under the MIT license


## Usage

1. Grab minified plugin version from `dist/jQuery.responsiveMenu.min.js`
2. Put it into the `<head>`

	```html
	<script src="path/to/jQuery.responsiveMenu.min.js"></script>
	```

3. Add markup:

	```html
	<ul id="regular-menu">
	  <li><a href="/one">One</a></li>
	  <li class="current"><a href="/two">Two</a></li>
	  <li>
	  	<a href="/three">Three</a>
	  	<ul>
	  		<li><a href="/sub-one">Sub One</a></li>
	  		<li><a href="/sub-two">Sub Two</a></li>
	  	</ul>
	  </li>
	  <li><a href="/four">Four</a></li>
	</ul>
	```
4. Instantiate plugin:

	```html
	<script>
		$(function () {
			$("#regular-menu").responsiveMenu({
				// Default options
				appendTo: "#here",
				switchWidth: 768,
				currentClass: "current",
				visualTab: "--",
				maxDepth: null,
				manualMediaQueries: false,
				label: null,
				selectors: {
				  menuElement: 'li',
				  menuAnchor: '> a',
				  submenu: '> ul'
				}
			});
		});
	</script>
	```


## Plugin Options

* appendTo - (type: string/jQuery object) a valid jQuery selector, for example:
  * string ```"#regular-menu"```
  * jQuery object ```$("#regular-menu")```
  * Default: Sibling to regular menu element (#regular-menu)
* switchWidth - (type: integer) under this width plugin will hide regular menu and will show select menu instead
	* default: 768
* currentClass - (type: string) menuElement class primary used to determine current page
	* HTML: ```<li class="current"><a href="/two">Two</a></li>```
	* Default: "current"
* maxDepth - (type: integer) Depth of navigation. If set, for example, maxDepth: 1 plugin will take only one level of menu
	* default: null

* manualMediaQueries - (type: boolean) If set to true, you will need to manually toggle between regular and select menus, for example:

	```css
	/* desktop */
	.responsive-select-menu { display: none }

	/* mobile */
	@media screen and (max-width: 768px) {
	    .responsive-select-menu { display: block }
	    #regular-menu { display: none }
	}
	```

* visualTab - (type: string) it seperates child pages from parent pages

	```
	Parent
	-- Child
	-- Child
	---- Subchild
	---- Subchild
	```

* label - (type: string) sets the label text for the select (if not set, no label will be added)

* selectors - if you have a different html structure, you can set custom jQuery selectors:
	* menuElement: 'li'
	* menuAnchor: '> a'
	* submenu: '> ul'


## Bug tracker

If you find a bug, please report it [on Github!](https://github.com/jurgelenas/responsiveMenu/issues)


## Developer

Developed by [Julius Jurgelėnas](http://julius.jurgelenas.lt)

* [@jurgelenas](http://twitter.com/jurgelenas)
* [Github Profile](http://github.com/jurgelenas)


## License

Copyright &copy; 2013 Julius Jurgelėnas

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
