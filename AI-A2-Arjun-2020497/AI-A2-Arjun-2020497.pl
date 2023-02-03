
%starts of the program
:-use_module(library(csv)).
:-use_module(library(lists)).
:-use_module(library(apply)).

%Process the csv data in the form of a 2d list 

get_rows_data(File, Lists):- %Stored in 'Lists'
  csv_read_file(File, Rows, []),
  rows_to_lists(Rows, Lists).

rows_to_lists(Rows, Lists):-
  maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
  Row =.. [row|List].  



main:-
     
    %retract previous facts in the knowledge base 
    retractall(child(_,_,_)),
    retractall(htics(_,_)),
    
    write("####################################################"), nl,
    write("---------------------Welcome-----------------------"),nl,
    write("####################################################"), nl,
    write("   Cities Distance Directory     "), nl,

    write("Source City: "),
    read(Src),
    assert(source(Src)),


    write("Destination City: "),
    read(Dst),
    assert(dest(Dst)),

    write("What algorithm do you wish to test: 1. Depth First Search 2. Best First Search"),
    read(Choice),
    assert(is_choice(Choice)),
    (  
    dfs_menu(Src, Dst, Choice);
    bestfs_menu(Src, Dst, Choice)
    ).



dfs_menu(Src, Dst, Choice):-

              Choice is 1, 
              get_rows_data("roaddistance.csv",List),
              List=[_|Tail], %First element is the CSV header 
              Tail=[Head1|Tail1], %Head1 is the first row, Tail1 is the rest of the table
              write("Algorithm chosen is Depth First Search on source"),  
              process(Head1,Tail1), %preprocessing of data stored in lists to form facts 
              helper_dfs(Src, Dst, [] , Path, 0, Cost), 
              %user message
              nl,nl,write("The Depth First Search path from "),write(Src),write(" to "),write(Dst),write(" is "), write(Path),
              nl,nl,write("Estimated Cost from "),write(Src),write(" to "),write(Dst),write(" is "),write(Cost).

bestfs_menu(Src, Dst, Choice):-
              
              Choice is 2, 
              get_rows_data("roaddistance.csv", List),
              
              List=[_|Tail],
              Tail=[Head1|Tail1],
              write("Algorithm chosen is Best First Search on source"),
              process(Head1,Tail1), 
              bestfs(Src, Dst, Path, 0, Cost),
              %user message 
              nl,nl,write("The Best First Search path from "),write(Src),write(" to "),write(Dst),write(" is "), write(Path),
              nl,nl,write("Estimated Cost from "),write(Src),write(" to "),write(Dst),write(" is "),write(Cost).


%Preprocessing and Storing of csv data as facts

process(_,[]).
process(Head1, Tail1):-
    
    Tail1=[Head2|Tail2], 

    Head1=[_|FirstCol], %head has empty data 
    FirstCol=[_|NeighbourCity], % here head is the first cell of the table 
    Head2=[_|Distances], %head is empty data
    Distances=[CityName|Distance], %CityName is the name of first city in the first column i.e. Ahmedabad
    traverse_and_assert(CityName, NeighbourCity, Distance), %assert facts for each CityName across the row
    process(Head1,Tail2).
    
%helper function for list traversal     
traverse_and_assert(CityName, NeighbourCity, Distances):-
    list_traverse(CityName,NeighbourCity,Distances).

%base case 
list_traverse(_,[H1],[H2]).

%asserting facts about the data stored in the 2d list in the form (city1, city2, distance)
list_traverse(CityName,[H1|T1],[H2|T2]):-
   
    assert(child(CityName,H1,H2)),
    assert(child(H1,CityName,H2)),
    assert(cities(CityName)),
    list_traverse(CityName,T1,T2).


%List operations 

%append a list to another list 
append_list([], L2, L2).    

append_list([X | L1], L2, [X | L3]) :-
    append_list(L1, L2, L3).

% insert an element at the end of a list
insert_end(L, X, NewL) :-
    append_list(L, [X], NewL).

%to find the minimal value in a list
minimal(X,Y,X) :- X < Y.
minimal(X,Y,Y) :- X > Y.

list_min_elem([X],X).
list_min_elem([X,Y|Rest],Mini) :-
   list_min_elem([Y|Rest],MiniRest),
   minimal(X,MiniRest,Mini).    

% Helper Function of DFS

helper_dfs(Cur,Next, L, Path, Cost, NetCost):-
    insert_end(L,Cur,NewList),  %insert the source node in the list 
    dfs(Cur, Next, NewList, Path, Cost, NetCost).

%DFS Function 

dfs(Source,Source,[Source],[Source],0,0). %if Source is Dest

dfs(Cur, Next, L, Path, Cost, NetCost):-

  (
  (
  %Base case 
  child(Cur,Next,Dist),
  insert_end(L,Next,Path),
  NetCost is Cost+Dist,!
  
  );
  (
    %else execute this
    child(Cur, Inter, Dist),
   \+ member(Inter, L),          % avoid the visited nodes
   NewCost is Cost + Dist,
   insert_end(L, Inter, UpdatedList),
   dfs(Inter, Next, UpdatedList, Path, NewCost, NetCost)
  )
  ).

% Best First Search Function

best_first([[Goal|Path]|_], Goal, [Goal|Path]).
best_first([Path|Queue], Goal, FinalPath):-
    extend_and_add(Path, NewPaths, Queue, NewQueue), 
    sorter(NewQueue, NewerQueue),
    best_first(NewerQueue, Goal, FinalPath).
   
%Adds child conections to the Source node in the Queue
extend_and_add([Node|Path], NewPaths, Queue, NewQueue):-
    findall([NewNode, Node|Path],
            (child(Node, NewNode, _), 
            \+ member(NewNode, Path)),
            NewPaths),
    append_list(Queue, NewPaths, NewQueue).        

%Sorts the paths based on heuristic values 

sorter(NewQueue, NewerQueue):-
    swapping(NewQueue, AuxQueue), !,
    sorter(AuxQueue, NewerQueue).
sorter(NewQueue, NewQueue).

%Swapping of data based on heurestic values 

swapping([[A1|B1], [A2|B2]|T], [[A2|B2], [A1|B1]|T]):-
    htics(A1, W1),
    htics(A2, W2),
    W1>W2.
swapping([X|T], [X|V]):-
    swapping(T, V).


%Best First Search : Helping functions 

bestfs(Source, Source,[Source], 0, 0).
bestfs(Source, Dest, Path, InitCost, NetCost):-
    
    findall(X, cities(X), CityDirectory),
    assign_heuristic(Source, CityDirectory, Dest),nl,
    write("Calculated Heuristics from "), write(Source),nl,
    best_first([[Source]], Dest, TempPath),
    reverse(TempPath, Path),
    
    cost_estimator(Path, 0, NetCost).

% returns the heurestic value for the particular city 
comparator(City, Dest, Cost):-
    child(City, Inter, D1),
    child(Inter, Dest, D2),
    Cost is D1 + D2.

% Estimates the cost from Source to Dest for that Path
cost_estimator([A|[B|C]], CurCost, NetCost):-
   ( C==[] ->
    child(A, B, Dist),
    NetCost is CurCost + Dist 
   ); 
   ( child(A, B, Dist),
    NewCost is CurCost + Dist,
    cost_estimator([B|C], NewCost, NetCost)
   ).

% Assigns the heurestics 

assign_heuristic(Source, [], Dest).
assign_heuristic(Source, [H|T], Dest):-
    findall(X, comparator(H, Dest, X), L),
    min_list(L,Min),
    forall(\+ htics(H,Min) , assert(htics(H, Min))),
    assign_heuristic(Source, T, Dest).


