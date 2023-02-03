



%starts of the program
main:-

    Branches=[csb, csd, csam, cse, csai, csss], %different branches
    write("####################################################"), nl,
    write("---------------------Welcome-----------------------"),nl,
    write("####################################################"), nl,
    write("     Electives Prediction System for IIIT Delhi      "), nl,nl,

    write("What is your name: "),
    read(Name),
    assert(is_name(Name)),    %assert dynamic fact about input name of the student

    write("Enter the number of semesters successfully completed"),
    read(Count),   %input no.of semesters completed

    I is Count,
    iterate(Name, I,Count,[]), %iterate() will ask user for SGPA for each semester(uses list functionalities)


    nl, write("What is your branch in IIITD: "),nl,
    M is 1, %iterator for list of branches
    printlist(Branches, M), %prints the list of branches available
    read(Branch),
    assert(branch(Name, Branch)), %assert fact about the branch of the student


    write("Have you done any projects(yes:1, no:0) : "),
    read(Option),
    assert(project(Name, Option)),  %asserts fact about the projects done by the student

    write("Further, We would like you to answer a few more questions:)"),nl,

   instructions(Name). %instructions() will prompt user to choose preferred career areas

%to append elements to the list of GPAs
list_append(X,[], [X]).
list_append(X,[H|T],[H|Tt]):- list_append(X,T,Tt).

%to calculate the sum of the elements of the list of GPAs
list_sum([],0).
list_sum([H|T], N1):- list_sum(T,N), N1 is N+H.

%at the end we calculate and print the cgpa of the student for reference
iterate(X, 0,Realcount, List):- nl,write("Your final CGPA is: "),list_sum(List, N), Res is float(N/Realcount), write(Res), assert(list_cgpa(X,List)),!.
%recursion and backtracking to ask and add SGPAs to the list of GPAs
iterate(X, Count,Realcount, List):-
         write("Enter your SGPA in Semester "), write(Count), write(": "),
         read(S1),nl,
         list_append(S1,List,Newlist),
         New_Count is Count-1,
         iterate(X, New_Count, Realcount, Newlist).


%function to print the list of branches
printlist([], M):- nl, assert(no_of_branches(M)).
printlist([H|T], M):- nl,write(M),write("."), write(H), P is M+1,  printlist(T, P).

%function to check whether student has done a project previously
did_project(X):- project(X, Option), Option is 1.

%information about different career paths available to student
instructions(Name):-

    write("Rank your interests in the following future career areas from 1 to 5"),nl,
    write("1 means least interest and 5 means high interest"),nl,
    user_interface(Name).

%Prints the different career paths for the student
user_interface(X):-
    get_interest(X, bio1,"Biological Sciences"), %get_interest(student_name,career_code,title) will ask student about his/her interest in that area
    get_interest(X, bio2,"Mathematical Biology"),
    get_interest(X, math1,"Probabilistic and Statistical Mathematics"),
    get_interest(X, math2, "Maths involving proofs and lemmas"),
    get_interest(X, soc, "Sociology and Anthropology"),
    get_interest(X, psy, "Psychology"),
    get_interest(X, eco, "Economics and Finance"),
    get_interest(X, des, "Design and Video Editing"),
    get_interest(X, cse1, "Algorithms and Computing"),
    get_interest(X, cse2, "Theoretical Computer Science"),
    get_interest(X, cse3, "Machine Learning and AI"),
    get_interest(X, cse4, "Computer Security"),

    marks_instruction,
    (
    (   ask_bio1_marks(X);true),
    (   ask_bio2_marks(X);true),
    (   ask_math1_marks(X);true),
    (   ask_math2_marks(X);true),
    (   ask_soc_marks(X);true),
    (   ask_psy_marks(X);true),
    (   ask_eco_marks(X);true),
    (   ask_des_marks(X);true),
    (   ask_cse1_marks(X);true),

    (   ask_cse2_marks(X);true),
    (   ask_cse3_marks(X);true),
    (   ask_cse4_marks(X);true),!
    ),

    format_electives(X).

%ask student about area of interest
get_interest(X, Interest, Header):-
    write("Do you have interest in: "),nl,
    write(Header),
    read(Rank),
    assert(ilevel(X, Interest, Rank)). %asserts a fact about students interest level in an area

%prompts student to enter marks in the asked courses,
% the courses are chosen keeping in mind the previously entered data
% about the interest of the student in an area
marks_instruction:-
    nl,write("Write your grade(0-10) in the below mentioned courses"),nl,
    write("Write 0 if you haven't done the course"),nl,nl.

% checks if Student X has successfully passed in course "Course" so that
% it can be used as a pre requisite for an elective course.
is_prereq(X, Course):-  grade(X,Course,Y), Y>3.

%gets tehe marks fo the student in a course
get_marks(X, Course, Header):-
    write("What are your marks in: "),nl,
    write(Header),
    read(Grade),
    assert(grade(X, Course, Grade)).


% these functions ask student about his marks in different core courses
% depending on the interest areas he/she has selected
ask_bio1_marks(X):-
         is_interested(X,bio1),get_marks(X,cbb, "Cell Biology and BioChemistry"), get_marks(X,iqb,"Genetics and Molecular Biology"),!.

ask_bio2_marks(X):-
         is_interested(X,bio2),get_marks(X,pb,"Practical Bioinformatics"),
         get_marks(X,iqb,"Quantitative Biology"),!.
ask_math1_marks(X):-
         is_interested(X,math1),get_marks(X,pns,"Probability and Statistics"),
         get_marks(X,la,"Linear Algebra"),!.
ask_math2_marks(X):-
         is_interested(X, math2), (is_prereq(X,la);get_marks(X,la,"Linear Algebra")), get_marks(X,gt,"Graph Theory"), get_marks(X,ra,"Real Analysis"),!.
ask_soc_marks(X):-
         is_interested(X,soc),get_marks(X,sts,"Science Technology and Society"), get_marks(X,its,"Information Technology and Society"),!.
ask_psy_marks(X):-
         is_interested(X,psy),get_marks(X,pss,'Psychology'),!.
ask_eco_marks(X):-
         is_interested(X,eco), get_marks(X,mb,"Money and Banking"), get_marks(X,emt,"Econometrics"),!.
ask_des_marks(X):-
         is_interested(X,des),get_marks(X,hci,"Human Computer Interaction"), get_marks(X,dis,"Design of Interactive Systems"), get_marks(X,pis,"Prototyping Interactive Systems"),!.

ask_cse1_marks(X):-
         is_interested(X, cse1),get_marks(X,dsa, "Data Structures and Algorithms"), get_marks(X,ada,"Design and Analysis of Algorithms"),!.


ask_cse2_marks(X):-
         is_interested(X,cse2),get_marks(X,toc,"Theory of Computation"), get_marks(X,os,"Operating Systems"),!.
ask_cse3_marks(X):-
         is_interested(X,cse3),get_marks(X,dbms, "Database Management Systems"), (is_prereq(X,la);get_marks(X, la, "Linear Algebra")), (is_prereq(X,pns);get_marks(X,pns, "Probability and Statistics")),!.

ask_cse4_marks(X):-
         is_interested(X, cse4),get_marks(X,os,"Operating Systems"), get_marks(X,oops,"Advanced Programming"),!.


% recursive function to track elective courses which student can take
% given the pre requisites,career goals,projects done and branch
advice(X,[],[]):- nl,write("##################################################"),nl,write("See you again, "),write(X) .

advice(X,[H1|T1], [H2|T2]):-


         (take(X,H1,H2);true),advice(X,T1,T2).




% checks if a student is highly interested in a career area(threshold
% here is 4 out of 5)
is_interested(X,Interest):- ilevel(X, Interest, Rank), Rank >= 4.


% prints the course that the student can take depending on all the input
% data
print_advice(X,C,H):-
         nl,write(C),tab(6),write(H),nl,
         assert(can_take(X,C)).


%Gives the student clarity on the electives options they have
format_electives(X):-
         write("You are all set to go for your ideal elective now!!"),nl,
        nl,write(X),nl,write("Based on your inputs, We have finalised the below courses for you"), nl,
        write("COURSE CODE"),tab(6),write("COURSE TITLE"),nl,
        write("########################################################"),
         %advice(student_name,course_codes_of_electives,titles_of_electives) iterates through each elective to find the electives that align with the          pre conditions of the student
         advice(X,
                [bio601,bio544,bio361,bio622,bio510,bio542,bio523,bio555,mth511,mth512,mth513,mth514,mth515,mth333,soc222,soc223,soc224,eco333,eco335,eco336,eco338,eco339,psy222,psy233,des301,des311,des321,des331,cse511,cse512,cse513,cse514,cse521,cse522,cse523,cse524,cse525,cse531,cse532,cse533,cse534,cse535,cse536,cse537,cse541,cse542,cse543],

                ["Foundations of Modern Biology","Computational Gastronomy","Biophysics","Computing for Medicine", "Algorithms in Bioinformatics", "Machine Learning for Biomedical Applications", "Cheminformatics", "Biomedical Image Processing","Topics in Number Theory", "Real Analysis II", "Complex Analysis", "Scientific Computing", "Integral Transforms and their Applications","Stochastic Processes", "Technology and Future of Work","Knowledge andProduction","Gender and Media","Game Theory","Spatial Econometrics","Contract Theory","Microeconomics","Foundations of Finance","Neuroscience of Decision Making", "Cognition of Motor Movement","Design Futures","Digital Audio and Video Production and Workflow","Animation and Graphics","3D Film Making","Introduction to Graduate Algorithms","Modern Algorithm Design","Approximation Algorithms","Information Integration","Computer Graphics","Computer Architecture","Compilers","Distributed Systems","Quantum Mechanics","Digital Image Processing","Artificial Intelligence","Data Mining","Machine Learning","Natural Language Processing","Advanced Machine Learning","Applied Cryptography","Network Security","Foundations of Computer Security","Computer Networks"
 ]).



% Knowledge Base for Elective Courses to be Suggested to the
% Student(Rules to choose different elective courses with pre
% conditions)


take(X,bio544,"Computational Gastronomy"):-branch(X,csb),print_advice(X,bio544,"Computational Gastronomy").

take(X,bio361,"Biophysics"):- is_prereq(X,cbb), is_prereq(X,gmb), branch(X, csb), print_advice(X,bio361,"Biophysics").

take(X, bio601,"Foundations of Modern Biology"):- is_interested(X,bio1),print_advice(X,bio601,"Foundations of Modern Biology").

take(X, bio622,"Computing for Medicine"):- is_prereq(X,pb), is_prereq(X,iqb), print_advice(X,bio622,"Computing for Medicine").

take(X, bio510,"Algorithms in Bioinformatics"):- is_prereq(X,iqb),print_advice(X,bio510,"Algorithms in Bioinformatics").

take(X, bio542,"Machine Learning for Biomedical Applications"):- (is_interested(X,cse3); is_interested(X,bio2)),print_advice(X,bio542,"Machine Learning for Biomedical Applications").

take(X, bio523,"Cheminformatics"):- is_prereq(X,pb),branch(X,csb),print_advice(X,bio523,"Cheminformatics").
take(X, bio555,"Biomedical Image Processing"):- (is_interested(X,cse3); is_interested(X,bio2)), print_advice(X,bio555,"Biomedical Image Processing").

take(X, mth511,"Topics in Number Theory"):- (is_prereq(X,ra); is_prereq(X,gt)), is_prereq(X,la), print_advice(X,mth511, "Topics in Number Theory").

take(X, mth512,"Real Analysis II"):- is_prereq(X, ra), is_prereq(X, la), print_advice(X,mth512,"Real Analysis II").

take(X, mth513,"Complex Analysis"):- is_prereq(X,la), is_prereq(X,pns),print_advice(X,mth513,"Complex Analysis").

take(X, mth514,"Scientific Computing"):- is_interested(X,math1),branch(X,csam),print_advice(X,mth514,"Scientific Computing").

take(X, mth515,"Integral Transforms and their Applications"):- is_interested(X,math2),print_advice(X,mth515,"Integral Transforms and their Applications").

take(X, mth333,"Stochastic Processes"):- is_prereq(X,la), is_prereq(X,pns), print_advice(X,mth333,"Stochastic Processes").

take(X,soc222,"Technology and Future of Work"):- is_interested(X,soc),print_advice(X,soc222,"Technology and Future of Work").

take(X,soc223,"Knowledge Production"):- is_interested(X,soc),print_advice(X,soc223,"Knowledge Production").

take(X,soc224,"Gender and Media"):- is_interested(X,soc),print_advice(X,soc224,"Gender and Media").

take(X,eco333,"Game Theory"):- is_interested(X,eco), print_advice(X,eco333,"Game Theory").

take(X,eco335,"Spatial Econometrics"):- is_prereq(X,emt),print_advice(X,eco335,"Spatial Econometrics").

take(X,eco336,"Contract Theory"):- is_prereq(X,mb), is_prereq(X,emt),print_advice(X,eco336,"Contract Theory").

take(X,eco338,"Microeconomics"):-is_interested(X,eco),print_advice(X,eco338,"Microeconomics").

take(X,eco339,"Foundations of Finance"):- is_interested(X,eco),print_advice(X,eco339,"Foundations of Finance").

take(X,psy222,"Neuroscience of Decision Making"):-is_interested(X,psy),print_advice(X,psy222,"Neuroscience of Decision Making").

take(X,psy233,"Cognition of Motor Movement"):- is_interested(X,psy), print_advice(X,psy233,"Cognition of Motor Movement").

take(X,des301,"Design Futures"):- is_prereq(X,hci),print_advice(X,des301,"Design Futures").

take(X,des311,"Digital Audio and Video Production and Workflow"):- is_prereq(X,hci),print_advice(X,des311,"Digital Audio and Video Production and Workflow").

take(X,des321,"Animation and Graphics"):- is_prereq(X,pis),print_advice(X,des321,"Animation and Graphics").

take(X,des331,"3D Film Making"):- is_prereq(X,dis),is_prereq(X,hci),branch(X,csd),print_advice(X,des331,"3D Film Making").

take(X,cse511,"Introduction to Graduate Algorithms"):- is_prereq(X,ada),is_prereq(X,dsa),print_advice(X,cse511,"Introduction to Graduate Algorithms").
take(X,cse512,"Modern Algorithm Design"):- is_prereq(X,dsa), print_advice(X,cse512,"Modern Algorithm Design").

take(X,cse513,"Approximation Algorithms"):- is_prereq(X,dsa),print_advice(X,cse513,"Approximation Algorithms").

take(X,cse514,"Information Integration"):- is_interested(X,cse1),print_advice(X,cse514,"Information Integration").

take(X,cse521,"Computer Graphics"):- is_interested(X,cse2),print_advice(X,cse521,"Computer Graphics").

take(X,cse522,"Computer Architecture"):- is_prereq(X,os),did_project(X),print_advice(X,cse522,"Computer Architecture").

take(X,cse523,"Compilers"):- is_prereq(X,os),print_advice(X,cse523,"Compilers").

take(X,cse524,"Distributed Systems"):- is_prereq(X,toc),print_advice(X,cse524,"Distributed Systems").

take(X,cse525,"Quantum Mechanics"):- is_prereq(X,toc),did_project(X),print_advice(X,cse525,"Quantum Mechanics").

take(X,cse531,"Digital Image Processing"):- is_interested(X,cse3),is_prereq(X,la), is_prereq(X,pns), print_advice(X,cse531,"Digital Image Processing").

take(X,cse532,"Artificial Intelligence"):- is_interested(X,cse3),is_prereq(X,la),did_project(X),print_advice(X,cse532,"Artificial Intelligence").

take(X,cse533,"Data Mining"):- is_interested(X,cse3),is_prereq(X, la),print_advice(X,cse533,"Data Mining").

take(X,cse534,"Machine Learning"):- is_interested(X,cse3),is_prereq(X,la),did_project(X),branch(X,cse),print_advice(X,cse534,"Machine Learning").

take(X,cse535,"Natural Language Processing"):- is_interested(X,cse3),is_prereq(X,dbms), did_project(X),print_advice(X,cse535,"Natural Language Processing").

take(X,cse536,"Advanced Machine Learning"):- is_interested(X,cse3),is_prereq(X,cse534),print_advice(X,cse536,"Advanced Machine Learning").

take(X,cse537,"Applied Cryptography"):- is_interested(X,cse3),is_prereq(X,la), print_advice(X,cse537,"Applied Cryptography").

take(X,cse541,"Network Security"):- is_interested(X,cse4),did_project(X),print_advice(X,cse541,"Network Security").

take(X, cse542,"Foundations of Computer Security"):- is_interested(X,cse4),did_project(X),print_advice(X,cse542,"Foundations of Computer Security").

take(X,cse543,"Computer Networks"):- is_prereq(X,oops),print_advice(X,cse543,"Computer Networks").























