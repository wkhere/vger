#lang racket
(provide (all-defined-out))
(require racket/set data/heap)


(define-syntax-rule (make-mset) (set))
(define-syntax-rule (mset-add! s x) (set! s (set-add s x)))
(define-syntax-rule (mset-del! s x) (set! s (set-remove s x)))
(define-syntax-rule (mset-member? s x) (set-member? s x))
(define-syntax-rule (mset-empty? s) (set-empty? s))


(define (make-heap2)
  (cons
   (make-heap (lambda (x y)
                (<= (car x) (car y)))) ; heap of (pri . v) items
   (make-hash)))                       ; v->#t of deleted items

(define (heap2-add! h2 pri v)
  (match-let ([(cons h dels) h2])
    (heap-add! h (cons pri v))
    (hash-remove! dels v)))

(define (heap2-del! h2 v)
  (match-let ([(cons _ dels) h2])
    (hash-set! dels v #t)))
   
(define (heap2-pop! h2)
   (match-let* ([(cons h dels) h2]
                [(cons pri v) (heap-min h)])
     (heap-remove-min! h)
     (if (hash-has-key? dels v)
         (begin
           (hash-remove! dels v)
           (heap2-pop! h2))
         (values pri v))))
