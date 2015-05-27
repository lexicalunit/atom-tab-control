{SelectListView} = require 'atom-space-pen-views'

module.exports =
class TabControlView extends SelectListView
  initialize: ->
    super
    @addClass('tab-control')
    @list.addClass('mark-active')

  getFilterKey: ->
    'name'

  destroy: ->
    @cancel()

  viewForItem: (item) ->
    element = document.createElement('li')
    element.classList.add('active') if item.active
    element.textContent = item.text
    element

  cancelled: ->
    @panel?.destroy()
    @panel = null
    @editor = null

  confirmed: (item) ->
    item.command item.value
    @cancel()

  attach: ->
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @focusFilterEditor()

  toggle: ->
    if @panel?
      @cancel()
    else if @editor = atom.workspace.getActiveTextEditor()
      @setItems(@getTabControlItems())
      @attach()

  getTabControlItems: ->
    currentTabLength = @editor.getTabLength()
    items = for n in [1, 2, 3, 4, 8]
      text: "Tab Width: #{n}"
      value: n
      command: (value) => @editor.setTabLength(value)
      active: currentTabLength == n
    items.push
      text: "Indent Using Spaces"
      value: null
      command: (value) => @editor.toggleSoftTabs()
      active: @editor.getSoftTabs()
    items
