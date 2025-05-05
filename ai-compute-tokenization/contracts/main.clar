;; AI Compute Resources Tokenization Protocol - Version 3
;; Main Contract File

;; This is the main entry point for the contract
;; All functionality is accessed through the appropriate contract calls

;; Define contract-specific constants 
(define-constant CONTRACT-VERSION "3.0.0")
(define-constant CONTRACT-NAME "AI Compute Resources Tokenization Protocol")

;; The contract provides the following capabilities:
;; 1. Network administration (activation, shutdown, parameter updates) - via admin contract
;; 2. Researcher registration and management - via users contract
;; 3. Resource registration and management - via users contract
;; 4. Compute allocation and optimization - via operations contract

;; All functions are exposed through the individual modules
;; This contract serves as a central point of documentation

;; Contract info
(define-read-only (get-contract-info)
    {
        name: CONTRACT-NAME,
        version: CONTRACT-VERSION
    })