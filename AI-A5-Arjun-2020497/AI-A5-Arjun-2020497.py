
#import libraries 
import nltk
nltk.download('punkt')
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from nltk.tokenize import word_tokenize
from nltk.stem import PorterStemmer
from pyswip import Prolog

#career paths used to determine electives in prolog file(used as facts)
career_paths = ['security', 'algorithms','computers', 'maths','statistics', 'ml', 'design',
          'biology', 'anthropology', 'psychology', 'economics','ai','sociology','projects']

#store the stemmed career paths
stemmed_facts=[]
#store the stemmed tokens of the input text
stemmed_tokens=[]

#function to read the input file. returns the text
def read_file(path):
    readFile= open(path, 'r')
    text = readFile.read()
    readFile.close()
    return text

#implements stemming on the tokens
def stemming(career_paths,stemmed_facts):   
  ps = PorterStemmer()
  for c in career_paths:
    stem = ps.stem(c)
    stemmed_facts.append(stem)
  
#tokenises the input data in 'input.txt'   
def tokenise(data):
    token=word_tokenize(data)
    print("\nTokenised input data: \n",token)  
    return token

#checks for common stems in career_paths and appends the career_paths to roots for annotation
def check_common_stems(stemmed_facts, stemmed_tokens):
  roots=[]  
  for stem in stemmed_tokens:
    for i in range(len(career_paths)):
        if(stem == stemmed_facts[i]):
            roots.append(career_paths[i])
  return roots          

#store tokens related to the branches 
def check_for_branch(tokens):
    
 if('stream' in tokens):
    if 'csb' in tokens:
        tokens.append('biology')
    elif 'csd' in tokens:
        tokens.append('design')
    elif 'csai' in tokens:
        tokens.append('ai')
    elif 'cse' in tokens:
        tokens.append('algorithms')
    elif 'csss' in tokens:
        tokens.append('sociology')
        tokens.append('economics')
    elif 'csam' in tokens:
        tokens.append('math')

# handle special cases (processing multiple keywords in input data) 
def complex_cases(tokens): 
  if('theoretical' in tokens):
    if('computer' in tokens):
      tokens.append("computers")
    if('maths' in tokens or 'math' in tokens):
      tokens.append("statistics")  

############################################
#start here
############################################

#retract all previous facts 
f=open('facts.pl','w')
f.write("")
f.close()
text=input("\nEnter information about your interests, stream and projects: \n")
stemming(career_paths, stemmed_facts)
print("\nStemmed career paths: \n",stemmed_facts) 
# text=read_file('input.txt')
tokens=tokenise(text)
check_for_branch(tokens)
complex_cases(tokens)
stemming(tokens, stemmed_tokens)
print("\nStemmed tokens: \n",stemmed_tokens) 
roots=check_common_stems(stemmed_facts, stemmed_tokens)

#duplicate handling
roots = list(set(roots))
print("\nFiltered root words: \n", roots)



#storing facts in facts.pl 
for i in range(len(roots)):
  if(roots[i] == 'projects'):
    tagstring="done("+roots[i]+").\n"
  else:
    tagstring="interest_in("+roots[i]+").\n"
  f = open('facts.pl', 'a')
  f.write(tagstring)
 
f.close() 







