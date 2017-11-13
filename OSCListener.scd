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
		//TODO: parse msg related to size
		Synth.new(msg[1], Array.with( msg[2].asSymbol,    msg[3],msg[4].asSymbol , msg[5]));
	};
	if(msg[0] == '/group.new') {
		s.sendMsg("/g_new", msg[1], 0, 1);
		//g = Group.new;
		//u.sendMsg("/group.nodeID", g.nodeID);
	};
	if(msg[0] == '/node.delete') {
		s.sendMsg("/n_free", msg[1].asNodeID);
	};
	if(msg[0] == '/group.add.effect') {
		s.sendMsg("/s_new", msg[1], msg[2], 0, msg[3], "in", msg[4], "out", msg[4]);
	};
	if(msg[0] == '/group.add.output') {
		s.sendMsg("/s_new", "output", msg[0], 1, msg[2], "in", msg[3]);
	};

};
thisProcess.addOSCRecvFunc(~f);
)

(
thisProcess.removeOSCRecvFunc(~f);
s.quit
)


s.freeAll;



/* TODO:


Effekte hinzufügen von Unity
zurücksenden zu Unity möglich? um z.B. node-id von gruppe speichern
