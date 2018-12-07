
%%
% Project 9 
% Avery Guething & Amy Harrigan
% StDis: (student discount) - makes checkout everything 25% off
% Goal: write an Erlang server to help run weepod service.
%  Base code written by mike slattery, dec 2017
%%
-module(weepod).
-export([start/0, send_wait/2]).

start() -> spawn(fun init/0).

init() ->
  put({item, lettuce}, 1.50),
  put({item, cupcake}, 0.75),
  put({item, soup}, 2.35),
  put(cart, []),
  loop().

add_items(Name, Count, []) -> [{Name, Count}];
add_items(Name, Count, [{Name, C}|L]) -> [{Name, C+Count}|L];
add_items(Name, Count, [H|L]) -> [H|add_items(Name, Count, L)].


rems_item(Name, [{Name, _C}]) -> [];
rems_item(Name, [{Name, _C}|L]) -> [L];
rems_item(Name, [H|L]) -> [H|rems_item(Name, L)].


shelf_list() ->
  K = get(),
  [{N,get(E)} || {{item, N}=E, _} <- K].


total([]) -> 0;
total([{Name, Count} | L]) -> Count * get({item,Name}) + total(L).

price_reduce([]) -> 0;
price_reduce([{Name, Count} | L]) -> Count * get({item,Name}) - (Count * get({item,Name}) * 0.25) + price_reduce(L).


loop() ->
  receive
    {From, {add_item, Name, Price}} ->
        put({item, Name}, Price),
         From ! {self(), ok}, loop();

    {From, show_shelves} ->
          From ! {self(), shelf_list()}, loop();

    {From, show_basket} ->
          From ! {self(), get(cart)}, loop();

     {From, {remove, Name}} ->
           put(cart, rems_item(Name, get(cart))),
           From ! {self(), ok}, loop();

    {From, {choose, Name, Count}} -> 
          put(cart, add_items(Name, Count, get(cart))),
          From ! {self(), ok}, loop();
    {From, checkout} ->
          From ! {self(), total(get(cart))}, loop();
    {From, stdis} ->
          From ! {self(), price_reduce(get(cart))}, loop();
    {From, Other} ->
          From ! {self(), {error, Other}}, loop()
  end.

% core client function
send_wait(Pid, Request) ->
  Pid ! {self(), Request},
  receive
    {Pid, Response} -> Response
  end.