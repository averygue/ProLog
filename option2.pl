% Second Puzzle
courses([course(_,_,_,_),course(_,_,_,_),course(_,_,_,_),course(_,_,_,_)).

solution(List) :- courses(List),

member(course(hardware,_,_,_),List), member(course(compilers,_,_,_),List),
member(course(operating_Systems,_,_,_),List), course(Artificial_Intelligence,_,_,_),List),

%Artificial_Intelligence @ 9
(member(course(Artificial_Intelligence,001,Sanders,podium),List); member(course(Artificial_Intelligence,310,Cheng,podium),List)),

%operating_Systems @ 10
(member(course(operating_Systems,001,Sanders,clickers),List)), 

%compilers @ 11
(member(course(compilers,001,Sanders,whiteboard),List); member(course(compilers,126,Adams,whiteboard),List)),

%hardware @ 12
member(course(hardware,126,Adams,projector),List)).
