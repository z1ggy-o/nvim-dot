;; extends
;
; Extend C folds with branch-level folds for if/else bodies.
; This is intentionally additive: keep the default if_statement fold,
; and also allow consequence/alternative blocks to fold independently.

(if_statement
  consequence: (compound_statement) @fold)

(if_statement
  alternative: (else_clause
    (compound_statement) @fold))

[
 (preproc_elif)
 (preproc_else)
] @fold
