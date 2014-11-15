
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
#    @analyser.fftSize = 32
    @analyser.minDecibels = -40;
    @analyser.maxDecibels = -20;
    @analyser.smoothingTimeConstant = 0.9;

    @source = @audioContext.createMediaStreamSource(@stream)
    @source.connect( @analyser )
#    @analyser.connect( @audioContext.destination )
    @bands = new Uint8Array(@analyser.frequencyBinCount)
    setInterval( @doColouring, 100 )

  doColouring: =>
    @analyser.getByteFrequencyData @bands
    color = Math.floor(@maxFrequency() * 16777215 / 1024).toString(16).toUpperCase()
    color = ("000000" + color).substr(-6)
    @shape.draw( @context, "\##{color}" )


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

$ ->
  chat = new Chat()
  chat.listen()
  chat.drawShape()
  
