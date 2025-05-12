;; AI Compute Resources Tokenization Protocol
;; Module: User Management (Researchers and Resources)

;; Import core components
(use .core)

;; ===== RESEARCHER FUNCTIONS =====
(define-public (register-researcher (compute-amount uint))
    (begin
        (asserts! (var-get network-online) ERR-NETWORK-OFFLINE)
        ;; Require minimum compute amount
        (asserts! (>= compute-amount (var-get minimum-compute-units)) ERR-INSUFFICIENT-COMPUTE)
        
        ;; Transfer tokens to network energy credits
        (try! (stx-transfer? compute-amount tx-sender (var-get network-administrator)))
        
        ;; Initialize researcher profile
        (map-set researcher-profiles tx-sender
            {
                compute-balance: compute-amount,
                resources-used: (list),
                priority-level: compute-amount
            })
            
        ;; Update energy credits
        (var-set energy-credits (+ (var-get energy-credits) compute-amount))
        
        (ok true)))

;; Read-only functions for researcher data
(define-read-only (get-researcher-profile (researcher principal))
    (map-get? researcher-profiles researcher))

;; ===== RESOURCE MANAGEMENT =====
(define-public (register-resource
    (resource-id uint)
    (model-name (string-utf8 128))
    (specifications (string-utf8 512))
    (resource-signature (buff 32))
    (optimization-request uint))
    (let (
        (researcher-profile (unwrap! (map-get? researcher-profiles tx-sender) ERR-INSUFFICIENT-COMPUTE))
        (total-compute-capacity u10000000) ;; Example: 10M compute units
        )
        
        ;; Check network status
        (asserts! (var-get network-online) ERR-NETWORK-OFFLINE)
        
        ;; Validate resource-id is within acceptable range
        (asserts! (<= resource-id MAX-RESOURCE-ID) ERR-INVALID-PARAMETER)
        
        ;; Check if resource already exists
        (asserts! (is-none (map-get? compute-resources resource-id)) ERR-RESOURCE-EXISTS)
        
        ;; Validate model-name and specifications are not empty
        (asserts! (> (len model-name) u0) ERR-INVALID-PARAMETER)
        (asserts! (> (len specifications) u0) ERR-INVALID-PARAMETER)
        
        ;; Check researcher has enough compute to register resource
        (asserts! (>= (get compute-balance researcher-profile) (var-get minimum-compute-units)) ERR-INSUFFICIENT-COMPUTE)
        
        ;; Set the resource data
        (map-set compute-resources resource-id
            {
                model-name: model-name,
                specifications: specifications,
                resource-signature: resource-signature,
                optimization-request: optimization-request,
                usage-confirmed: u0,
                usage-rejected: u0,
                total-available-compute: total-compute-capacity,
                allocated: false,
                optimized: false
            })
        
        ;; Update researcher profile
        (map-set researcher-profiles tx-sender
            (merge researcher-profile {
                resources-used: (unwrap! (as-max-len? 
                    (append (get resources-used researcher-profile) resource-id) u30)
                    ERR-INVALID-PARAMETER)
            }))
        
        (ok true)))

;; Read-only functions for resources
(define-read-only (get-resource-details (resource-id uint))
    (map-get? compute-resources resource-id))