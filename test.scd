s.reboot;

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


b = NetAddr.new("127.0.0.1", 7777);    // create the NetAddr
b.sendMsg("/hello", "there");    // send the application the message "hello" with the parameter "there"

Group.new()
Synth.head(~group2, \reverb, [\in, ~bus2, \out, ~bus2]);

~bus1 = Bus.audio(s, 2);
~bus2 = Bus.audio(s, 2);


~group1 = Group.new;
~group2 = Group.new;



s.sendMsg("/g_new", 500);
s.sendMsg("/s_new", "\moogff", 100, 0, 1, "in", ~bus1, "out", ~bus1);
s.sendMsg("/s_new", "\output", 101, 1, 1002, "in", ~bus1);

s.sendMsg("/g_new", 501, 0, 1);
s.sendMsg("/s_new", "\echo", 110, 0, 501, "in", ~bus2, "out", ~bus2);
s.sendMsg("/s_new", "\output", 111, 1, 501, "in", ~bus2);

Synth.new(\kick, [\out, 4, \amp, 1]);

Synth.tail(2, \output, [\in, 4]);

s.sendMsg("/d_load", "reverb");

s.sendMsg("/n_free", 1024);

s.meter;
s.plotTree;


s.options.numInputBusChannels;
s.options.numOutputBusChannels;
s.options.numAudioBusChannels;
s.options.numControlBusChannels;

s.freeAll;



(
SynthDef("help-SinOsc", { arg freq=440, out;
    Out.ar(out, SinOsc.ar(freq, 0, 0.1))
}).add;

SynthDef("help-XOut", { arg out=0, xFade=1;
    var source;
        source = PinkNoise.ar(0.05);

        // write to the bus, crossfading with previous contents
        XOut.ar(out, xFade, source);

}).add;
)

Synth("help-SinOsc", [\freq, 500]);
a = Synth.tail(s, "help-XOut");


a.set(\xFade, 0.7);
a.set(\xFade, 0.4);
a.set(\xFade, 0.0);






(
SynthDef.new(\moogff, {
	arg in, out;
	var sig;
	sig = In.ar(in, 2);
	sig = MoogFF.ar(sig);
	Out.ar(out, sig);
}).add;
)


(
x = {
    MoogFF.ar(
        Pulse.ar([40,121], [0.3,0.7]),
        SinOsc.kr(LFNoise0.kr(0.42).range(0.001, 2.2)).range(30, 4200),
        0.83 * 4)}.play(s);
)

x.free;
