(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  (function($, window, document) {
    var ResponsiveMenu, defaults;

    defaults = {
      appendTo: null,
      switchWidth: 768,
      currentClass: "current",
      visualTab: "--",
      maxDepth: null,
      manualMediaQueries: false,
      selectors: {
        menuElement: 'li',
        menuAnchor: '> a',
        submenu: '> ul'
      }
    };
    ResponsiveMenu = (function() {
      function ResponsiveMenu(element, options) {
        this.element = element;
        this.onResize = __bind(this.onResize, this);
        this.element = $(this.element);
        this.options = $.extend({}, defaults, options);
        this.defaults = defaults;
        this.init();
      }

      ResponsiveMenu.prototype.init = function() {
        var _this = this;

        this.select = this.createSelect();
        if (this.options.appendTo === null) {
          this.select.appendTo(this.element.parent());
        } else {
          this.select.appendTo($(this.options.appendTo));
        }
        this.select.change(function(e) {
          return _this.redirectTo($(e.currentTarget).val());
        });
        if (!this.options.manualMediaQueries) {
          return $(window).resize(function(e) {
            return _this.onResize($(e.currentTarget));
          }).trigger('resize');
        }
      };

      ResponsiveMenu.prototype.createSelect = function() {
        var $select, addOptionsRecursive, menuTree, selectOptions,
          _this = this;

        $select = $('<select class="responsive-select-menu" />');
        menuTree = this.generateMenuTree(this.element);
        selectOptions = '';
        addOptionsRecursive = function(menuTree, level) {
          level++;
          if (_this.options.maxDepth !== null && level > _this.options.maxDepth) {
            return;
          }
          return $.each(menuTree, function(index, value) {
            selectOptions += _this.createOption(value.title, value.url, value.current, level);
            return addOptionsRecursive(value.subnodes, level);
          });
        };
        addOptionsRecursive(menuTree, 0);
        return $select.append(selectOptions);
      };

      ResponsiveMenu.prototype.generateMenuTree = function(el) {
        var menu,
          _this = this;

        menu = [];
        $(el).children(this.options.selectors.menuElement).each(function(index, value) {
          var $menuAnchor, $menuLi, $submenu;

          $menuLi = $(value);
          $menuAnchor = $($menuLi).find(_this.options.selectors.menuAnchor);
          $submenu = $menuLi.find(_this.options.selectors.submenu);
          return menu.push({
            title: $menuAnchor.text(),
            url: $menuAnchor.attr('href'),
            current: $menuLi.hasClass(_this.options.currentClass),
            subnodes: _this.generateMenuTree($submenu)
          });
        });
        return menu;
      };

      ResponsiveMenu.prototype.createOption = function(title, url, current, level) {
        var selected, visualTab;

        visualTab = this.repeatString(this.options.visualTab, level);
        selected = '';
        if (current) {
          selected = ' selected="selected"';
        }
        return "<option value=\"" + url + "\"" + selected + ">" + visualTab + title + "</option>";
      };

      ResponsiveMenu.prototype.repeatString = function(pattern, count) {
        if (count < 1) {
          return '';
        }
        return Array(count).join(pattern);
      };

      ResponsiveMenu.prototype.onResize = function(e) {
        if (e.width() <= this.options.switchWidth) {
          this.element.hide();
          return this.select.show();
        } else {
          this.select.hide();
          return this.element.show();
        }
      };

      ResponsiveMenu.prototype.redirectTo = function(url) {
        return document.location.href = url;
      };

      return ResponsiveMenu;

    })();
    return $.fn.responsiveMenu = function(options) {
      return this.each(function() {
        if (!$.data(this, "responsiveMenu")) {
          return $.data(this, "responsiveMenu", new ResponsiveMenu(this, options));
        }
      });
    };
  })(jQuery, window, document);

}).call(this);
