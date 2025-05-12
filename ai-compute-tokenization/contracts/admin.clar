;; AI Compute Resources Tokenization Protocol
;; Module: Administration Functions

;; Import core components
(use .core)

;; ===== NETWORK MANAGEMENT =====
(define-public (activate-network)
    (begin
        (asserts! (is-administrator) ERR-NOT-ADMINISTRATOR)
        (var-set network-online true)
        (var-set compute-cycle u0)
        (var-set energy-credits u0)
        (ok true)))

(define-public (shutdown-network)
    (begin
        (asserts! (is-administrator) ERR-NOT-ADMINISTRATOR)
        (var-set network-online false)
        (ok true)))

(define-public (advance-compute-cycle)
    (begin
        (asserts! (is-administrator) ERR-NOT-ADMINISTRATOR)
        (asserts! (var-get network-online) ERR-NETWORK-OFFLINE)
        (var-set compute-cycle (+ (var-get compute-cycle) u1))
        (ok true)))

(define-public (transfer-administrator-role (new-administrator principal))
    (begin
        (asserts! (is-administrator) ERR-NOT-ADMINISTRATOR)
        (var-set network-administrator new-administrator)
        (ok true)))

;; ===== PARAMETER CONFIGURATION =====
(define-public (update-minimum-compute (new-minimum uint))
    (begin
        (asserts! (is-administrator) ERR-NOT-ADMINISTRATOR)
        (var-set minimum-compute-units new-minimum)
        (ok true)))

(define-public (update-utilization-threshold (new-percentage uint))
    (begin
        (asserts! (is-administrator) ERR-NOT-ADMINISTRATOR)
        ;; Validate percentage is between 1 and 100
        (asserts! (and (> new-percentage u0) (<= new-percentage u100)) ERR-INVALID-PARAMETER)
        (var-set utilization-threshold new-percentage)
        (ok true)))