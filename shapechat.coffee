
class Square

  draw: (context, color) ->
    console.log( "Told to draw #{color}")
    context.rect( 20, 20, 150, 150 )
    context.fillStyle = color
    context.fill()

class Chat

  drawShape: =>
    @shape = new Square
    @shape.draw(@context, "#ccc")

    navigator.webkitGetUserMedia( { video: false, audio: true }, @colorShape, @error )

  colorShape: (mediaStream) =>
    @stream = mediaStream
    @audioContext = new AudioContext()
    @analyser = @audioContext.createAnalyser()
    @analyser.fftSize = 2048
    @analyser.minDecibels = -90;
    @analyser.maxDecibels = -10;
    @analyser.smoothingTimeConstant = 0.90;

    @source = @audioContext.createMediaStreamSource(@stream)
    @source.connect( @analyser )
    @analyser.connect( @audioContext.destination )
    @bands = new Uint8Array(@analyser.frequencyBinCount)
    setInterval( @doColouring, 100 )

  doColouring: =>
    @analyser.getByteFrequencyData @bands
    console.log @maxFrequency()
    color = @colors[@maxFrequency()]
    # color = ("000000" + color).substr(-6)
    @shape.draw( @context, color )


  maxFrequency: =>
    max = 0
    freq = 0
    for i in [0...@analyser.frequencyBinCount]
      if @bands[i] > max
        freq = i
        max = @bands[i]
    console.log( "Max #{max} Freq #{freq}" )
    return freq


  error: =>
    alert("Get user media failed")

  listen: ->
    @context = document.getElementById("shapeCanvas").getContext("2d")
    $('#speakMe').click( @drawShape )

  colors: ["#000000","#000033","#000066","#000099","#0000cc","#0000ff","#003300","#003333","#003366","#003399","#0033cc","#0033ff","#006600","#006633","#006666","#006699","#0066cc","#0066ff","#009900","#009933","#009966","#009999","#0099cc","#0099ff","#00cc00","#00cc33","#00cc66","#00cc99","#00cccc","#00ccff","#00ff00","#00ff33","#00ff66","#00ff99","#00ffcc","#00ffff","#330000","#330033","#330066","#330099","#3300cc","#3300ff","#333300","#333333","#333366","#333399","#3333cc","#3333ff","#336600","#336633","#336666","#336699","#3366cc","#3366ff","#339900","#339933","#339966","#339999","#3399cc","#3399ff","#33cc00","#33cc33","#33cc66","#33cc99","#33cccc","#33ccff","#33ff00","#33ff33","#33ff66","#33ff99","#33ffcc","#33ffff","#660000","#660033","#660066","#660099","#6600cc","#6600ff","#663300","#663333","#663366","#663399","#6633cc","#6633ff","#666600","#666633","#666666","#666699","#6666cc","#6666ff","#669900","#669933","#669966","#669999","#6699cc","#6699ff","#66cc00","#66cc33","#66cc66","#66cc99","#66cccc","#66ccff","#66ff00","#66ff33","#66ff66","#66ff99","#66ffcc","#66ffff","#990000","#990033","#990066","#990099","#9900cc","#9900ff","#993300","#993333","#993366","#993399","#9933cc","#9933ff","#996600","#996633","#996666","#996699","#9966cc","#9966ff","#999900","#999933","#999966","#999999","#9999cc","#9999ff","#99cc00","#99cc33","#99cc66","#99cc99","#99cccc","#99ccff","#99ff00","#99ff33","#99ff66","#99ff99","#99ffcc","#99ffff","#cc0000","#cc0033","#cc0066","#cc0099","#cc00cc","#cc00ff","#cc3300","#cc3333","#cc3366","#cc3399","#cc33cc","#cc33ff","#cc6600","#cc6633","#cc6666","#cc6699","#cc66cc","#cc66ff","#cc9900","#cc9933","#cc9966","#cc9999","#cc99cc","#cc99ff","#cccc00","#cccc33","#cccc66","#cccc99","#cccccc","#ccccff","#ccff00","#ccff33","#ccff66","#ccff99","#ccffcc","#ccffff","#ff0000","#ff0033","#ff0066","#ff0099","#ff00cc","#ff00ff","#ff3300","#ff3333","#ff3366","#ff3399","#ff33cc","#ff33ff","#ff6600","#ff6633","#ff6666","#ff6699","#ff66cc","#ff66ff","#ff9900","#ff9933","#ff9966","#ff9999","#ff99cc","#ff99ff","#ffcc00","#ffcc33","#ffcc66","#ffcc99","#ffcccc","#ffccff","#ffff00","#ffff33","#ffff66","#ffff99","#ffffcc","#ffffff"]

$ ->
  chat = new Chat()
  chat.listen()
  chat.drawShape()

