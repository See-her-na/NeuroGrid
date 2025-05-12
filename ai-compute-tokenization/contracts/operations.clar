;; AI Compute Resources Tokenization Protocol
;; Module: Operations (Allocation and Finalization)

;; Import core components
(use .core)

;; ===== ALLOCATION FUNCTIONS =====
(define-public (allocate-compute
    (resource-id uint)
    (approve-optimization bool))
    (let (
        (resource (unwrap! (map-get? compute-resources resource-id) ERR-INVALID-RESOURCE))
        (researcher (unwrap! (map-get? researcher-profiles tx-sender) ERR-INSUFFICIENT-COMPUTE))
        (priority-level (get priority-level researcher))
        )
        
        ;; Check network status
        (asserts! (var-get network-online) ERR-NETWORK-OFFLINE)
        
        ;; Check resource hasn't been allocated
        (asserts! (not (get allocated resource)) ERR-RESOURCE-ALLOCATED)
        
        ;; Check researcher hasn't already scheduled this resource
        (asserts! (is-none (map-get? allocation-records {resource-id: resource-id, researcher: tx-sender})) ERR-ALREADY-SCHEDULED)
        
        ;; Record allocation
        (map-set allocation-records 
            {resource-id: resource-id, researcher: tx-sender}
            {
                optimization-approved: approve-optimization,
                compute-allocated: priority-level
            })
        
        ;; Update usage counts
        (if approve-optimization
            (map-set compute-resources resource-id
                (merge resource {usage-confirmed: (+ (get usage-confirmed resource) priority-level)}))
            (map-set compute-resources resource-id
                (merge resource {usage-rejected: (+ (get usage-rejected resource) priority-level)}))
        )
        
        (ok true)))

;; ===== RESOURCE FINALIZATION =====
(define-public (finalize-resource (resource-id uint))
    (let (
        (resource (unwrap! (map-get? compute-resources resource-id) ERR-INVALID-RESOURCE))
        )
        
        ;; Check network status
        (asserts! (var-get network-online) ERR-NETWORK-OFFLINE)
        
        ;; Only administrator can finalize resources
        (asserts! (is-administrator) ERR-NOT-AUTHORIZED)
        
        ;; Check resource hasn't been allocated
        (asserts! (not (get allocated resource)) ERR-RESOURCE-ALLOCATED)
        
        ;; Calculate if utilization threshold was reached
        (let (
            (total-usage (+ (get usage-confirmed resource) (get usage-rejected resource)))
            (utilization-required (/ (* (get total-available-compute resource) (var-get utilization-threshold)) u100))
            (resource-optimized (and 
                (> total-usage utilization-required)
                (> (get usage-confirmed resource) (get usage-rejected resource))))
            )
            
            ;; Update resource status
            (map-set compute-resources resource-id
                (merge resource {
                    allocated: true,
                    optimized: resource-optimized
                }))
            
            ;; If resource optimized and needs compute, allocate it
            (if (and resource-optimized (> (get optimization-request resource) u0))
                (begin
                    ;; Ensure energy credits has enough balance
                    (asserts! (>= (var-get energy-credits) (get optimization-request resource)) ERR-INSUFFICIENT-COMPUTE)
                    
                    ;; Update energy credits
                    (var-set energy-credits (- (var-get energy-credits) (get optimization-request resource)))
                    
                    (ok true))
                (ok false)))))