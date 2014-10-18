
class Square

  draw: (context, colour) ->
    context.rect( 20, 20, 150, 150 )
    context.fillStyle = colour
    context.fill()

class Chat

  drawShape: =>
    @shape = new Square
    @shape.draw(@context, "#ccc")

    navigator.webkitGetUserMedia( { video: false, audio: true }, @colorShape, @error )

  colorShape: (mediaStream) =>
    @stream = mediaStream
    @audioContext = new AudioContext
    @analyser = @audioContext.createAnalyser()
    # @analyser.minDecibels = -90;
    # @analyser.maxDecibels = -10;
    # @analyser.smoothingTimeConstant = 0.85;

    @source = @audioContext.createMediaStreamSource(@stream)
    # @analyser.connect( @source )
    @source.connect( @analyser )
    @bands = new Uint32Array(4096)
    setInterval( @doColouring, 100 )

  doColouring: =>
    @analyser.getByteFrequencyData @bands
    color = (@maxFrequency() * 16777215 / 1024).toString(16)
    @shape.draw( @context, "\##{color}" )


  maxFrequency: ->
    max = 0
    freq = 0
    for i in [0...4096]
      if @bands[i] > max
        freq = i
        max = bands[i]
    console.log( "Max #{max} Freq #{freq}" )
    return freq


  error: =>
    alert("Get user media failed")

  listen: ->
    @context = document.getElementById("shapeCanvas").getContext("2d")
    $('#speakMe').click( @drawShape )

$(-> new Chat().listen())
  
