describe "jQuery.responsiveMenu", ->
  beforeEach ->
    loadFixtures "oneLevelMenu.html"
    @one = $("#one-level-menu")

    dummyDiv = $('<div id="dummy"></div>')
    dummyDiv.appendTo("body")
    @options =
      switchWidth: 555
      appendTo: "#dummy"

    afterEach ->
      $("#dummy").remove()

    @addMatchers
      toBeHtmlStuctureEqual: (expected) ->
        removeGarbage = (html) ->
          html = html.split(' style="display:none;"').join('')
          html = html.split(' style="display:block;"').join('')
          html = html.split(' style="display: none;"').join('')
          html = html.split(' style="display: block;"').join('')

          html

        removeGarbage(@actual) is expected


  describe "plugin options behavior", ->
    it "should be available on the jQuery object", ->
      expect($.fn.responsiveMenu).toBeDefined()

    it "should be chainable", ->
      expect(@one.responsiveMenu()).toBe(@one)

    it "should offer default values", ->
      plugin = @one.responsiveMenu().data("responsiveMenu")

      expect(plugin.defaults).toBeDefined()

    it "should overwrite the defaults", ->
      options =
        switchWidth: 555
        currentClass: "this-is"
        appendTo: "#here"
        visualTab: "+"
        manualMediaQueries: true

      plugin = @one.responsiveMenu(options).data("responsiveMenu")

      expect(plugin.options.switchWidth).toBe(options.switchWidth)
      expect(plugin.options.currentClass).toBe(options.currentClass)
      expect(plugin.options.appendTo).toBe(options.appendTo)
      expect(plugin.options.visualTab).toBe(options.visualTab)
      expect(plugin.options.manualMediaQueries).toBe(options.manualMediaQueries)


  describe "manualMediaQueries", ->
    describe "when it is set to false", ->
      beforeEach ->
        @plugin = @one.responsiveMenu(@options).data("responsiveMenu")

      it "should trigger onResize method", ->
        spyOn(@plugin, 'onResize')

        $(window).trigger('resize')

        expect(@plugin.onResize).toHaveBeenCalled()

      it "should hide select menu and show actual menu when window width is wider than switchWidth", ->
        fakeEvent =
          width: ()->
            600

        @plugin.onResize(fakeEvent)

        expect(@one).toBeVisible()
        expect($('#dummy select')).toBeHidden()

      it "should show select menu and hide an actual menu when window width is narrower than switchWidth", ->
        fakeEvent =
          width: ()->
            500

        @plugin.onResize(fakeEvent)

        expect(@one).toBeHidden()
        expect($('#dummy select')).toBeVisible()

    describe "when it is set to true", ->
      beforeEach ->
        options =
          appendTo: "#dummy"
          manualMediaQueries: true
        @plugin = @one.responsiveMenu(options).data("responsiveMenu")

      it "shouldn't change visibility of menus", ->
        spyOn(@plugin, 'onResize')

        $(window).trigger('resize')

        expect(@plugin.onResize).not.toHaveBeenCalled()


  describe "with one level menu", ->
    it "should generate correct html tree", ->
      shouldBeGenerated = '<select class="responsive-select-menu">'+
        '<option value="#one">One</option><option value="#two">Two</option>'+
        '<option value="#three">Three</option>'+
        '<option value="#four">Four</option></select>'

      a = @one.responsiveMenu(@options).data("responsiveMenu")

      generatedHtml = a.select.parent().html()

      expect(generatedHtml).toBeHtmlStuctureEqual(shouldBeGenerated)

    it "should set a selected on current page item", ->
      loadFixtures 'oneLevelMenuWithCurrent.html'
      @withCurrent = $('#one-level-menu-with-current')

      shouldBeGenerated = '<select class="responsive-select-menu">'+
        '<option value="#one">One</option>'+
        '<option value="#two" selected="selected">Two</option>'+
        '<option value="#three">Three</option>'+
        '<option value="#four">Four</option></select>'

      generatedHtml = @withCurrent.responsiveMenu(@options).data("responsiveMenu").select.parent().html()

      expect(generatedHtml).toBeHtmlStuctureEqual(shouldBeGenerated)


  describe "with multi-level menu", ->
    beforeEach ->
      loadFixtures "multiLevelMenu.html"
      @multi = $("#multi-level-menu")

      loadFixtures "multiLevelMenuWithCurrent.html"
      @multiWithCurrent = $("#multi-level-with-current-menu")

    it "should generate corrent html tree", ->
      shouldBeGenerated = '<select class="responsive-select-menu">'+
        '<option value="#one">One</option><option value="#two">Two</option>'+
        '<option value="#sub-one">--Sub-one</option>'+
        '<option value="#sub-sub-one">----Sub-Sub-one</option>'+
        '<option value="#sub-sub-two">----Sub-Sub-two</option>'+
        '<option value="#sub-two">--Sub-two</option>'+
        '<option value="#three">Three</option>'+
        '<option value="#four">Four</option>'+
        '</select>'

      generatedHtml = @multi.responsiveMenu(@options).data("responsiveMenu").select.parent().html()

      expect(generatedHtml).toBeHtmlStuctureEqual(shouldBeGenerated)

    it "should correctly set in select menu current page item on multilevel menu", ->
      shouldBeGenerated = '<select class="responsive-select-menu">'+
        '<option value="#one">One</option><option value="#two">Two</option>'+
        '<option value="#sub-one">--Sub-one</option>'+
        '<option value="#sub-sub-one">----Sub-Sub-one</option>'+
        '<option value="#sub-sub-two" selected="selected">----Sub-Sub-two</option>'+
        '<option value="#sub-two">--Sub-two</option>'+
        '<option value="#three">Three</option>'+
        '<option value="#four">Four</option>'+
        '</select>'
      
      generatedHtml = @multiWithCurrent.responsiveMenu(@options).data("responsiveMenu").select.parent().html()

      expect(generatedHtml).toBeHtmlStuctureEqual(shouldBeGenerated)     
