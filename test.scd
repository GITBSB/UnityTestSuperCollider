

(
// define an echo effect
SynthDef.new(\echo, {
	arg in, out, delay = 0.2, decay = 5;
	var sig;
    sig = In.ar(in,2);
	sig = CombN.ar(sig, 0.5, delay, decay, 1, sig);
    Out.ar(out, sig);
}).add;
)


(
SynthDef.new(\reverb, {
	arg in, out;
	var sig;
	sig = In.ar(in, 1);
	sig = FreeVerb.ar(sig, 0.9, 0.6, 0.4)!2;
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\distort, {
	arg out=0, in, pregain=40, amp=0.2, gate=1;
    var env;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	in = In.ar(in, 2);
    XOut.ar(out, env, (in * pregain).distort * amp);
}, [\ir, 0.1, 0.1, 0]).add;
)


(
SynthDef.new(\kick, {
	arg out, amp = 0, pan = 0;
	var env, bass;
	env = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);
	bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);
	Out.ar(out, Pan2.ar(bass*env, pan, amp));
}).add;
)


(
SynthDef.new(\output, {
	arg in;
	var sig;
	sig = In.ar(in, 2);
	Out.ar(0, sig);
}).add;
)

~bus = Bus.audio(s, 2);
~bus2 = Bus.audio(s, 2);

g = Group.new;
h = Group.new;

a = Synth.head(g, \echo, [\in, ~bus, \out, ~bus]);
b = Synth.head(g, \reverb, [\in, ~bus, \out, ~bus]);
c = Synth.head(g, \distort, [\in, ~bus, \out, ~bus]);

y = Synth.tail(g, \output, [\in, ~bus]);
x = Synth.new(\kick, [\out, ~bus, \amp, 1]);



k = Synth.head(h, \distort, [\in, ~bus2, \out, ~bus2]);
f = Synth.head(h, \reverb, [\in, ~bus2, \out, ~bus2]);
y = Synth.tail(h, \output, [\in, ~bus2]);
x = Synth.new(\kick, [\out, ~bus, \amp, 1]);

y.nodeID.postln;

SynthDef.removeAt(\output);

g.free

c.free;



d=Synth.new(\bass_Ex );

s.sendMsg(\n_free, 1000)

1015.asNodeID.free;
s.meter;
s.plotTree;

s.freeAll;



(