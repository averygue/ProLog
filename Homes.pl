%
% Homes puzzle
%
% Figure out who lives where based on various clues.
% This problem has simpler clues than the Zebra problem,
% since there's really only one unknown in each case (the
% type of housing), but the either-or type clues require
% using the "or" syntax in Prolog (with ;).
%
% written by mike slattery, nov 1999
% based on a puzzle in "Dandy Lion - Great Chocolate Caper"

% Describe the "fill-in-the-blank" solution
%
homes([home(norm,_),home(alex,_),home(ellen,_),home(opal,_),home(james,_)]).

%
% solution(L) is a predicate which is true if L is a solution
% to the puzzle.
%
% First we bind List to the "solution" template (with blanks)
solution(List) :- homes(List),
	%
	% Then we list the various types of housing - each
	% must occur in the final solution
	%
	member(home(_,mansion),List), member(home(_,duplex),List),
	member(home(_,cottage),List), member(home(_,ranch),List),
	member(home(_,apt),List),
	%
	% Next we write the clues:

	% Alex lives in the mansion or a ranch.
	% The "or" is specified by listing these goals separated
	% by a semicolon ;  If the first goal fails, Prolog will
	% try to satisfy the second goal.
	%
	(member(home(alex,mansion),List); member(home(alex,ranch),List)),

	% Opal doesn't live in a single family dwelling
	% (The single family dwellings would be mansion, cottage,
	% and ranch - we list the others as possibilities)
	(member(home(opal,duplex),List); member(home(opal,apt),List)),

	% Norm lives in a single family dwelling, but not
	% the mansion.
	(member(home(norm,cottage),List); member(home(norm,ranch),List)),

	% Ellen lives in a mansion or a penthouse apartment.
	(member(home(ellen,mansion),List); member(home(ellen,apt),List)),

	% James lives in the duplex.
	member(home(james,duplex),List).