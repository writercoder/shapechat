// Generated by CoffeeScript 1.6.3
(function() {
  var Chat, Square,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Square = (function() {
    function Square() {}

    Square.prototype.draw = function(context, color) {
      console.log("Told to draw " + color);
      context.rect(20, 20, 150, 150);
      context.fillStyle = color;
      return context.fill();
    };

    return Square;

  })();

  Chat = (function() {
    function Chat() {
      this.error = __bind(this.error, this);
      this.maxFrequency = __bind(this.maxFrequency, this);
      this.doColouring = __bind(this.doColouring, this);
      this.colorShape = __bind(this.colorShape, this);
      this.drawShape = __bind(this.drawShape, this);
    }

    Chat.prototype.drawShape = function() {
      this.shape = new Square;
      this.shape.draw(this.context, "#ccc");
      return navigator.webkitGetUserMedia({
        video: false,
        audio: true
      }, this.colorShape, this.error);
    };

    Chat.prototype.colorShape = function(mediaStream) {
      this.stream = mediaStream;
      this.audioContext = new AudioContext();
      this.analyser = this.audioContext.createAnalyser();
      this.analyser.fftSize = 1024;
      this.source = this.audioContext.createMediaStreamSource(this.stream);
      this.source.connect(this.analyser);
      this.analyser.connect(this.audioContext.destination);
      this.bands = new Uint8Array(this.analyser.frequencyBinCount);
      return setInterval(this.doColouring, 100);
    };

    Chat.prototype.doColouring = function() {
      var color;
      this.analyser.getByteFrequencyData(this.bands);
      color = Math.floor(this.maxFrequency() * 16777215 / 1024).toString(16);
      return this.shape.draw(this.context, "\#" + color);
    };

    Chat.prototype.maxFrequency = function() {
      var freq, i, max, _i, _ref;
      max = 0;
      freq = 0;
      for (i = _i = 0, _ref = this.analyser.frequencyBinCount; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (this.bands[i] > max) {
          freq = i;
          max = this.bands[i];
        }
      }
      console.log("Max " + max + " Freq " + freq);
      return freq;
    };

    Chat.prototype.error = function() {
      return alert("Get user media failed");
    };

    Chat.prototype.listen = function() {
      this.context = document.getElementById("shapeCanvas").getContext("2d");
      return $('#speakMe').click(this.drawShape);
    };

    return Chat;

  })();

  $(function() {
    var chat;
    chat = new Chat();
    chat.listen();
    return chat.drawShape();
  });

}).call(this);
