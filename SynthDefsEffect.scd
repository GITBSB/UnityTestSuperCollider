
SynthDef.new(\GroupOutput, {
	arg in, out=0, vol=1;
	var sig;
	sig = In.ar(in, 2);
	Out.ar(out, sig * vol);
}).add;
