NB. my own relational algebra library in J

Note 'some examples follow'
p =: torel 'pno,pname; p1,bolt; p2,nut'
'sno,sname' project s
'pno' =&'p1' select 'price' >&0.3 select sp
'city,CiTy;sname,SNAME' rename s
s cross p
)alsa


load 'tables/csv'
filter =: {{ u # ] }}

NB. comma (val) and semicolon (row) to separate values
NB. WARNING: no 'nulls' in torel
torel =: {{~. makenum dltb each > ',' cutopen each ';' cutopen y}}
]s =: torel 'sno,sname,city; s1,magna,hull; s2,budd,ajax; s2,budd,ajax'
]t =: torel 'city,sname,sno; hull,magna,s2; ajax,budd,s2; ajax,budd,s1'
]p =: torel 'pno,pname; p1,bolt; p2,nut; p3,screw'
]sp =: torel 'sno,pno,price; s1,p1,0.5; s1,p2,0.25; s1,p3,0.3; s2,p3,0.4'
]primes =: 0 2 1 { s
]prime1s =: 0 2 1 {"(1) s

NB. project columns from relation
NB. WARNING: project expects names to exist and be correct
NB. */ $ result will give 0 when nothing matched
project =: {{ y {~"(1) I. +/ (',' cutopen x) =/ {."(2) y }}
'sno,sname' project s

NB. select rows from relation
select =: {{ y {~ 0 , 1 + I. , > *./ each u each}. x project y }}
'price' >&0.3 select sp
'pno' =&'p1' select 'price' >&0.3 select sp
'sno' 's1'&= select s
'sno' 's2'&= select s


NB. rename a column to a new name, x has form 'old0,new0;old1,new1;'
NB. length error before on idx due to extra generated dimension (use {.)
rename =: {{ )d
  ]n =: ';' cutopen x 
	]c =: y
	for_i. n do.
		newstr =: }. ',' cutopen > i
		idx =: {. I. ({. ',' cutopen > i) =/  {."(2) c
		f =: {{ ({. y) #~ x u i. # {. y }}
    c =: (}. c) ,~ (idx >f c) , newstr , idx <f c
  end.
}}
'city,CiTy;sname,SNAME' rename s


NB. doesn"t rename if names collide
cross =: {{
]sh =: ((#}.x) * #}.y) , 2 * (#{.y) >. #{.x
(({.x), {.y), a:&~: filter"(1) sh $ ,>(<"(1)}.x) ,"(0)/ <"(1)}.y
}}
s cross p
p cross s


eqcolnames =: /:~@:{.@:[ -: /:~@:{.@:] NB. union-compatible
(s cross p) eqcolnames p cross s
s eqcolnames primes
s eqcolnames prime1s


eqrel =: {{
]primeordx =: (/: {. x) {"(1) }. x [ ordx =:  (/: {. x) {  {. x
]primeordy =: (/: {. y) {"(1) }. y [ ordy =:  (/: {. y) {  {. y
(ordx, /:~ primeordx) *./@:,@:-: ordy, /:~ primeordy
}}

s eqrel s
prime1s eqrel prime1s

s eqrel primes
primes eqrel prime1s

s eqrel 0 0 0 { s
s eqrel p
s eqrel sp


unionrel =: {{ 
assert. x eqcolnames y
~. x, }. y {"(1)~ , I. ({.x) =/ {.y
}}
s unionrel s
s unionrel primes
s unionrel prime1s

s unionrel sp
s unionrel p

diffrel =: {{
assert. x eqcolnames y
b =: y [ a =: x
a =: a {~"(1) , I. ({.b) =/ {.a
b {~ I. b -.@:e. (}. a) {~ I. (}. a) e. }. b
}}
s diffrel t
t diffrel s

dir =: 'C:\Users\Hassan Shabbir\Desktop\'
writerel =: {{ y [ smoutput y writecsv dir,x  }}
readrel =: {{ readcsv dir,y }}
delrel =: {{ ferase dir,y,'.csv' }}
appendrel =: {{
assert. y eqcolnames readcsv dir,x 
x writerel y unionrel~ readrel x   NB. x unionrel y has cols of x
}}

]s =: 's' writerel s
readrel 's'
's' appendrel t
delrel 's'
