#lang racket
(provide (all-defined-out))

;;; Parses mathematical expressions using Recursive Descent

(define (number stmt)
  (cond ((null? stmt)
         (valid-expr))
        ((expect? 'number (car stmt))
         (operator (cdr stmt)))
        ((expect? 'expression-open (car stmt) stmt)
         (number (cdr stmt)))
        (else (display "Expected a number or expression, got an operator.\n")
              (display stmt)
              (newline)
              #f)))
          
(define (operator stmt)
  (cond ((null? stmt)
         (valid-expr))
        ((expect? 'operator (car stmt))
         (number (cdr stmt)))
        ((expect? 'expression-close (car stmt))
         (number (cdr stmt)))
        (else (display "Expected an operator, got a number or expression.\n")
              (display stmt)
              (newline)
              #f)))

(define (expect? type sym . args)
  (cond ((null? sym)
         #t)
        ((eq? type 'operator)
         (member sym '(#\+ #\- #\* #\/ #\% #\= #\! #\^ #\< #\>)))
        ((eq? type 'number)
         (number? sym))
        ((eq? type 'expression-open)
         (and (eq? #\( sym)
              (member #\) (car args))))
        ((eq? type 'expression-close)
         (eq? #\) sym))
        (else #f)))

(define (parse stmt)
  (if (expect? 'number (car stmt))
      (number stmt)
      (begin
        (display "Expecting a number to begin the equation.\n")
        #f)))
      
(define (valid-expr)
  #t)
