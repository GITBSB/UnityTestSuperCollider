
(
SynthDef.new(\basicsynth,{
    arg freq1 = 440, amp1 = 30,
    freq2 = 150, amp2 = 0.5;

    var osc1, osc2, output;

    osc1 = {SinOsc.ar(freq1) * amp1};
    osc2 = {SinOsc.ar(freq2 + osc1) * amp2};

    // done action added which
    // frees synth once it is finished

    output = osc2 * Line.ar(1, 0, 0.5, doneAction: 2);

    Out.ar(0,
    Pan2.ar(output, 0)
    )

    // store used instead of send so that
    // synth def is caved into the library
}).add;

)

n=Synth(\basicsynth, [\freq1, 440, \amp1, 30, \freq2, 50, \amp1, 0.5])









(
SynthDef('snaredrum', {

var drumosc, filterenv, volenv, drumoutput, snaposc, snapenv, fulloutput;

drumosc = {Pulse.ar(100)};
filterenv = {Line.ar(1, 0, 0.2, doneAction: 0)};
volenv = {Line.ar(1, 0, 0.6, doneAction: 2)};
drumoutput = {LPF.ar(drumosc,(filterenv *1000) + 30)};

snaposc = {BPF.ar(HPF.ar(WhiteNoise.ar(1),500),1500)};
snapenv = {Line.ar(1, 0, 0.2, doneAction: 0)};

fulloutput = (drumoutput * volenv) + (snaposc * snapenv);
//fulloutput = (drumoutput * volenv);

Out.ar(0,
Pan2.ar(fulloutput, 0)
)

}).send(s);
)

t = Synth('snaredrum');



(
SynthDef('clap', {

var claposc, clapenv, clapnoise, clapoutput;

clapnoise = {BPF.ar(LPF.ar(WhiteNoise.ar(1),7500),1500)};
clapenv = {Line.ar(1, 0, 0.6, doneAction: 2)};

clapoutput = {Mix.arFill(7,
{arg i;
EnvGen.ar(
Env.new(
[0,0,1,0],
[0.01 * i,0,0.04]
)
) * clapnoise * 0.5
}
)};

Out.ar(0,
Pan2.ar(clapoutput * clapenv, 0)
)

}).send(s);
)

t = Synth('clap');



(
SynthDef('fullkickdrum', {

	var subosc, subenv, suboutput, clickosc, clickenv, clickoutput;

	subosc = {SinOsc.ar(60)};
	subenv = {Line.ar(1, 0, 1, doneAction: 2)};

	clickosc = {LPF.ar(WhiteNoise.ar(1),1500)};
	clickenv = {Line.ar(1, 0, 0.02)};

	suboutput = (subosc * subenv);
	clickoutput = (clickosc * clickenv);

	Out.ar(0,
		Pan2.ar(suboutput + clickoutput, 0)
	)

}).send(s);
)

t = Synth('fullkickdrum');


(
SynthDef(\event,{ arg freq=240, amp=0.5, pan=0.0;

	var env;

	env = EnvGen.ar( Env([0,1,1,0],[0.01, 1, 2]),  doneAction:2);

	Out.ar(0,  Pan2.ar(Blip.ar(freq) * env * amp, pan))

}).add;

)

(
SynthDef('closedhat', {

    var hatosc, hatenv, hatnoise, hatoutput;

    hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};

    hatosc = {HPF.ar(hatnoise,2000)};
    hatenv = {Line.ar(1, 0, 0.1)};

    hatoutput = (hatosc * hatenv);

    Out.ar(0,
    Pan2.ar(hatoutput, 0)
    )

}).send(s);
)

c = Synth('closedhat');


Synth(\event)

(
n.sendMsg("/synthDef.add", "\openhat", "SynthDef.new(\\openhat, {
    var hatosc, hatenv, hatnoise, hatoutput;

    hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};

    hatosc = {HPF.ar(hatnoise,2000)};
    hatenv = {Line.ar(1, 0, 0.3)};

    hatoutput = (hatosc * hatenv);

    Out.ar(0, Pan2.ar(hatoutput, 0));
    }).add;"

);
)
