;; Treasure Hunt Game Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-location (err u101))
(define-constant err-already-found (err u102))
(define-constant err-wrong-guess (err u103))

;; Store treasure location (as uint)
(define-data-var treasure-location (optional uint) none)

;; Track if the treasure is found
(define-data-var treasure-found bool false)

;; Set the treasure location (only owner can call this)
(define-public (set-treasure (location uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> location u0) err-invalid-location)
    (var-set treasure-location (some location))
    (var-set treasure-found false)
    (ok true)
  )
)

;; Guess the treasure location
(define-public (guess-location (guess uint))
  (begin
    (asserts! (not (var-get treasure-found)) err-already-found)
    (match (var-get treasure-location)
      treasure
      (if (is-eq guess treasure)
          (begin
            (var-set treasure-found true)
            (ok "You found the treasure!"))
          err-wrong-guess)
      (err u104)) ;; Treasure not set
  )
)
