#lang plai
;; Avery Guething
;; Cosc4310
;; Base Code given by MikeS 

;;TJILL value setup
(define-type TJILL
  [num (n number?)]
  [id (name symbol?)]
  [add (lhs TJILL?) (rhs TJILL?)]
  [sub (lhs TJILL?) (rhs TJILL?)]
  [mul (lhs TJILL?) (rhs TJILL?)]
  [div (lhs TJILL?) (rhs TJILL?)]
  [neg (n TJILL?)]
  [equ (lhs TJILL?) (rhs TJILL?)]
  [lt (lhs TJILL?) (rhs TJILL?)]
  [iff (expr TJILL?) (n1 TJILL?) (n2 TJILL?)]
  [fun (arg-name symbol?) (arg-type Type?) (body TJILL?)]
  [app (fun-expr TJILL?) (arg TJILL?)]
)

;;TJILL type tree
(define-type TJILL-Value 
  [numV (n number?)] 
  [closureV (param symbol?) 
            (body TJILL?) 
            (env Env?)])

;;Environment store
(define-type TypeEnv
  [mtTypeSub]
  [aType (id symbol?) (type Type?) (te TypeEnv?)]
)

(define-type Store 
  [mtSto] 
  [aSto (location number?) 
        (value TJILL-Value?) 
        (store Store?)]) 

(define-type Env 
  [mtSub] 
  [aSub (name symbol?) 
        (location number?) ;; bind to a store location
        (env Env?)]) 

;;Slattery's requirement type
(define-type Type
  [numType]
  [boolType]
  [funType (domain Type?)
           (codomain Type?)])



;; store-lookup:location Store -> VFAE-Value 
(define (store-lookup loc-index sto) 
  (type-case Store sto 
             [mtSto ()(error 'store-lookup 
                             "no value at location ~a" loc-index)] 
             [aSto (location value rest-store) 
                   (if (= location loc-index) 
                       value 
                       (store-lookup loc-index rest-store))]))

;;type-lookup: 
(define (type-lookup loc-index sto)
  (type-case TypeEnv sto
    [mtTypeSub () (error 'type-lookup 
                             "no value at location ~a" loc-index)]
    [aType (bound-id bound-type rest-te)
           (if (symbol=? loc-index bound-id)
               bound-type
               (type-lookup loc-index rest-te))]
))
;;checks to see if either func, number, boolean
(define (type-parse sexp)
  (cond [(eq? sexp 'boolean) (boolType)]
        [(eq? sexp 'number) (numType)]
        [(list? sexp) (funType (type-parse (first sexp)) (type-parse (third sexp)))]
))

;;parse sexp--> TTJILL
;; from previous-projects / code
(define (parse sexp)
    (cond [(number? sexp) (num sexp)]
          [(symbol? sexp) (id sexp)]
          [(eq? (first sexp) '+) (if (= (length sexp) 3) (add (parse (second sexp)) (parse (third sexp))) (error 'add "parse + 1"))]
          [(eq? (first sexp) '-) (if (or (= (length sexp) 3) (= (length sexp) 2)) (if (null? (cddr sexp)) (neg (parse (second sexp))) (sub (parse (second sexp)) (parse (third sexp)))) (error 'sub "parse - 2"))]
          [(eq? (first sexp) '*) (if (= (length sexp) 3) (mul (parse (second sexp)) (parse (third sexp))) (error 'mul"parse * 3"))]
          [(eq? (first sexp) '/) (if (= (length sexp) 3) (div (parse (second sexp)) (parse (third sexp))) (error 'div"parse / 4"))]
          [(eq? (first sexp) '=) (if (= (length sexp) 3) (equ (parse (second sexp)) (parse (third sexp))) (error '= "parse = 5"))]
          [(eq? (first sexp) '<) (if (= (length sexp) 3) (lt (parse (second sexp)) (parse (third sexp))) (error '< "parse < 6"))]
          [(eq? (first sexp) 'with) (if (and (= (length sexp) 3) (= (length (second sexp)) 4)) (app (fun (first (second sexp)) (type-parse (third (second sexp))) (parse (third sexp))) (parse (fourth (second sexp)))) (error 'with "parse with 7"))]
          [(eq? (first sexp) 'if) (if (= (length sexp) 4) (iff (parse (second sexp)) (parse (third sexp)) (parse (fourth sexp))) (error 'if "parse iff 8"))]
          [(eq? (first sexp) 'fun) (if (and (= (length sexp) 3) (= (length (second sexp)) 3)) (fun (first (second sexp)) (type-parse (third (second sexp))) (parse (third sexp))) (error 'fun "parse fun 9"))]
          [else (if (= (length sexp) 2) (app (parse (first sexp)) (parse (second sexp))) (error 'app "parse app 10"))]
))
;;Get-type finds type of TJILL.. lots of error checking
(define (get-type tree env)
  (cond [(TJILL? tree)
  (type-case TJILL tree
    [id (name) (type-lookup name env)]
    [num (n) (if (number? n) (numType) (error 'get-type "Get-type error 1 " ))]
    [add (l r) (if (and (equal? (get-type l env) (numType)) (equal? (get-type r env) (numType))) (numType) (error 'get-type "Get-type error +2"))]
    [sub (l r) (if (and (equal? (get-type l env) (numType)) (equal? (get-type r env) (numType))) (numType) (error 'get-type "Get-type error -3"))]
    [mul (l r) (if (and (equal? (get-type l env) (numType)) (equal? (get-type r env) (numType))) (numType) (error 'get-type "Get-type error *4"))]
    [div (l r) (if (and (equal? (get-type l env) (numType)) (equal? (get-type r env) (numType))) (numType) (error 'get-type "Get-type error /5"))]
    [neg (n) (if (equal? (get-type n env) (numType)) (numType) (error 'get-type "Get-type error -6"))]
    [equ (l r) (if (equal? (get-type l env) (get-type r env)) (boolType) (error 'get-type "Get-type error =7"))]
    [lt (l r) (if (and (equal? (get-type l env) (numType)) (equal? (get-type r env) (numType))) (boolType) (error 'get-type "Get-type error < 8"))]
    [iff (e t f) (equal? (get-type e env) (boolType)) (equal? (get-type t env) (get-type f env)) (get-type t env)]
    [fun (arg type body) (funType type (get-type body (aType arg type env)))]
    ;;fun-type has value, type, body
    ;;have to check to see if domain and codomain match
    [app (fun-expr arg-expr) (let ((funtype (get-type fun-expr env)))
                                  (cond [(funType? funtype)
                                         (cond [(equal? (get-type arg-expr env) (funType-domain funtype)) (funType-codomain funtype)]
                                                                  [#t (error 'get-type "function error" (get-type arg-expr env) fun-expr (funType-domain funtype))])]
                                        [#t (error 'get-type "function #2 error" funtype)]))]
  )]
))
                                                    ;; Case Checking Below ;;

(define (run-type expr)
  (get-type (parse expr) (mtTypeSub)))

;;One Test (txt file project8_1.0)
(get-type (parse '{with {x : number 3}
  		{= x 3}}) (mtTypeSub))

(run-type '{with {x : number 2}
  {with {y : number 12}
    {+ {* x x} {* y y}}
}})

(run-type '{- 1 {- 2 {- 3 {- 4 {- 5 6}}}}})
(run-type '{with {x : number 3} ;; this should evaluate to a boolean value
  {= x 2}})

(run-type '{with {not : (boolean -> boolean)
         {fun {v : boolean}
           {if v {= 0 1} {= 0 0}}
      }  }
   {with {limit : number 44}
      {with {flag : boolean {< 70 limit}}
        {not flag}
   }  }
})

(run-type '{if {= {* 5 21} {* 7 15}}
    9999
    5555
})

(run-type '{with {number : (number -> number) {fun {number : number}
        {* number number}}}
   {with {num : number 8}
     {number num} }})

;;My programs
(run-type '(+ 3 5))
(run-type '(= 5 5))
(run-type '(< 5 3))
(run-type '(/ 5 3))
(run-type '{with {x : number 2}
  {with {y : number 12}
    {+ y {- 2 2}}
}})


;; Two test (ERRORS)

(parse '{with {x:number 3}
   x})
   
(parse '{with {x 3}
   x})

(parse '{6 - 7})

(parse '{fun {n : number 12}
   {+ n 3}})
   
(parse '{fun {n 12} : number
   {+ n 3}})
   
(parse '{with {y : number}
   {+ x y}})

