(

// increase memory
// s.options.memSize = 8192 * 64;

// increase number of buffers
// s.options.numBuffers = 1024 * 16;

// boot the server
s.boot;

// oscilloscope
// s.scope

Task({
	// wait for server to boot
	3.wait;

	// SuperCollider port
	n = NetAddr("127.0.0.1", 57120);
	// Unity port
	u = NetAddr.new("127.0.0.1", 7777);


	(
		thisProcess.removeOSCRecvFunc(~f);
		~f = { |msg, time, replyAddr, recvPort|
			if(msg[0] != '/status.reply') {
				"At time %s received message % from % on port%\n".postf( time, msg, replyAddr, recvPort )
			};
			if(msg[0] == '/synthDef.play') {
				Synth.new(msg[1], msg.copyRange(2, msg.size));
			};
			if(msg[0] == '/synthDef.create') {
				s.sendMsg("/s_new", msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8]);
			};
			if(msg[0] == '/synthDef.create_2') {
				a = Synth.head(msg[1], msg[2], msg.copyRange(3, msg.size));
				u.sendMsg("/effect.nodeID", a.nodeID);
			};
			if(msg[0] == '/group.create') {
				s.sendMsg("/g_new", msg[1], 0, 1);
			};
			if(msg[0] == '/group.create_2') {
				g = Group.new;
				u.sendMsg("/group.nodeID", g.nodeID);
			};
			if(msg[0] == '/node.set.value') {
				s.sendMsg("/n_set", msg[1], msg[2], msg[3]);
			};
			if(msg[0] == '/node.delete') {
				s.sendMsg("/n_free", msg[1].asNodeID);
			};
			if(msg[0] == '/bus.getID') {
				b = Bus.audio(s, 2);
				b.index.postln;
				u.sendMsg("/bus.ID", b.index);
			};
			if(msg[0] =='/buffer.read') {
				b = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ msg[1]);
				u.sendMsg("/buffer.number", b.bufnum);
			};
			if(msg[0] == '/recording.start') {
				s.recHeaderFormat = msg[1];
				s.recSampleFormat.postln
			};
			if(msg[0] == '/recording.stop') {
				s.stopRecording;
			};
			if(msg[0] == '/exitSuperCollider') {
				s.freeAll;
			}

			// TODO: kill server
		};
		thisProcess.addOSCRecvFunc(~f);
	);

	// load sound and effect synthDefs
	("SynthDefsEffect.scd").loadRelative;
	("SynthDefsSound.scd").loadRelative;

	3.wait;

}).start;
)





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