s.boot;


n = NetAddr("127.0.0.1", 57120);
u = NetAddr.new("127.0.0.1", 7777);    // Unity port for server

(
thisProcess.removeOSCRecvFunc(~f);
~f = { |msg, time, replyAddr, recvPort|
	if(msg[0] != '/status.reply') {
        "At time %s received message % from % on port%\n".postf( time, msg, replyAddr, recvPort )
    };
    if(msg[0] == '/synthDef.add') {
		SynthDef.removeAt(msg[1].asSymbol);
		msg[2].asString.interpret;
	};
	if(msg[0] == '/synthDef.delete') {
		SynthDef.removeAt(msg[1].asSymbol);
	};
	if(msg[0] == '/synthDef.play') {
		Synth.new(msg[1]);
	};
	if(msg[0] == '/synthDef.playWithArg') {
		Synth.new(msg[1], msg.copyRange(2, msg.size));
		//s.sendMsg("/s_new", "kick", x=s.nextNodeID, 0, 1,"out", 6, "amp", 1);
	};
	if(msg[0] == '/group.new') {
		s.sendMsg("/g_new", msg[1], 0, 1);
		//g = Group.new;
		//u.sendMsg("/group.nodeID", g.nodeID);
	};
	if(msg[0] == '/group.add.effect') {
		// TODO: effekte mit mehr args
		// Möglichkeit: Synth.tail(2, \output, [\in, 4]); dann aber nodeId zurücksenden
		// oder Befehl fertig senden und hier mit interpret ausführen
		s.sendMsg("/s_new", msg[1], msg[2], 0, msg[3], Array.with("in", msg[4], "out", msg[4]).asSpec);

	};
	if(msg[0] == '/group.add.output') {
		s.sendMsg("/s_new", "output", msg[1], 1, msg[2], "in", msg[3]);
	};
	if(msg[0] == '/node.set.value') {
		s.sendMsg("/n_set", msg[1], msg[2], msg[3]);
	};
	if(msg[0] == '/node.delete') {
		s.sendMsg("/n_free", msg[1].asNodeID);
	};
};
thisProcess.addOSCRecvFunc(~f);
)

(
thisProcess.removeOSCRecvFunc(~f);
s.quit
)


s.freeAll;

var y, z;
y = [1 , 3 ,4, 5,]
y.postln
y.takeAt(0);
y.postln;

/* TODO:

Effekte hinzufügen von Unity
Töne in VR erzeugen


note:
Nodemap: store control values(args) and switch fast to them -> an/aus, settings im spiel festlegen/abspeichern und setting andwenden


