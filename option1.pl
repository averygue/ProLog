% First puzzle

order([eat(namoi,_),eat(salim,_),eat(edward,_),eat(joan,_)]).

solution(List) :- order(List),

member(eat(naomi,_),List), member(eat(salim,_),List),
member(eat(edward,_),List), member(eat(joan,_),List),


% Naomi no pizza or burgers
	(member(eat(namoi,salad),List); member(eat(namoi,tacos),List)),

%  Salim no salads
	(member(eat(salim,pizza),List); member(eat(salim,burgers),List); member(eat(salim,tacos),List)),

%  Edward no tacos
	(member(eat(edward,pizza),List); member(eat(edward,burgers),List); member(eat(edward,salad),List)),

% Joan no pizza
	(member(eat(joan,tacos),List); member(eat(joan,burgers),List); member(eat(joan,salad),List)).