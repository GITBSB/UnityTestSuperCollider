


(
n.sendMsg("/synthDef.add", "\\tom", "SynthDef.new(\\tom, {|out = 0, amp = 0, pan|
var env, tom;
env = EnvGen.kr(Env.perc(0.001, 0.1, 1, -5), 1, doneAction:2);
tom = SinOsc.ar(440);
Out.ar(out, Pan2.ar(tom*env, pan, amp));
}).add;"

);
)

(
SynthDef.new(\kick, {|out = 0, amp = 0, pan|
var env, bass;
env = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);
bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);
Out.ar(out, Pan2.ar(bass*env, pan, amp));
}).add;
)

Synth.new(\kick, [\out, 0, \amp, 1]);

n.sendMsg("/synthDef.add", "1", "2");

n.sendMsg("/synthDef.play", "\openhat");

n.sendMsg("/synthDef.playWithArg", "tom", "out", 0.5, "amp", 1);