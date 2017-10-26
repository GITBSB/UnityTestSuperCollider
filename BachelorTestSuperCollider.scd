s.boot;

(
SynthDef.new(\soundTest, {
	arg ampHz=4, width=0.5, fund=40, maxPartial=4;
	var sig1, sig2, freq1, freq2, amp1, amp2;
	amp1 = LFPulse.kr(ampHz, 0, 0.12) *0.75;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12) *0.75;
	freq1 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq2 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round(fund);
	freq1 = freq1 * LFPulse.kr(8, add:1);
	freq2 = freq2 * LFPulse.kr(6, add:1);
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);
	sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	sig2 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	Out.ar(0, sig1);
	Out.ar(1, sig2);
}).add;
)



// Test OSC
OSCdef.new(
	\test,
	{
		arg msg;
		[msg].postln;
		~x = Synth.new(\soundTest);

	},
	'/test',
	nil, 57120
);

OSCdef.new(
	\stop,
	{arg msg;
		[msg].postln;
		~x.free;

	},
	'/stop',
	nil, 57120
);




s.quit;

~x.free;



x = Synth.new(\soundTest);
x = Synth.new(\soundTest, [\ampHz, 3.3, \fund, 48, \ampHz, 1]);

x.set(\width, 0.8);
x.set(\fund, 70);
x.set(\ampHz, 5);