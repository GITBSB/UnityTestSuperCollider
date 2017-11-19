s.boot; // start the server

// something to record
(
SynthDef("bubbles", {
    var f, zout;
    f = LFSaw.kr(0.4, 0, 24, LFSaw.kr([8,7.23], 0, 3, 80)).midicps; // glissando function
    zout = CombN.ar(SinOsc.ar(f, 0, 0.04), 0.2, 0.2, 4); // echoing sine wave
    Out.ar(0, zout);
}).add;
)

x = Synth.new("bubbles");

s.prepareForRecord; // if you want to start recording on a precise moment in time, you have to call this first.

s.record;

s.pauseRecording; // pausable

s.record // start again

s.stopRecording; // this closes the file and deallocates the buffer recording node, etc.

x.free; // stop the synths