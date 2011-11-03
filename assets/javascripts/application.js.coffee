#= require underscore-min
#= require jquery.min
#= require jquery-tmpl
#= require knockout
#= require_self
#= require_tree

$ ->
  # Get all the bits
  bitsJson = $('#bits_json').html()
  window.Bits = JSON.parse(bitsJson)

  # Get party bits data and make a party
  partyJson = $('#party_json').html()
  viewModel = new Party(JSON.parse(partyJson))
  
  $('label').each (i, label)->
    label = $(this)
    checkbox = $(this).find('input[type=checkbox]')
    checkbox.click (e)->
      console.log('Checkbox clicked')

    checkboxValue = checkbox.attr('value')
    
    link = $('<a href="#" class="label-trigger" />')
    link.data('bit', checkboxValue)
    link.attr('data-bind', "css: {'ko-enabled':true, 'checked':bitSelected('#{checkboxValue}')}")
    link.click (e)->
      console.log('Link clicked')
      e.preventDefault()
      e.stopPropagation()
      # checkbox.click()
      viewModel.toggleBit(checkboxValue)

    # label.wrap(link)
  
  # Bind the UI
  ko.applyBindings(viewModel)