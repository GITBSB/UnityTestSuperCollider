(
Server.local.waitForBoot({

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


	SynthDef.new(\pattern_Ex, { arg out, freq = 300, gate = 1, pan = 0, cut = 4000, rez = 0.8, amp = 1;
		Out.ar(out,
			Pan2.ar(
				RLPF.ar(
					Pulse.ar(freq,0.05),
					cut, rez),
				pan) * EnvGen.kr(Env.linen(0.01, 0.5, 0.3), gate, amp, doneAction: 2);
		)
	}).add;


	// bus drum
	SynthDef(\bd, {
		arg amp=1, pre=0.001, dec=0.05;
		var sig, env;
		env = EnvGen.kr(
			Env.new(
				[0.001, 1, 0.001],
				[pre, dec],
				\exponential),
			doneAction:2);
		sig = SinOsc.ar(150, [0,0], amp);
		sig = sig*env;
		Out.ar(0,sig);
	}).add;


	//hi-hat
	SynthDef(\hh, {
		arg amp=1, lpf=13000, hpf=4000, dec=0.13, pre=0.01;
		var sig, env;
		env = EnvGen.kr(
			Env.new(
				[0.001,1,0.001],
				[pre,dec],
				\exponential),
			doneAction:2);
		sig = WhiteNoise.ar([amp, amp]);
		sig = LPF.ar(sig, lpf);
		sig = HPF.ar(sig, hpf);
		sig = sig * env;
		Out.ar(0, sig);
	}).add;



	SynthDef(\varsaw, {
		arg freq=440, decay=0.1, amp=1, len=1.075, width = 0.5, lpf=10000, hpf=10;
		var sig, env;
		env= EnvGen.kr(
			Env.new(
				[0.001,1,decay,0.001],
				[0.025, len-0.025,0.02]*(1/5),
				\exponential),
			doneAction:2);
		sig = VarSaw.ar(freq, [0,0], width, amp);
		sig = HPF.ar(sig, hpf);
		sig = LPF.ar(sig, lpf);
		sig = sig *env;
		Out.ar(0, sig);
	}).add;
})

)
d=Synth.new(\hh, [\dec, 0.1, \pre,0.01, \lpf, 17000]);
d=Synth.new(\bd, [\dec, 0.05, \pre,0.00001]);
d=Synth.new(\varsaw, [\freq, 200, \decay, 0.5, \width, 0.5]);

d=Synth.new(\petalsOfResonance)

d=Synth.new(\bass_Ex, [\out, 0, \freq, 200, \rez, 1, \amp, 1]);


/*
(
SynthDef(\effecttemplate,{
	arg in, out, amp=1,
	atk=0.02, rel=0.1, crv=-2, gate=1;
	var sig, env, source;
	env = EnvGEn.ar(Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(in);
	sig = FX(source);
	Out.ar.(out, sig*amp*env);
}).add;
)
*/

(
SynthDef(\GVerb,{
	arg in, out, amp=1,
	atk=0.02, rel=0.1, crv=-2, gate=1,
	roomsize = 10, revtime = 3, damping=0.5 /* 0-1 */, inputbw = 0.5 /* 0-1 */, spread = 15, drylevel = 1, earlyreflevel = 0.7, taillevel = 0.5, maxroomsize = 300, mul = 1, add = 0;
	var sig, env, source;
	env = EnvGEn.ar(Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(in);
	sig = GVerb.ar(in, roomsize, revtime, damping, inputbw, spread, drylevel, earlyreflevel, taillevel, maxroomsize, mul, add);
	Out.ar.(out, sig*amp*env);
}).add;
)

(
SynthDef(\FreeVerb,{
	arg in, out, amp=1,
	atk=0.02, rel=0.1, crv=-2, gate=1,
	mix = 0.33, room = 0.5, damp = 0.5, mul = 1, add = 0;
	var sig, env, source;
	env = EnvGEn.ar(Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(in);
	sig = FreeVerb.ar(in, mix, room, damp, mul, add)
	Out.ar.(out, sig*amp*env);
}).add;
)

(
SynthDef(\LowPass,{
	arg in, out, amp=1,
	atk=0.02, rel=0.1, crv=-2, gate=1;
	var sig, env, source;
	env = EnvGEn.ar(Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(in);
	sig = FX(source);
	Out.ar.(out, sig*amp*env);
}).add;
)

(
SynthDef(\RHPF,{
	arg in, out, amp=1,
	atk=0.02, rel=0.1, crv=-2, gate=1,
	freq=440, rq=1, mul=1, add=0;
	var sig, env, source;
	env = EnvGEn.ar(Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(in);
	sig = RHPF.ar(in, freq, rq, mul, add);
	Out.ar.(out, sig*amp*env);
}).add;
)

(
SynthDef(\RLPF,{
	arg in, out, amp=1,
	atk=0.02, rel=0.1, crv=-2, gate=1,
	freq=440, rq=1, mul=1, add=0;
	var sig, env, source;
	env = EnvGEn.ar(Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(in);
	sig = RLPF.ar(in, freq, rq, mul, add);
	Out.ar.(out, sig*amp*env);
}).add;
)

(
SynthDef(\BPF,{
	arg in, out, amp=1,
	atk=0.02, rel=0.1, crv=-2, gate=1,
	freq=440, rq=1, mul=1, add=0;
	var sig, env, source;
	env = EnvGEn.ar(Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(in);
	sig = BPF.ar(in, freq, rq, mul, add);
	Out.ar.(out, sig*amp*env);
}).add;
)

(
SynthDef(\HPF,{
	arg in, out, amp=1,
	atk=0.02, rel=0.1, crv=-2, gate=1,
	freq=440, mul=1, add=0;
	var sig, env, source;
	env = EnvGEn.ar(Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(in);
	sig = HPF.ar(in, freq, mul, add);
	Out.ar.(out, sig*amp*env);
}).add;
)

(
SynthDef(\LPF,{
	arg in, out, amp=1,
	atk=0.02, rel=0.1, crv=-2, gate=1,
	freq=440, mul=1, add=0;
	var sig, env, source;
	env = EnvGEn.ar(Env.asr(atk, 1, rel, crv), gate );
	source = In.ar(in);
	sig = HPF.ar(in, freq, mul, add);
	Out.ar.(out, sig*amp*env);
}).add;
)



(

    ///////////////////////////////////////
   ////                              /////
  ////    \petalsOfResonance        /////
 ////                              /////
///////////////////////////////////////
SynthDef("petalsOfResonance", {
	arg masteramp= -6, inamp=0.0, ibs=0, obs=0, kbs, fund=200, firstPartial=2, bank2MidiOffset=0.25, spread=0.33, ringL1=7.75, ringL2=9.5;
	var	pAmp, partialTunedA, partialTunedB, input, output, rms, outArrayA, outArrayA1, outArrayA2, outArray, ltdOutput, masterEnv, finalOut,
	p1a, p2a, p3a, p4a, p5a, p6a, p7a, p8a, p9a, p10a, p11a, p12a, p13a,
	p1b, p2b, p3b, p4b, p5b, p6b, p7b, p8b, p9b, p10b, p11b, p12b, p13b,
	resA1, resA2, resA3, resA4, resA5, resA6, resA7, resA8, resA9, resA10, resA11, resA12, resA13,
	resB1, resB2, resB3, resB4, resB5, resB6, resB7, resB8, resB9, resB10, resB11, resB12, resB13;

	pAmp = -40.dbamp;

	//Two functions to create two sets of partials
	partialTunedA = 	{
		arg partialNum;
		var freq, freqMidi, tuner, freqTunedMidi, freqTuned;
		//firstPartial allows you to start the series at a higher partial than the fund
		//the fund and spread work together (maybe redundantly)
		//to determine the space between each partial
		freq = fund *( firstPartial + (spread*partialNum) );
		freqMidi = freq.cpsmidi;
		//constantly shifting tuner for each partial
		//so the sound is constantly shifting
		tuner = SinOsc.kr(rrand(0.07, 0.013), 0, 0.5);
		freqTunedMidi = freqMidi + tuner;
		freqTuned = freqTunedMidi.midicps;
	};

	partialTunedB = 	{
		arg partialNum;
		var freq, freqMidi, tuner, freqTunedMidi, freqTuned;
		freq = fund *( firstPartial + (spread*partialNum) );
		freqMidi = freq.cpsmidi;
		tuner = SinOsc.kr(rrand(0.07, 0.013), 0, 0.5);
		freqTunedMidi = freqMidi + tuner + bank2MidiOffset;
		freqTuned = freqTunedMidi.midicps;
	};

	p1a= partialTunedA.value(0);
	p2a= partialTunedA.value(1);
	p3a= partialTunedA.value(2);
	p4a= partialTunedA.value(3);
	p5a= partialTunedA.value(4);
	p6a= partialTunedA.value(5);
	p7a= partialTunedA.value(6);
	p8a= partialTunedA.value(7);
	p9a= partialTunedA.value(8);
	p10a= partialTunedA.value(9);
	p11a= partialTunedA.value(10);
	p12a= partialTunedA.value(11);
	p13a= partialTunedA.value(12);

	p1b= partialTunedB.value(0);
	p2b= partialTunedB.value(1);
	p3b= partialTunedB.value(2);
	p4b= partialTunedB.value(3);
	p5b= partialTunedB.value(4);
	p6b= partialTunedB.value(5);
	p7b= partialTunedB.value(6);
	p8b= partialTunedB.value(7);
	p9b= partialTunedB.value(8);
	p10b= partialTunedB.value(9);
	p11b= partialTunedB.value(10);
	p12b= partialTunedB.value(11);
	p13b= partialTunedB.value(12);

	input = In.ar(ibs);
	input =  input * inamp.dbamp;

	//Form 13 resonators for each bank/spectrum
	resA1 = DynKlank.ar(`[[p1a], nil, [rrand(ringL1, ringL2)]], input);
	resA2 = DynKlank.ar(`[[p2a], nil, [rrand(ringL1, ringL2)]], input);
	resA3 = DynKlank.ar(`[[p3a], nil, [rrand(ringL1, ringL2)]], input);
	resA4 = DynKlank.ar(`[[p4a], nil, [rrand(ringL1, ringL2)]], input);
	resA5 = DynKlank.ar(`[[p5a], nil, [rrand(ringL1, ringL2)]], input);
	resA6 = DynKlank.ar(`[[p6a], nil, [rrand(ringL1, ringL2)]], input);
	resA7 = DynKlank.ar(`[[p7a], nil, [rrand(ringL1, ringL2)]], input);
	resA8 = DynKlank.ar(`[[p8a], nil, [rrand(ringL1, ringL2)]], input);
	resA9 = DynKlank.ar(`[[p9a], nil, [rrand(ringL1, ringL2)]], input);
	resA10 = DynKlank.ar(`[[p10a], nil, [rrand(ringL1, ringL2)]], input);
	resA11 = DynKlank.ar(`[[p11a], nil, [rrand(ringL1, ringL2)]], input);
	resA12 = DynKlank.ar(`[[p12a], nil, [rrand(ringL1, ringL2)]], input);
	resA13 = DynKlank.ar(`[[p13a], nil, [rrand(ringL1, ringL2)]], input);

	resB1 = DynKlank.ar(`[[p1b], nil, [rrand(ringL1, ringL2)]], input);
	resB2 = DynKlank.ar(`[[p2b], nil, [rrand(ringL1, ringL2)]], input);
	resB3 = DynKlank.ar(`[[p3b], nil, [rrand(ringL1, ringL2)]], input);
	resB4 = DynKlank.ar(`[[p4b], nil, [rrand(ringL1, ringL2)]], input);
	resB5 = DynKlank.ar(`[[p5b], nil, [rrand(ringL1, ringL2)]], input);
	resB6 = DynKlank.ar(`[[p6b], nil, [rrand(ringL1, ringL2)]], input);
	resB7 = DynKlank.ar(`[[p7b], nil, [rrand(ringL1, ringL2)]], input);
	resB8 = DynKlank.ar(`[[p8b], nil, [rrand(ringL1, ringL2)]], input);
	resB9 = DynKlank.ar(`[[p9b], nil, [rrand(ringL1, ringL2)]], input);
	resB10 = DynKlank.ar(`[[p10b], nil, [rrand(ringL1, ringL2)]], input);
	resB11 = DynKlank.ar(`[[p11b], nil, [rrand(ringL1, ringL2)]], input);
	resB12 = DynKlank.ar(`[[p12b], nil, [rrand(ringL1, ringL2)]], input);
	resB13 = DynKlank.ar(`[[p13b], nil, [rrand(ringL1, ringL2)]], input);

	//Make an array of resonators and scramble them up
	outArrayA = [ resA1*pAmp, resA2*pAmp, resA3*pAmp, resA4*pAmp, resA5*pAmp, resA6*pAmp, resA7*pAmp, resA8*pAmp, resA9*pAmp, resA10*pAmp,
		resA11*pAmp, resA12*pAmp, resA13*pAmp, resB1*pAmp, resB2*pAmp, resB3*pAmp, resB4*pAmp, resB5*pAmp, resB6*pAmp, resB7*pAmp,
		resB8*pAmp, resB9*pAmp, resB10*pAmp, resB11*pAmp, resB12*pAmp, resB13*pAmp ].scramble;

	//For Stereo or Multichannel
	//outArrayA1 = outArrayA.copyRange(0, (outArrayA.size/2).asInteger);
	//outArrayA2 = outArrayA.copyRange((outArrayA.size/2).asInteger, outArray.size);
	//outArrayA1 = Mix.ar(outArrayA1);
	//outArrayA2 = Mix.ar(outArrayA2);

	//Mixes resonators to a mono channel
	outArrayA = Mix.ar(outArrayA);

	ltdOutput = Limiter.ar(outArrayA, 0.98, 0.01);
	ltdOutput = ltdOutput*masteramp.dbamp;

	rms = Amplitude.kr(ltdOutput).ampdb.linlin(-80.0, 0.0, 0.0, 1.0);
	Out.kr(kbs, rms); //send rms amplitude measure to a control bus

	Out.ar(obs, ltdOutput);

	},
	metadata: (
		specs: (
			masteramp: ControlSpec(-120.0, 18, \lin, default: -6.0, units: "db"),
			inamp: ControlSpec(-120.0, 18, \lin, default: 0.0, units: "db"),
			fund: ControlSpec(20, 20000, \exp, 0, 440, units: " Hz"),
			firstPartial: ControlSpec(0, 99, \lin, default: 0, units: "partial"),
			bank2MidiOffset: ControlSpec(-36.0, 36.0, \lin, default: 0, units: "midioffset"),
			spread: ControlSpec(0, 12, \lin, default: 1, units: "spread"),
			ringL1: ControlSpec(0.1, 49, \lin, default: 5, units: "seconds"),
			ringL2: ControlSpec(0.1, 49, \lin, default: 9, units: "seconds")
		)
	),
	variants:(
	)
).add;
)


//Envgen.ar oder kr????
(
//env 2 rausnehmen und trigger rein, um bestimmte länge zu bekommen
SynthDef(\recipe, {
	arg atk=0.41, rel=6.1, crv=0, lffreq=0.06, detune=0.06, lpfreq=6000, fatk=1.6, frel=7.7, fcrv=0, mix=0.7, rm=0.9, dmp=0.07, len=1, decay=0.3;
	var osc1, osc2, freq1, freq2, env, pitch, amp, sig, lfol, pitch2, fenv;
	fenv = EnvGen.ar(Env.asr(fatk, 1, frel, fcrv));
	lfol = SinOsc.kr(lffreq);
	pitch = \pitch.kr(60, 0.017);
	pitch2 = pitch + (lfol * detune);
	amp = \amp.kr(0.85, 0.017);
	env = EnvGen.ar(Env.asr(atk, 1, rel, crv));
	env2= EnvGen.kr(
			Env.new(
				[0.001,1,decay,0.001],
				[0.025, len-0.025,0.02]*(1/5),
				\exponential),
			doneAction:2);
	freq1 = pitch.midicps;
	freq2 = pitch.midicps;
	osc1 = Saw.ar(freq1);
	osc2 = Saw.ar(freq2);
	sig = Mix.ar([osc1, osc2]);
	sig = RLPF.ar(sig, (lpfreq * fenv) +100);
	Out.ar(0, sig*amp*env*env2);
}).add;
)

(
SynthDef(\synthbass, {
	arg trig=1, atk=0.01, rel=0.07, crv= -6,
	fatk=0.01, fdky=0.14, fsus=0.1, frel=0.07, fcrv=0,
	ffrq1=800, rq1=0.6, dky=0, sus=1, len=1, decay=0.3;
	var freq1, osc1, vol, amp, env, env2,
	osc2, osc3, freq2, freq3,
	sig, pitch, fenv, sigR;
	pitch = \pitch.kr(60, 0.017);
	freq1 = pitch.midicps;
	freq2 = (pitch+0.06).midicps;
	freq3 = (pitch-12).midicps;
	amp = \amp.kr(0.85, 0.04);
	env = EnvGen.ar(Env.adsr(atk, dky, sus, rel, curve:crv), trig);
	env2= EnvGen.kr(
			Env.new(
				[0.001,1,decay,0.001],
				[0.025, len-0.025,0.02]*(1/5),
				\exponential),
			doneAction:2);
	fenv = EnvGen.ar(Env.adsr(fatk, fdky, fsus, frel, curve:fcrv), trig);
	osc1 = Saw.ar(freq1);
	osc2 = Saw.ar(freq2);
	osc3 = SinOsc.ar(freq3);
	sig = Mix.ar([osc1, osc2, osc3]);
	sig = RLPF.ar(sig, (ffrq1*fenv)+80, rq1);
	sig = sig.softclip;
	sigR = DelayC.ar(sig, 0.2, 0.03);
	Out.ar(0, [sig, sigR] * env * amp * env2);
}).add;
)



(
SynthDef(\pad, {
	arg atk=0.3, dur=0.05, rel=0.5,gate=1, crv = -2,
	lffreq1=2, lffreq2=2, lf1lo=0.14, lf1hi=0.20,
	lf2lo=0.74, lf2hi=0.8, detune1= -0.06, detune2 = 0.06, detune3 = -12.06,
	ffreq = 2500;
	var osc1,osc2, osc3;
	var freq1, freq2, freq3;
	var env, sus, sig, amp, pitch, sig2;
	var lfo1, lfo2;
	pitch = \pitch.kr(64, 0.03);
	amp = \amp.kr(0.75, 0.03);
	lfo1 = SinOsc.kr(lffreq1).range(lf1lo, lf1hi);
	lfo2 = SinOsc.kr(lffreq2).range(lf2lo, lf2hi);
	sus = dur-atk;
	env = EnvGen.ar(Env.linen(atk, sus, rel, curve: crv),gate, doneAction:2);
	freq1 = (pitch+detune1).midicps;
	freq2 = (pitch+detune2).midicps;
	freq3 = (pitch+detune3).midicps;
	osc1 = Pulse.ar(freq1, lfo1);
	osc2 = Pulse.ar(freq2, lfo2);
	osc3 = Pulse.ar(freq3, lfo1);
	sig = Mix.ar([osc1*0.33333, osc2*0.33333, osc3*0.33333]);
	sig2 = DelayC.ar(sig, 0.2, 0.05);

	Out.ar(0, [sig, sig2]*env*amp);
}).add;
)

a = Synth(\synthbass);



(
SynthDef( \lead, {
	arg gate=1, atk=0.03, rel=1.5, crv = 0,
	ffreqhi=15000, ffreqlo=100,
	fatk=0.01, fdecay= 1.2, fsusl=0.18, frel=1, fcrv= -2,
	osamp1=0.5, osamp2=0.5, osamp3=1,
	detune1= -0.08, detune2= 0.08, detune3=0.02,
	lfo1w=3, lfo1freq=45, lfo2freq = 6, lfo3freq = 0.1,
	glide=0.7, wtbuf, offset, trig=1, len=0.5, decay= 0.6;
	var osc1, freq1, pitch1;
	var osc2, freq2, pitch2;
	var osc3, freq3, pitch3;
	var pitch, amp;
	var sig, sig2;
	var env, env2, fenv;
	var lfo1, lfo2, lfo3;
	//Envelopes
	env = EnvGen.ar( Env.asr(atk, 1, rel, crv), trig );
	fenv = EnvGen.ar( Env.adsr(fatk, fdecay, fsusl, frel, curve:fcrv), trig );
	env2 = EnvGen.kr(
			Env.new(
				[0.001,1,decay,0.001],
				[0.025, len-0.025,0.02]*(1/5),
				\exponential),
			doneAction:2);
	//lfos
	lfo1 = SinOsc.kr(lfo1freq*fenv);
	lfo2 = SinOsc.kr(lfo2freq);
	lfo3 = SinOsc.kr(lfo3freq);
	//Pitch/Frequency/Amp
	pitch = \pitch.kr(60, glide);
	pitch1 = pitch + (lfo2*detune1);
	pitch2 = pitch + (lfo2*detune2);
	pitch3 = pitch + (lfo3*detune3);
	freq1 = pitch.midicps;
	freq2 = pitch2.midicps;
	freq3 = pitch3.midicps;
	amp = \amp.kr(0.85, 0.017);
	//Oscillators
	osc1 = Saw.ar(freq1);
	osc2 = Saw.ar(freq2);
	osc3  = VOsc3.ar(wtbuf+offset, freq3, freq3+0.37, freq3+0.43, 0.3333);
	//Mix-Filter-Make Stereo
	sig = Mix.ar( [osc1*osamp1, osc2*osamp2, osc3*osamp3] );
	sig = RLPF.ar(sig, (((ffreqhi*fenv)+ffreqlo).cpsmidi+(lfo1*lfo1w)).midicps );
	sig2 = DelayC.ar(sig, 0.2, 0.05);
	Out.ar(0, [sig, sig2]*amp*env*env2);
}).add;
)



(
SynthDef(\bpfsaw, {
	arg atk=2, sus=0, rel=3, ts=1, c1=1, c2=(-1), freq=500, detune=0.02, pan=0, cfhzmin=0.1, cfhzmax=0.1, cfmin=500, cfmax=500, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=1, out=0, decay=0.6, len=1;
	var sig, env, env2;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),doneAction:2);
	env2 = EnvGen.kr(
			Env.new(
				[0.001,1,decay,0.001],
				[0.025, len,0.02]*(1/5),
				\exponential),
			doneAction:2);
	sig = Saw.ar(freq*{LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!2
	);
	sig = BLowShelf.ar(sig,lsf,0.5,ldb);
	sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig*env2*amp;
	Out.ar(out,sig);
}).add;
);

Synth(\bpfsaw, [\freq, 100, \c1, 0.05, \c2, -0.05])

Synth(\lead, [\pitch, 40, \len, 0.4]);


Synth(\synthbass, [\len, 1, \decay, 1, \pitch, 53 , \rel, 111, \amp, 2, \rq1, 1]);

Synth(\recipe, [\len, 0.5, \decay, 1, \pitch, 60, \rel, 111]);

s.freeAll;


env = EnvGen.ar(Env.asr(atk, 1, rel, crv), doneAction:2);

	Env.new(
				[0.001,1,decay,0.001],
				[0.025, len-0.025,0.02]*(1/5),
				\exponential)

EnvGen.kr(Env.linen(0.01, 0.5, 0.3)

env= EnvGen.kr(
			Env.new(
				[0.001,1,decay,0.001],
				[0.025, len-0.025,0.02]*(1/5),
				\exponential),
			doneAction:2);

env = EnvGen.kr(
			Env.new(
				[0.001, 1, 0.001],
				[pre, dec],
				\exponential),
			doneAction:2);