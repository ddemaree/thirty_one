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