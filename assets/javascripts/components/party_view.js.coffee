window.PartyView =
  init: ()->
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

class window.Party
  constructor: (bits) ->
    @bits = ko.observableArray(bits)
  
  toggleAll: (namespace) ->
    nsBits = window.Bits[namespace]
    if @bitsInNamespace(namespace).length == nsBits.length
      for bitPath in nsBits
        do (bitPath) =>
          index = @bits().indexOf(bitPath)
          @bits.splice(index, 1)
    else
      for bitPath in nsBits
        do (bitPath) =>
          unless @bits().indexOf(bitPath) > -1
            @bits.push(bitPath);
  
  toggleLabel: (ns) ->
    nsBits = window.Bits[ns]
    if @bitsInNamespace(ns).length == nsBits.length
      "Uncheck all"
    else
      "Select all"
  
  bitSelected: (bit)->
    @bits().indexOf(bit) > -1
  
  toggleBit: (bit)->
    console.log('Bit toggled')
    if (idx = @bits().indexOf(bit)) > -1
      @bits.splice(idx, 1)
    else
      @bits.push(bit)
  
  bitsInNamespace: (ns) ->
    @bits().filter (bit)->
      return bit.match('^'+ns)

  hasNamespace: (ns) ->
    @bits().some (bit) ->
      return bit.match('^'+ns)