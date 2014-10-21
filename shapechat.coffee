
class Square

  draw: (context, color) ->
    # console.log( "Told to draw #{color}")
    context.rect( 20, 20, 400, 400 )
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
    @analyser.fftSize = 128
    # @analyser.minDecibels = -90;
    # @analyser.maxDecibels = -10;
    @analyser.smoothingTimeConstant = 0.85;
    @source = @audioContext.createMediaStreamSource(@stream)
    @source.connect( @analyser )
    # @analyser.connect( @audioContext.destination )
    @bands = new Uint8Array(@analyser.frequencyBinCount)
    @bucketSize = Math.round(@analyser.frequencyBinCount / 6)
    setInterval( @doColouring, 100 )

  doColouring: =>
    console.info( @bands )
    @analyser.getByteFrequencyData @bands
    hexScore = Math.round(@maxFrequency() * 16777215 / 128).toString(16).toUpperCase()
    # color = (@maxFrequency() * 16383).toString(16)
    # score = @soundScore()
    # adjustedScore = score * 0.16
    # roundedScore = Math.round(adjustedScore)
    # hexScore = roundedScore.toString(16)
    # console.info( score: score, a: adjustedScore, r: roundedScore, h: hexScore )
    # color = Math.round(@soundScore() * 0.16).toString(16)
    color = ("000000" + hexScore).substr(-6)
     # 6 ~ channelValue * 1500 / 255
    rgbRaw =
      b: @channelOne()
      g: @channelTwo()
      r: @channelThree()
    console.info( rgbRaw )
    total = rgbRaw.r + rgbRaw.g + rgbRaw.b
    console.log( total )
    n = ( channelValue ) -> Math.round( channelValue * (6000 / total) / 10 )
    rgb =
      r: n( rgbRaw.r )
      g: n( rgbRaw.g )
      b: n( rgbRaw.b )
    console.info( rgb )
    rgbStr = "rgb(#{rgb.r},#{rgb.g},#{rgb.b})"
    console.log( "Drawing #{rgbStr}" )
    @shape.draw( @context, rgbStr )
    # console.log( "Score: #{@soundScore()}" )

  maxFrequency: =>
    max = 0
    freq = 0
    for i in [1...@analyser.frequencyBinCount]
      if @bands[i] > max
        freq = i
        max = @bands[i]
    # console.log( "Max #{max} Freq #{freq}" )
    return freq

  soundScore: ->
    score = 0
    for i in [0...@analyser.frequencyBinCount]
      score += i * @bands[i]
    score

  channelOne: ->
    score = 0
    for i in [0..@bucketSize]
      score += @bands[i]
    score * 0.7

  channelTwo: ->
    score = 0
    for i in [@bucketSize..@bucketSize * 2]
      score += @bands[i]
    score * 1.5

  channelThree: ->
    score = 0
    for i in [@bucketSize * 2..@bucketSize * 3]
      score += @bands[i]
    score * 2.5

  error: =>
    alert("Get user media failed")

  listen: ->
    @context = document.getElementById("shapeCanvas").getContext("2d")
    $('#speakMe').click( @drawShape )

$ ->
  chat = new Chat()
  chat.listen()
  chat.drawShape()
  
