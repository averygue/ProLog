%Logic Puzzle: Starting with second
%Avery Guethinig and Michael Fuss %
% Cosc3410 Mike Slattery %
option2 :-
	courses(Courses),

	member(course(artificialIntelligence,_, _, _), Courses),
	member(course(compilers,_, _, _), Courses),
	member(course(operatingSystems, _, _, _), Courses),
	member(course(hardware, _, _, _), Courses),

	%1. Artificial Intelligence is taught in Room 310.
	member(course(artificialIntelligence, 310, _, _), Courses),

	%2. The Hardware teacher uses a video projector.
	member(course(hardware, _, _, videoProjector), Courses),

	% 3. Ms. Saunders teaches in Room 001.
	member(course(_, 001, saunders, _), Courses),

	% 4. The Compilers class meets in the hour before the class in Room 126.
	right_of(course(_,126,_,_), course(compilers,_,_,_), Courses),

	% 5. The course in Room 001 uses clickers.
	member(course(_, 001, _, clickers), Courses),

	% 6. Mr. Shariar uses the whiteboard.
	member(course(_, _, shariar, whiteboard), Courses),

	%7. Ms. Cheng teaches the hour before Operating Systems is taught.
	right_of(course(operatingSystems,_,_,_), course(_,_,cheng,_), Courses),
	%8. Room 112 holds a class at 11:00AM.
	Courses = [_, _, course(_, 112, _, _), _],
	%9. Mr. Adams teaches in Room 126.
	member(course(_, 126, adams, _), Courses),
	%10. A podium is used in the class at 9:00AM.
	Courses = [course(_,_, _,podium), _, _, _],
	print_courses(Courses).


courses([
	course(_, _, _, _),
	course(_, _, _, _),
	course(_, _, _, _),
	course(_, _, _, _)
]).

right_of(A, B, [B, A | _]).
right_of(A, B, [_ | Y]) :- right_of(A, B, Y).

print_courses([A|B]) :- !,
	write(A), nl,
	print_courses(B).
print_courses([]).

:- initialization(option2).


% First puzzle setup
order([eat(namoi,_),eat(salim,_),eat(edward,_),eat(joan,_)]).

% Call Solution to run.
solution(List) :- order(List),

member(eat(_,pizza),List), member(eat(_,tacos),List),
member(eat(_,salad),List), member(eat(_,burgers),List),


% Naomi no pizza or burgers
	(member(eat(namoi,salad),List); member(eat(namoi,tacos),List)),

%  Salim no salads
	(member(eat(salim,pizza),List); member(eat(salim,burgers),List); member(eat(salim,tacos),List)),

%  Edward tacos
	(member(eat(edward,tacos),List)),

% Joan no pizza
	(member(eat(joan,tacos),List); member(eat(joan,burgers),List); member(eat(joan,salad),List)).
