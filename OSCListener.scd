s.boot;

(
n = NetAddr("127.0.0.1", 57120);
u = NetAddr.new("127.0.0.1", 7777);    // Unity port for server
)

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
	};
	if(msg[0] == '/group.new') {
		s.sendMsg("/g_new", msg[1], 0, 1);
	};
	if(msg[0] == '/group.new2') {
		g = Group.new;
		u.sendMsg("/group.nodeID", g.nodeID);
	};
	if(msg[0] == '/group.add.effect') {
		s.sendMsg("/s_new", msg[1], msg[2], 0, msg[3], "in", msg[4], "out", msg[4]);
	};
	if(msg[0] == '/group.add.effect2') {
		a = Synth.head(msg[1], msg[2], msg.copyRange(3, msg.size));
		u.sendMsg("/effect.nodeID", a.nodeID);
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
	if(msg[0] == '/recording.start') {
		s.recHeaderFormat = msg[1];
		s.recSampleFormat.postln
	};
	if(msg[0] == '/recording.stop') {
		s.stopRecording;
	};
	if(msg[0] == '/bus.getID') {
		b = Bus.audio(s, 2);
		u.sendMsg("/bus.ID", b.index);

	};
};
thisProcess.addOSCRecvFunc(~f);
)

(
thisProcess.removeOSCRecvFunc(~f);
s.quit
)


s.freeAll;

s.volume.max



/* TODO:

Töne in VR erzeugen -  wie? von Grund auf? vorerst vorgegebene Töne

Synths in Enums speichern, dass man weiß welche zur Verfügung stehen
beim laden von weiterer Datei /d_load oder string in Unity

mp3,.wav buffern und abspielen

weitere Effekte hinzufügen

listen mit vorhandenen gruppen verwalten

master volume implementieren: group 0, -> über digitalen Bus leiten

evtl. Gruppen, Effekte darstellen




NOTE:
Nodemap: store control values(args) and switch fast to them -> an/aus, settings im spiel festlegen/abspeichern und setting andwenden



