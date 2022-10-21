	mtype {MSG, ACK};
	chan toDonor = [1] of {mtype, bit};
	chan toController = [1] of {mtype, bit};
	
	proctype Donor(chan in, out)
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
	
	proctype Controller(chan in, out)
	{
		bit recvbit;
		do
		:: in ? MSG(recvbit) -> 
		   out ! ACK(recvbit);	
		od
	}
	
	init
	{
		run Donor(toDonor, toController);
		run Controller(toController, toDonor);
	}
