% First puzzle

order([eat(namoi,_),eat(salim,_),eat(edward,_),eat(joan,_)]).

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