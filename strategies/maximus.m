
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [move, myRep]=maximus(roundsAlive, myRepertoire, myHistory)



% opportunity cost, discount rate (death rate)
% approximate p_c within a lifetime and discount rate to adjust how much to
% take the opportunity cost; 2% discount rate (interest rate)

% if payoff is low, innovate or exploit to update repitiore, otherwise
% exploit
% approximate p_c, use myHistory and myRepertoire to update the value of p_c



if roundsAlive < 2
    move = -1;
else
% ----- probability of social learning under little or lots of information --------
% little information
if roundsAlive < 10
pay_max = max( myHistory(4,:) );
pay_min = min( myHistory(4,:) );
prLearn = 1/(exp(0.1*(pay_max-pay_min)));
else
% more information
c = 0.1; % probability of an environemntal shift
noRoundsShift = 1/c; % expected number rounds till an environmental shift

% estimate distribution of payoffs
s = std( myRepertoire(2,:) );
m = mean( myRepertoire(2,:) );

% find the expected reliable payoff horizen
b = (roundsAlive - noRoundsShift);
if b>0
    back = b;
else
    back = 1;
end

% we want myRepertoire to have at least one of the rare high payoffs
if max( myHistory(4, back:roundsAlive) ) < m+1.5*s
    prLearn = 1;
else
    prLearn = 0;
end

end

% if learning, Innovate most of the time, Observe sometimes
if prLearn > 0.5
    d = rand(1);
    if d>0.3
        move = -1;
    else
        move = 0;
    end
else
    move = 2;
end% mem = size(myHistory);
% pay_max = max( myHistory(4,:) );
% pay_min = min( myHistory(4,:) );
% prLearn = 1/(exp(a*(pay_max-pay_min)));

end
 myRep=myRepertoire;
end


