
(
// sound with parameter
SynthDef.new(\bass_Ex, { arg out, freq = 300, gate = 1, pan = 0, cut = 4000, rez = 0.8, amp = 2;
    Out.ar(out,
        Pan2.ar(
            RLPF.ar(
                SinOsc.ar(freq,0.05),
            cut, rez),
        pan) * EnvGen.kr(Env.linen(0.01, 0.5, 0.3), gate, amp, doneAction: 2);
    )
 }).add;
)
d=Synth.new(\bass_Ex );

(
SynthDef.new(\pattern_Ex, { arg out, freq = 300, gate = 1, pan = 0, cut = 4000, rez = 0.8, amp = 1;
    Out.ar(out,
        Pan2.ar(
            RLPF.ar(
                Pulse.ar(freq,0.05),
            cut, rez),
        pan) * EnvGen.kr(Env.linen(0.01, 0.5, 0.3), gate, amp, doneAction: 2);
    )
}).add;
)
d=Synth.new(\pattern_Ex);





s.freeAll;