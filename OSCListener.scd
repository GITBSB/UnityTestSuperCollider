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
		Synth.new(msg[1], Array.with( msg[2].asSymbol, msg[3],msg[4].asSymbol , msg[5]));
	};
	if(msg[0] == '/group.add') {
		g = Group.new;
		u.sendMsg("/group.nodeID", g.nodeID);
	};
	if(msg[0] == '/group.delete') {
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



/* TODO:


Effekte hinzufügen von Unity
zurücksenden zu Unity möglich? um z.B. node-id von gruppe speichern
