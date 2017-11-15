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
	arg in, out, pregain=40, amp=0.2, gate=1;
    var env, sig;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	sig = In.ar(in, 2);
    XOut.ar(out, env, (sig * pregain).distort * amp);
}, [\ir, 0.1, 0.1, 0]).add;
)

(
SynthDef.new(\distort, {
	arg in, out, pregain=40, amp=0.2, gate=1;
    var env, sig;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	sig = In.ar(in, 2);
    XOut.ar(out, env, (sig * pregain).distort * amp);
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
SynthDef(\wah, {
	arg out, in, gate=1;
    var env, sig;
    env = Linen.kr(gate, 0.05, 1, 0.4, 2);
    sig = In.ar(in, 2);
    XOut.ar(out, env, RLPF.ar(sig, LinExp.kr(LFNoise1.kr(0.3), -1, 1, 200, 8000), 0.1).softclip * 0.8);
}, [\ir, 0]).add;
)

(
SynthDef(\wah2, { arg out, in, gate=1;
    var sig;
    sig = In.ar(in, 2);
    Out.ar(out, RLPF.ar(sig, LinExp.kr(LFNoise1.kr(0.3), -1, 1, 200, 8000), 0.1).softclip * 0.8);
}).add;
)

(
SynthDef.new(\wah3, {
	arg in, out, rate = 1.5, cfreq = 1400, mfreq = 1200, rq=0.1;
    var sig;
    sig = In.ar(in, 2);
    cfreq = Lag3.kr(cfreq, 0.1);
    mfreq = Lag3.kr(mfreq, 0.1);
    rq   = Ramp.kr(rq, 0.1);
    sig = RLPF.ar(sig, LFNoise1.kr(rate, mfreq, cfreq), rq, 10).distort
                    * 0.15;
	Out.ar( out , sig );
}).add;
)

(
SynthDef.new(\rlpf,{
	arg out, in,ffreq=600,rq=0.1;
	var sig;
	sig =  In.ar(out);
    Out.ar( out, RLPF.ar(sig, ffreq,rq) )
}).add;
)


(
SynthDef.new(\output, {
	arg in, vol=1;
	var sig;
	sig = In.ar(in, 2);
	Out.ar(0, sig * vol);
}).add;
)



~group1 = Group.new;
~group2 = Group.new;

~bus1 = Bus.audio(s, 2);
~bus2 = Bus.audio(s, 2);

a = Synth.head(~group1, \echo, [\in, ~bus1, \out, ~bus1]);
b = Synth.tail(~group1, \output, [\in, ~bus1]);

c = Synth.head(~group1, \reverb, [\in, ~bus2, \out, ~bus2]);
d = Synth.head(~group2, \distort, [\in, ~bus2, \out, ~bus2]);
e = Synth.tail(~group2, \output, [\in, ~bus2]);



~bus2.index;


s.sendMsg("/g_new", 2, 0, 1);
s.sendMsg("/g_new", 3, 0, 1);

s.sendMsg("/s_new", "rlpf", 101, 0, 2, "in", 4, "out", 4);
s.sendMsg("/s_new", "output", 102, 1, 2, "in", 4);

s.sendMsg("/s_new", "distort", 103, 0, 3, "in", 6, "out", 6);
s.sendMsg("/s_new", "output", 104, 1, 3,"in", 6);

a = Synth.head(2, \echo, [\in, 4, \out, 4, \nodeId, 4]);

s.options.numInputBusChannels

s.sendMsg("/s_new", "kick", x=s.nextNodeID, 0, 1,"out", 4, "amp", 1);


s.sendMsg("/n_free", 101)
s.sendMsg("/g_freeAll", 2)

s.sendMsg("/n_set", 3, "out", 8, "in", 8);
s.sendMsg("/n_set", 2, "out", 4, "in", 4);
~group2.set(\in, 6)
~group2.set(\out, 6)
Synth.new(\kick, [\out, 4, \amp, 1]);
Synth.new(\kick, [\out, 6, \amp, 1]);

s.meter;
s.plotTree;

s.freeAll;
