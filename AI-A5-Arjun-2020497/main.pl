

%starts of the program
main:-
    consult("C:/Users/dell/Dropbox/My PC (DESKTOP-DKG8LHI)/Documents/Prolog/Sample_codes/facts.pl"),
    Branches=[csb, csd, csam, cse, csai, csss], %different branches
    write("####################################################"), nl,
    write("---------------------Welcome-----------------------"),nl,
    write("####################################################"), nl,
    write("     Electives Prediction System for IIIT Delhi      "), nl,nl,
  

   format_electives(). %instructions() will prompt user to choose preferred career areas




%function to print the list of branches
printlist([], M):- nl, assert(no_of_branches(M)).
printlist([H|T], M):- nl,write(M),write("."), write(H), P is M+1,  printlist(T, P).






% recursive function to track elective courses which student can take
% given the career goals,projects done and branch
advice([],[]):- nl,write("##################################################"),nl,write("See you again, ") .

advice([H1|T1], [H2|T2]):-


         (take(H1,H2);true),advice(T1,T2).




% prints the course that the student can take depending on all the input
% data
print_advice(C,H):-
         nl,write(C),tab(6),write(H),nl.
         


%Gives the student clarity on the electives options they have
format_electives():-
         write("You are all set to go for your ideal elective now!!"),nl,
        nl,write("Based on your inputs, We have finalised the below courses for you"), nl,
        write("COURSE CODE"),tab(6),write("COURSE TITLE"),nl,
        write("########################################################"),
         %advice(student_name,course_codes_of_electives,titles_of_electives) iterates through each elective to find the electives that align with the pre conditions of the student
         advice(
                [bio601,bio544,bio361,bio622,bio510,bio542,bio523,bio555,mth511,mth512,mth513,mth514,mth515,mth333,soc222,soc223,soc224,eco333,eco335,eco336,eco338,eco339,psy222,psy233,des301,des311,des321,des331,cse511,cse512,cse513,cse514,cse521,cse522,cse523,cse524,cse525,cse531,cse532,cse533,cse534,cse535,cse536,cse537,cse541,cse542,cse543],

                ["Foundations of Modern Biology","Computational Gastronomy","Biophysics","Computing for Medicine", "Algorithms in Bioinformatics", "Machine Learning for Biomedical Applications", "Cheminformatics", "Biomedical Image Processing","Topics in Number Theory", "Real Analysis II", "Complex Analysis", "Scientific Computing", "Integral Transforms and their Applications","Stochastic Processes", "Technology and Future of Work","Knowledge andProduction","Gender and Media","Game Theory","Spatial Econometrics","Contract Theory","Microeconomics","Foundations of Finance","Neuroscience of Decision Making", "Cognition of Motor Movement","Design Futures","Digital Audio and Video Production and Workflow","Animation and Graphics","3D Film Making","Introduction to Graduate Algorithms","Modern Algorithm Design","Approximation Algorithms","Information Integration","Computer Graphics","Computer Architecture","Compilers","Distributed Systems","Quantum Mechanics","Digital Image Processing","Artificial Intelligence","Data Mining","Machine Learning","Natural Language Processing","Advanced Machine Learning","Applied Cryptography","Network Security","Foundations of Computer Security","Computer Networks"
 ]).



% Knowledge Base for Elective Courses to be Suggested to the
% Student(Rules to choose different elective courses with pre
% conditions)


take(bio544,"Computational Gastronomy"):-interest_in(statistics), interest_in(biology), print_advice(bio544,"Computational Gastronomy").

take(bio361,"Biophysics"):-  interest_in(biology),print_advice(bio361,"Biophysics").

take( bio601,"Foundations of Modern Biology"):-done(projects), interest_in(biology),print_advice(bio601,"Foundations of Modern Biology").

take( bio622,"Computing for Medicine"):-  interest_in(statistics), interest_in(biology),print_advice(bio622,"Computing for Medicine").

take( bio510,"Algorithms in Bioinformatics"):- interest_in(biology),print_advice(bio510,"Algorithms in Bioinformatics").

take( bio542,"Machine Learning for Biomedical Applications"):- interest_in(ml), done(projects), interest_in(biology),print_advice(bio542,"Machine Learning for Biomedical Applications").

take( bio523,"Cheminformatics"):- done(projects), interest_in(biology),print_advice(bio523,"Cheminformatics").
take( bio555,"Biomedical Image Processing"):-  interest_in(ml), interest_in(biology),print_advice(bio555,"Biomedical Image Processing").

take( mth511,"Topics in Number Theory"):- interest_in(maths),print_advice(mth511, "Topics in Number Theory").

take( mth512,"Real Analysis II"):- done(projects), interest_in(maths), print_advice(mth512,"Real Analysis II").

take( mth513,"Complex Analysis"):- done(projects), interest_in(maths),print_advice(mth513,"Complex Analysis").

take( mth514,"Scientific Computing"):- interest_in(statistics), print_advice(mth514,"Scientific Computing").

take( mth515,"Integral Transforms and their Applications"):-(interest_in(maths); interest_in(statistics)), print_advice(mth515,"Integral Transforms and their Applications").

take( mth333,"Stochastic Processes"):- done(projects), interest_in(statistics),print_advice(mth333,"Stochastic Processes").

take(soc222,"Technology and Future of Work"):- interest_in(sociology),print_advice(soc222,"Technology and Future of Work").

take(soc223,"Knowledge Production"):- interest_in(sociology),print_advice(soc223,"Knowledge Production").

take(soc224,"Gender and Media"):- interest_in(anthropology),print_advice(soc224,"Gender and Media").

take(eco333,"Game Theory"):- done(projects), interest_in(economics), print_advice(eco333,"Game Theory").

take(eco335,"Spatial Econometrics"):- interest_in(economics),print_advice(eco335,"Spatial Econometrics").

take(eco336,"Contract Theory"):- done(projects), (interest_in(economics) ; interest_in(anthropology)),print_advice(eco336,"Contract Theory").

take(eco338,"Microeconomics"):-interest_in(economics),print_advice(eco338,"Microeconomics").

take(eco339,"Foundations of Finance"):- done(projects), interest_in(economics),print_advice(eco339,"Foundations of Finance").

take(psy222,"Neuroscience of Decision Making"):-interest_in(psychology),print_advice(psy222,"Neuroscience of Decision Making").

take(psy233,"Cognition of Motor Movement"):- interest_in(psychology), print_advice(psy233,"Cognition of Motor Movement").

take(des301,"Design Futures"):- done(projects), interest_in(design),print_advice(des301,"Design Futures").

take(des311,"Digital Audio and Video Production and Workflow"):- interest_in(design),print_advice(des311,"Digital Audio and Video Production and Workflow").

take(des321,"Animation and Graphics"):- interest_in(design),print_advice(des321,"Animation and Graphics").

take(cse511,"Introduction to Graduate Algorithms"):- interest_in(algorithms),print_advice(cse511,"Introduction to Graduate Algorithms").
take(cse512,"Modern Algorithm Design"):- interest_in(algorithms), print_advice(cse512,"Modern Algorithm Design").

take(cse522,"Computer Architecture"):- interest_in(computers), print_advice(cse522,"Computer Architecture").

take(cse523,"Compilers"):- done(projects), interest_in(computers), print_advice(cse523,"Compilers").

take(cse532,"Artificial Intelligence"):- done(projects), interest_in(ai),print_advice(cse532,"Artificial Intelligence").

take(cse533,"Data Mining"):- done(projects), interest_in(ml), print_advice(cse533,"Data Mining").

take(cse534,"Machine Learning"):- done(projects), (interest_in(ml); interest_in(ai)),print_advice(cse534,"Machine Learning").

take(cse535,"Natural Language Processing"):- done(projects), interest_in(ai),print_advice(cse535,"Natural Language Processing").

take(cse536,"Advanced Machine Learning"):- done(projects), interest_in(ml),print_advice(cse536,"Advanced Machine Learning").

take(cse541,"Network Security"):- interest_in(security),print_advice(cse541,"Network Security").

take( cse542,"Foundations of Computer Security"):- done(projects), interest_in(security),print_advice(cse542,"Foundations of Computer Security").

take(cse543,"Computer Networks"):- interest_in(security),print_advice(cse543,"Computer Networks").






















