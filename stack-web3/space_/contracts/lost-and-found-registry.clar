;; Lost and Found Registry Contract
;; Allows users to report lost items and claim found items

(define-map lost-items uint
  {
    owner: principal,
    description: (string-ascii 100),
    is-claimed: bool
  }
)

(define-data-var item-counter uint u0)

;; Report a lost item
(define-public (report-lost (description (string-ascii 100)))
  (let ((item-id (+ (var-get item-counter) u1)))
    (begin
      (map-set lost-items item-id {
        owner: tx-sender,
        description: description,
        is-claimed: false
      })
      (var-set item-counter item-id)
      (ok item-id)
    )
  )
)

;; Claim a found item by its ID
(define-public (claim-found (item-id uint))
  (let ((item (map-get? lost-items item-id)))
    (match item item-data
      (begin
        (asserts! (not (get is-claimed item-data)) (err u100))
        (map-set lost-items item-id (merge item-data {is-claimed: true}))
        (ok true)
      )
      (err u101)
    )
  )
)

