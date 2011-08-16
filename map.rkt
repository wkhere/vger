#lang racket
;;
;; I wonder if the final A* will look more clean & be faster than for
;; other langs.. in theory, it should.
(require rackunit)

(define mvcost-base
  (apply hash '[ 
    space    11
    nebula   16
    viral    18
    energy   20
    asteroid 25
    exotic   36 ]))

(define speed-base
  (apply hash '[
    nuclear 1
    fusion  2
    efusion 2
    ion     3
    am      4
    eam     4
    hyper   5
    ip      6
    iep     6 ]))


(define (mvcost env drive)
  (- (hash-ref mvcost-base env) (speed drive)))

(define (speed drive)
  (if (integer? drive) 
      drive
      (hash-ref speed-base drive)))


(define envdata (make-hash)) ; could be global somehow!

(define (env-bbox! s x y)
  (hash-set! envdata (cons s 'bbox) (cons x y)))

(define (env-v! s x y v)
  (match (list x y)
         [(list (? integer? x) (? integer? y))
          (when (or (eq? v 'block) (hash-has-key? mvcost-base v))
                (hash-set! envdata (list s x y) v))]
         [(list (? integer? x) (list y1 y2))
          (for ([y (in-range y1 (add1 y2))])
               (env-v! s x y v))]
         [(list (list x1 x2) _)
          (for ([x (in-range x1 (add1 x2))])
               (env-v! s x y v))]))

(define (env . args)
  (hash-ref envdata args 'block))
(define (env-bbox s)
  (hash-ref envdata (cons s 'bbox)))

(require mzlib/defmacro)
(defmacro env! args `(apply env-v! (quote ,args)))
 
(env-bbox! 'enioar  20  12)
(env! enioar   (7 9)    (0 1)    energy)
(env! enioar   8        2        energy)
;;(env! enioar   8        0        (wormhole unused))
;;(env! enioar   8        2        (choke (to (7 9) (0 1))))
(env! enioar   1        (1 5)    energy)
(env! enioar   (1 3)    1        energy)
(env! enioar   (16 17)  (1 2)    energy)
(env! enioar   (0 1)    (2 3)    energy)
(env! enioar   2        (2 4)    energy)
(env! enioar   (3 4)    2        energy)
(env! enioar   (14 17)  2        energy)
(env! enioar   3        (3 5)    space)
(env! enioar   (2 3)    (3 4)    space)
(env! enioar   (4 14)   3        energy)
(env! enioar   (15 16)  3        space)
(env! enioar   (17 18)  (3 4)    energy)
(env! enioar   (2 15)   4        space)
(env! enioar   (7 15)   (4 6)    space)
(env! enioar   10       (4 10)   space)
(env! enioar   (10 15)  (4 7)    space)
(env! enioar   16       (4 6)    energy)
(env! enioar   (16 18)  4        energy)
(env! enioar   (1 2)    5        energy)
(env! enioar   (4 6)    (5 7)    nebula)
(env! enioar   (2 3)    6        energy)
(env! enioar   3        (6 8)    energy)
(env! enioar   7        (7 8)    energy)
(env! enioar   (7 9)    7        energy)
(env! enioar   9        (7 11)   energy)
(env! enioar   (16 17)  6        energy)
(env! enioar   (14 15)  (7 8)    nebula)
(env! enioar   16       (7 8)    space)
(env! enioar   17       (6 9)    energy)
(env! enioar   (17 20)  7        energy)
;;(env! enioar   18       7        (choke (to (19 20) (6 8))))
(env! enioar   (19 20)  (6 8)    energy)
;;(env! enioar   20       7        (wormhole (to (pf09 0 7))))
(env! enioar   2        (8 12)   energy)
(env! enioar   (2 3)    8        energy)
(env! enioar   5        (8 9)    space)
(env! enioar   (4 5)    8        space)
(env! enioar   6        (8 10)   energy)
(env! enioar   (6 7)    8        energy)
(env! enioar   (11 13)  8        energy)
(env! enioar   (1 2)    (9 10)   energy)
(env! enioar   (3 4)    (9 10)   asteroid)
(env! enioar   3        (9 11)   asteroid)
(env! enioar   4        11       space)
(env! enioar   5        (10 12)  energy)
(env! enioar   11       (8 10)   energy)
(env! enioar   (11 13)  8        energy)
(env! enioar   (2 5)    12       energy)
(env! enioar   (9 10)   11       energy)
(env! enioar   (13 17)  9        energy)
(env! enioar   (11 14)  10       energy)
(env! enioar   (13 14)  (9 11)   energy)
(env! enioar   13       (8 12)   energy)
(env! enioar   (11 12)  11       space)
(env! enioar   (10 13)  12       energy)
;;(env! enioar   12       12       (wormhole (to (liaface 9 0))))
(env! enioar   (0 6)    0        block)
(env! enioar   0        1        block)
(env! enioar   (4 6)    (0 1)    block)
(env! enioar   (5 6)    (0 2)    block)
(env! enioar   (5 7)    2        block)
(env! enioar   9        2        block)
(env! enioar   (10 13)  (0 2)    block)
(env! enioar   (10 15)  (0 1)    block)
(env! enioar   (10 20)  0        block)
(env! enioar   (18 20)  (0 2)    block)
(env! enioar   0        (4 12)   block)
(env! enioar   (0 1)    (6 8)    block)
(env! enioar   2        7        block)
(env! enioar   (0 1)    (11 12)  block)
(env! enioar   8        8        block)
(env! enioar   (7 8)    (9 12)   block)
(env! enioar   6        11       block)
(env! enioar   (6 9)    12       block)
(env! enioar   12       9        block)
(env! enioar   (19 20)  (3 5)    block)
(env! enioar   (17 20)  5        block)
(env! enioar   18       6        block)
(env! enioar   18       8        block)
(env! enioar   (18 20)  (9 12)   block)
(env! enioar   (15 20)  (10 12)  block)
(env! enioar   14       12       block)
;; enioar done.

(define (check-env-is-complete sector)
  (match (env-bbox sector)
         [(cons mx my)
          (for ([x (in-range (add1 mx))])
               (for ([y (in-range (add1 my))])
                    (env sector x y)))])
  'ok)

(define (nb s x y)
  (if (eq? (env s x y) 'block)
      empty
      (foldl (match-lambda* 
              [(list (list i j) acc)
               (let ([new-place (list s (+ x i) (+ y j))])
                 (if (eq? (apply env new-place) 'block)
                     acc
                     (cons new-place acc)))])
             empty
             '[[-1  0] [-1  1] [ 0  1] [ 1  1] 
               [ 1  0] [ 1 -1] [ 0 -1] [-1 -1]])))

(check eq? empty (nb 'enioar 0 0))

(define h0 
  (match-lambda*
   [(list (list s x1 y1) (list s x2 y2))
    (let ([xd (- x2 x1)] [yd (- y2 y1)])
      (floor (sqrt (+ (* xd xd) (* yd yd)))))]))

(define (h-drived drive n1 n2)
  (* (mvcost 'space drive) (h0 n1 n2)))


(define (a*-drived drive node0 goal)
  (a* (curry h-drived drive)
      (lambda (node) (apply nb node))
      (lambda (node1 _node2) (mvcost (apply env node1) drive))
      node0 
      goal))

(require "data.rkt")

(define-syntax-rule (make-mset) (set))
(define-syntax-rule (mset-add! s x) (set! s (set-add s x)))
(define-syntax-rule (mset-del! s x) (set! s (set-remove s x)))
(define-syntax-rule (mset-member? s x) (set-member? s x))
(define-syntax-rule (mset-empty? s) (set-empty? s))

(define (a* h nbs dist node0 goal)
  (let ([closed-set (make-mset)]
        [parents    (make-hash)]
        [g          (make-hash (list (cons node0 0)))]
        [open-set   (make-mset)]
        [open-q     (make-heap2)])
    (mset-add! open-set node0)
    (let ([f0 (h node0 goal)])
      (heap2-add! open-q f0 node0))

    (define (cons-path node acc)
      (let ([parent (hash-ref parents node #f)])
        (if parent
            (cons-path parent (cons node acc))
            acc)))      
    
    (let/ec return
      (do () ((mset-empty? open-set) #f)

        (let-values ([[_ x] (heap2-pop! open-q)])
          (mset-del! open-set x)
          (when (equal? x goal)
                (return (cons-path goal null)))
          
          (mset-add! closed-set x)

          (for ([y (nbs x)])
            (let/ec continue
              (when (mset-member? closed-set y)
                    (continue))

              (let ([estimate-g (+ (hash-ref g x) (dist x y))])
                
                (when (mset-member? open-set y)
                      (if (< estimate-g (hash-ref g y))
                          (heap2-del! open-q y)
                          (continue)))
                
                (hash-set! parents y x)
                (hash-set! g y estimate-g)
                (let ([fy (+ (h y goal) estimate-g)])
                  (heap2-add! open-q fy y))
                (mset-add! open-set y)))))))))
