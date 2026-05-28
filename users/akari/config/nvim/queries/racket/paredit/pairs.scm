(list
  .
  (symbol) @fn-name
  (#any-of? @fn-name
   "let"
   "let*"
   "letrec"
   "let-values"
   "let*-values"
   "letrec-values"
   "let-syntax"
   "letrec-syntax"
   "let-syntaxes"
   "letrec-syntaxes")
  .
  (list
    (_) @pair))

(list
  .
  (symbol) @fn-name
  (#eq? @fn-name "let")
  .
  (_)
  .
  (list
    (_) @pair))

(list
  .
  (symbol) @fn-name
  (#eq? @fn-name "cond")
  .
  ((_) @pair (_) @pair)+)
