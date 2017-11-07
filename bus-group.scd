s.boot;

(
SynthDef.new(\blip, {
	arg out;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(300, 1200).round(300);
	sig = SinOsc.ar(freq)* 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01, 0.2), trig);
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\event,{
	arg out, freq=180, amp=0.5, pan=0.0;
	var env;
	env = EnvGen.ar(Env([0,1,1,0],[0.01, 1, 2]),  doneAction:2);
	Out.ar(out,  Pan2.ar(Blip.ar(freq) * env * amp, pan))
}).add;
)



(
SynthDef.new(\echo, { arg delay = 0.2, decay = 4;
    var in;
    in = In.ar(0,2);
    // use ReplaceOut to overwrite the previous contents of the bus.
    ReplaceOut.ar(0, CombN.ar(in, 0.5, delay, decay, 1, in));
}).add;
)

(
SynthDef.new(\ReplaceOutHelp, { arg out=0, freq=440;
    var source;
        source = SinOsc.ar(freq, 0, 0.1);

        // write to the bus, replacing previous contents
        ReplaceOut.ar(out, source);

}).add;
)

(
// define an echo effect
SynthDef("echo", { arg delay = 0.2, decay = 4;
    var in;
    in = In.ar(0,2);
    // use ReplaceOut to overwrite the previous contents of the bus.
    ReplaceOut.ar(0, CombN.ar(in, 0.5, delay, decay, 1, in));
}).add;
)


x = Synth.tail(s, "ReplaceOutHelp", [\freq, 500]);
y = Synth.tail(s, "ReplaceOutHelp", [\freq, 600]);
z = Synth.tail(s, "ReplaceOutHelp", [\freq, 700]);

z.free;
y.free;
x.free;



(
SynthDef.new(\reverb, {
	arg in, out=0;
	var sig;
	sig = In.ar(in, 1);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2)!2;
	Out.ar(out, sig);
}).add;
)

~group1 = Group.new;

b = Synth.new(\reverb, [\in, 25]);
a = Synth.new(\blip, [\out, 25]);
c = Synth.new(\event, [\out, 25], ~group1);


~group1.set(\out, 0)

b.free;
a.free;
c.free;


s.meter;

s.quit;