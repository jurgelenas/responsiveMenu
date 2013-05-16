do ($ = jQuery, window, document) ->

  # Create the defaults once
  defaults =
    appendTo: null
    switchWidth: 768
    currentClass: "current"
    visualTab: "--"
    maxDepth: null
    manualMediaQueries: false
    label: null
    selectors:
      menuElement: 'li'
      menuAnchor: '> a'
      submenu: '> ul'

  class ResponsiveMenu
    constructor: (@element, options) ->
      @element = $(@element)
      @options = $.extend({}, defaults, options)
      @defaults = defaults

      @init()

    init: ->
      @select = @createSelect()

      if @options.appendTo is null
        @select.appendTo(@element.parent())
      else
        @select.appendTo($(@options.appendTo))

      @select.change((e) =>
        @redirectTo($(e.currentTarget).val())
      )

      $(window).resize((e) =>
        @onResize($(e.currentTarget))
      ).trigger('resize') if not @options.manualMediaQueries

    createSelect: ->
      $select = $('<select class="responsive-select-menu" />')
      menuTree = @generateMenuTree(@element)
      selectOptions = ''

      if @options.label isnt null 
        selectOptions += @createOption(@options.label, "#no-redirect", false, 0)

      addOptionsRecursive = (menuTree, level) =>
        level++

        if @options.maxDepth isnt null and level > @options.maxDepth
          return

        $.each menuTree, (index, value) =>
          selectOptions += @createOption(value.title, value.url, value.current, level)
          addOptionsRecursive(value.subnodes, level) if value.subnodes isnt undefined

      addOptionsRecursive(menuTree, 0)

      $select.append(selectOptions)

    generateMenuTree: (el) ->
      menu = []

      $(el).children(@options.selectors.menuElement).each (index, value) =>
        $menuLi      = $(value)
        $menuAnchor  = $($menuLi).find(@options.selectors.menuAnchor)
        $submenu     = $menuLi.find(@options.selectors.submenu)

        menu.push
          title   : $menuAnchor.text()
          url     : $menuAnchor.attr('href')
          current : $menuLi.hasClass(@options.currentClass)
          subnodes: @generateMenuTree($submenu)

      menu

    createOption: (title, url, current, level) ->
      visualTab = @repeatPattern(@options.visualTab, level)
      selected = ''
      selected = ' selected="selected"' if current

      "<option value=\"#{url}\"#{selected}>#{visualTab}#{title}</option>"

    repeatPattern: (pattern, count) ->
      return '' if count <= 1

      Array(count).join(pattern) + " "

    onResize: (e) =>
      if e.width() <= @options.switchWidth
        @element.hide()
        @select.show()
      else
        @select.hide()
        @element.show()

    redirectTo: (url) ->
      document.location.href = url if url isnt "#no-redirect"


  # A really lightweight plugin wrapper around the ResponsiveMenu class,
  # preventing against multiple instantiations
  $.fn.responsiveMenu = (options) ->
    @each ->
      if !$.data(this, "responsiveMenu")
        $.data(this, "responsiveMenu", new ResponsiveMenu(this, options))
