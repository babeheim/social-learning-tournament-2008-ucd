%Pseudocode HuntForPrettyGood (pjr)
%The idea of this strategy is to search fairly intensively for a good but not 
%necessarily perfect strategy early in life. Once such a strategy is found,
%exploit it until the environment changes, then search again until another 
%pretty good strategy is found.

%%First hunt for pretty good strategy
%If 0<roundsalive<6
%	If rand > .5
%		Innovate
%	Else
%		Observe
%%Test for environment change or noisy observation
%If maxpayoff in myRepertoire in roundalive < payoff in roundalive -1
%	If rand > .75
%		Innovate
%	Else
%		Observe
%Compute meanpayoff
%%Check to see if myRepertoire contains a pretty good strategy. If yes, Exploit, 
%%if not continue to hunt
%Elseif maxpayoff in myRepertoire > 3*meanpayoff
%	Exploit
%Else 
%	If rand > .75
%		Innovate
%	Else observe	





function [move, myRepertoire] = huntForPrettyGood(roundsAlive, myRepertoire, myHistory) 

sizemyHistory=size(myHistory);
meanPayoff=mean(myRepertoire(2,:));
[maxValue, maxColumn]=max(myRepertoire(2,:));

%%First hunt for pretty good strategy
if roundsAlive < 6
    if rand < .5
        move=-1;
    else
        move=0;
    end
    
elseif maxValue < myHistory(4,sizemyHistory(1,2))
    if rand > .75
        move=-1;
    else
        move=0;
    end
    
elseif maxValue > 3*meanPayoff
    move=myRepertoire(1,maxColumn);
else
    if rand > .75
        move=-1;
    else
        move=0;
    end
end
