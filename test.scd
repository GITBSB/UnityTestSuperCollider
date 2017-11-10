

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



a = Synth.new(\echo, [\in, 25, \out, 25]);
b = Synth.new(\reverb, [\in, 25, \out, 25]);
c = Synth.new(\distort, [\in, 25, \out, 25]);

y = Synth.new(\output, [\in, 25]);
x = Synth.new(\kick, [\out, 25, \amp, 1]);
c.free;



d=Synth.new(\bass_Ex );


b = NetAddr.new("127.0.0.1", 7777);    // create the NetAddr
b.sendMsg("/hello", "there");    // send the application the message "hello" with the parameter "there"





s.meter;
s.plotTree;

s.freeAll;



(