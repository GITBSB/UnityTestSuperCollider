s.boot;
(
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
	arg out, in, pregain=40, amp=0.2, gate=1;
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



~group1 = Group.new;
~group2 = Group.new;

~bus1 = Bus.audio(s, 2);
~bus2 = Bus.audio(s, 2);

a = Synth.head(~group2, \echo, [\in, ~bus1, \out, ~bus1]);
b = Synth.tail(~group2, \output, [\in, ~bus1]);

c = Synth.head(~group1, \reverb, [\in, ~bus2, \out, ~bus2]);
d = Synth.head(~group1, \distort, [\in, ~bus2, \out, ~bus2]);
e = Synth.tail(~group1, \output, [\in, ~bus2]);



~bus2.index;


s.sendMsg("/g_new", 2, 0, 1);
s.sendMsg("/g_new", 3, 0, 1);

s.sendMsg("/s_new", "distort", 101, 0, 2, "in", 4, "out", 4);
s.sendMsg("/s_new", "output", 102, 1, 2, "in", 4);

s.sendMsg("/s_new", "echo", 103, 0, 3, "in", 6, "out", 6);
s.sendMsg("/s_new", "output", 104, 1, 3,"in", 6);


s.options.numInputBusChannels

s.sendMsg("/s_new", "kick", x=s.nextNodeID, 0, 1,"out", 6, "amp", 1);
x = Synth.new(\kick, [\out, 6, \amp, 1]);


s.sendMsg("/n_free", 2)
s.sendMsg("/g_freeAll", 2)


s.meter;
s.plotTree;

s.freeAll;



(