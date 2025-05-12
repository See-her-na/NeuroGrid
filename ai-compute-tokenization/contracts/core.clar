;; AI Compute Resources Tokenization Protocol

;; ===== CONSTANTS =====
;; Error Constants
(define-constant ERR-NOT-ADMINISTRATOR (err u1))
(define-constant ERR-NETWORK-OFFLINE (err u2))
(define-constant ERR-INVALID-RESOURCE (err u3))
(define-constant ERR-RESOURCE-ALLOCATED (err u4))
(define-constant ERR-INVALID-PARAMETER (err u5))
(define-constant ERR-INSUFFICIENT-COMPUTE (err u6))
(define-constant ERR-RESOURCE-EXISTS (err u7))
(define-constant ERR-ALREADY-SCHEDULED (err u8))
(define-constant ERR-NOT-AUTHORIZED (err u9))

;; System Constants
(define-constant MAX-RESOURCE-ID u1000) ;; Maximum allowed resource ID

;; ===== DATA VARIABLES =====
(define-data-var network-administrator principal tx-sender)
(define-data-var network-online bool false)
(define-data-var compute-cycle uint u0)
(define-data-var minimum-compute-units uint u1000000) ;; 1 million compute units minimum
(define-data-var energy-credits uint u0)
(define-data-var utilization-threshold uint u33) ;; 33% utilization required for optimization
(define-data-var contract-version (string-ascii 32) "3.0.0")
(define-data-var contract-name (string-ascii 64) "AI Compute Resources Tokenization Protocol")

;; ===== DATA MAPS =====
;; Resource Allocation Structure
(define-map compute-resources
    uint
    {
        model-name: (string-ascii 128),
        specifications: (string-ascii 512),
        resource-signature: (buff 32),    ;; SHA256 hash of the resource verification
        optimization-request: uint,        ;; Amount of compute requested for optimization
        usage-confirmed: uint,
        usage-rejected: uint,
        total-available-compute: uint,     ;; Total compute units available for this resource
        allocated: bool,
        optimized: bool
    }
)

;; Researcher Profiles
(define-map researcher-profiles
    principal
    {
        compute-balance: uint,
        resources-used: (list 30 uint),
        priority-level: uint           ;; Can be different from compute balance (premium tier)
    }
)

;; Allocation Records
(define-map allocation-records
    {resource-id: uint, researcher: principal}
    {
        optimization-approved: bool,   ;; true = approved, false = rejected
        compute-allocated: uint
    }
)

;; ===== HELPER FUNCTIONS =====
;; Authorization helper
(define-private (is-administrator)
    (is-eq tx-sender (var-get network-administrator)))

;; ===== READ-ONLY INFO FUNCTIONS =====
;; Contract version info
(define-read-only (get-contract-info)
    {
        name: (var-get contract-name),
        version: (var-get contract-version),
        admin: (var-get network-administrator)
    })

;; Network metrics
(define-read-only (get-network-metrics)
    {
        online: (var-get network-online),
        compute-cycle: (var-get compute-cycle),
        energy-credits: (var-get energy-credits),
        minimum-compute-units: (var-get minimum-compute-units),
        utilization-threshold: (var-get utilization-threshold)
    })