% Second Puzzle
courses([course(_,_,_,_),course(_,_,_,_),course(_,_,_,_),course(_,_,_,_)).

solution(List) :- courses(List),

member(course(hardware,_,_,_),List), member(course(compilers,_,_,_),List),
member(course(operating_Systems,_,_,_),List), course(Artificial_Intelligence,_,_,_),List),

