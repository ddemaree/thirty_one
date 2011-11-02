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
  
  # Bind the UI
  ko.applyBindings(viewModel)