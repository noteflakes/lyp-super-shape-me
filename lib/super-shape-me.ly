% Translate a list of coord arguments:
%   #f      => '(0 . 0)
%   <y>     => '(0 . <y>)
%   <pair>  => <pair>

#(define (ssm:convert-coord c) (cond
  ((eq? c #f) '(0 . 0))
  ((number? c) (cons 0 c))
  (else c)))

#(define (ssm:convert-coord-list l)
  (map (lambda (c) (ssm:convert-coord c)) l))

% Interpolate along a range
#(define (ssm:rate min max r) (+ min (* (- max min) r)))

% Interpolate shape coords between 2 edge coords, returns a list of 4 coords
#(define (ssm:interpolate-coords ca cb) (let* (
  (c1 (ssm:convert-coord ca))
  (c4 (ssm:convert-coord cb))
  (c2 (cons (ssm:rate (car c1) (car c4) 1/3) (ssm:rate (cdr c1) (cdr c4) 1/3)))
  (c3 (cons (ssm:rate (car c1) (car c4) 2/3) (ssm:rate (cdr c1) (cdr c4) 2/3))))

  (list c1 c2 c3 c4)
))

% Shaping commands

sR = #(define-music-function (parser location r) (number?)
  #{ \once \override Slur.ratio = #r #})
  
sE = #(define-music-function (parser location e) (number?)
  #{ \once \override Slur.eccentricity = #e #})

sH = #(define-music-function (parser location h) (number?)
  #{ \once \override Slur.height-limit = #h #})

sHE = #(define-music-function (parser location h e) (number? number?)
  #{ \once \override Slur.height-limit = #h
     \once \override Slur.eccentricity = #e #})

sHR = #(define-music-function (parser location h r) (number? number?)
  #{ \once \override Slur.height-limit = #h
     \once \override Slur.ratio = #r #})

sP = #(define-music-function (parser location p1 p2) (number? number?)
  #{ \once \override Slur.positions = #(cons p1 p2) #})

sS = #(define-music-function (parser location s) (scheme?)
  #{ \shape #(ssm:convert-coord-list s) Slur #})

sNudge = #(define-music-function (parser location ca cb) (scheme? scheme?)
  #{ 
      \shape #(ssm:interpolate-coords ca cb) Slur #})
  
