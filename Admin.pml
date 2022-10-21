mtype {MSG, ACK};
chan toAdmin = [1] of {mtype, bit};
chan toDatabase = [1] of {mtype, bit};

proctype Admin(chan in, out)
{
	bit sendbit, recvbit;
	do
	:: out ! MSG, sendbit ->
		in ? ACK, recvbit;
		if
		:: recvbit == sendbit ->
			sendbit = 1-sendbit;
		:: else
		fi
	od
}

proctype Database(chan in, out)
{
	bit recvbit;
	do
	:: in ? MSG(recvbit) -> 
	   out ! ACK(recvbit);	
	od
}

init
{
	run Admin(toAdmin, toDatabase);
	run Database(toDatabase, toAdmin);
}
