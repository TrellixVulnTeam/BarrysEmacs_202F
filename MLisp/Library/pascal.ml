;
; pascal.ml
;
; based on philips' pascal
;
; Copyright (c) 1998 Barry A. Scott
;
(defun
    (electric-pascal-mode
        (use-abbrev-table "Pascal")
        (use-syntax-table "Pascal")
        (use-local-map "Pascal-keymap")
        (setq mode-string "Pascal")
    )
)
(defun
    (Make-Pascal-Abbrevs
        (use-abbrev-table "Pascal")
        (define-local-abbrev "and" "AND")
        (define-local-abbrev "array" "ARRAY")
        (define-local-abbrev "begin" "BEGIN")
        (define-local-abbrev "boolean" "BOOLEAN")
        (define-local-abbrev "logical" "BOOLEAN")
        (define-local-abbrev "cand" "CAND")
        (define-local-abbrev "case" "CASE")
        (define-local-abbrev "chr" "CHR")
        (define-local-abbrev "const" "CONST")
        (define-local-abbrev "cor" "COR")
        (define-local-abbrev "div" "DIV")
        (define-local-abbrev "do" "DO")
        (define-local-abbrev "downto" "DOWNTO")
        (define-local-abbrev "else" "ELSE")
        (define-local-abbrev "end" "END")
        (define-local-abbrev "exit" "EXIT")
        (define-local-abbrev "exports" "EXPORTS")
        (define-local-abbrev "false" "FALSE")
        (define-local-abbrev "file" "FILE")
        (define-local-abbrev "for" "FOR")
        (define-local-abbrev "forward" "FORWARD")
        (define-local-abbrev "from" "FROM")
        (define-local-abbrev "fun" "FUNCTION")
        (define-local-abbrev "function" "FUNCTION")
        (define-local-abbrev "get" "GET")
        (define-local-abbrev "goto" "GOTO")
        (define-local-abbrev "if" "IF")
        (define-local-abbrev "imports" "IMPORTS")
        (define-local-abbrev "in" "IN")
        (define-local-abbrev "input" "INPUT")
        (define-local-abbrev "integer" "INTEGER")
        (define-local-abbrev "label" "LABEL")
        (define-local-abbrev "long" "LONG")
        (define-local-abbrev "mod" "MOD")
        (define-local-abbrev "module" "MODULE")
        (define-local-abbrev "new" "NEW")
        (define-local-abbrev "nil" "NIL")
        (define-local-abbrev "null" "NIL")
        (define-local-abbrev "not" "NOT")
        (define-local-abbrev "of" "OF")
        (define-local-abbrev "or" "OR")
        (define-local-abbrev "ord" "ORD")
        (define-local-abbrev "otherwise" "OTHERWISE")
        (define-local-abbrev "output" "OUTPUT")
        (define-local-abbrev "packed" "PACKED")
        (define-local-abbrev "private" "PRIVATE")
        (define-local-abbrev "proc" "PROCEDURE")
        (define-local-abbrev "procedure" "PROCEDURE")
        (define-local-abbrev "program" "PROGRAM")
        (define-local-abbrev "put" "PUT")
        (define-local-abbrev "read" "READ")
        (define-local-abbrev "readln" "READLN")
        (define-local-abbrev "real" "REAL")
        (define-local-abbrev "record" "RECORD")
        (define-local-abbrev "repeat" "REPEAT")
        (define-local-abbrev "reset" "RESET")
        (define-local-abbrev "rewrite" "REWRITE")
        (define-local-abbrev "set" "SET")
        (define-local-abbrev "string" "STRING")
        (define-local-abbrev "text" "TEXT")
        (define-local-abbrev "then" "THEN")
        (define-local-abbrev "to" "TO")
        (define-local-abbrev "true" "TRUE")
        (define-local-abbrev "type" "TYPE")
        (define-local-abbrev "until" "UNTIL")
        (define-local-abbrev "var" "VAR")
        (define-local-abbrev "while" "WHILE")
        (define-local-abbrev "with" "WITH")
        (define-local-abbrev "write" "WRITE")
        (define-local-abbrev "writeln" "WRITELN")
    ) ;;; End of Make-Pascal-Abbrevs
)
(defun
    (Do-Pascal-Bindings
        (local-bind-to-key "Enter-Comment-Mode" '{')
        (local-bind-to-key "Leave-Comment-Mode" '}')
        (local-bind-to-key "Enter-Fuzzy-Comment" '*')
        (local-bind-to-key "End-Fuzzy-Comment" ')')
        (local-bind-to-key "Toggle-Comment-Mode" 39) ; Single Quote
    ) ;;; End of Do-Pascal-Bindings
)
(defun
    (Toggle-Comment-Mode
        (if (= abbrev-mode 0)
            (set "abbrev-mode" 1)
            (set "abbrev-mode" 0))
        (insert-character (last-key-struck))
    ) ;;; End of Toggle-Comment-Mode
)
(defun
    (Enter-Comment-Mode
        (set "abbrev-mode" 0)
        (insert-character (last-key-struck))
    ) ;;; End of Enter-Comment-Mode
)
(defun
    (Leave-Comment-Mode
        (set "abbrev-mode" 1)
        (insert-character (last-key-struck))
    ) ;;; End of Leave-Comment-Mode
)
(defun
    (Enter-Fuzzy-Comment last-key prev-char
        (setq last-key (last-key-struck))
        (setq prev-char (preceding-char))
        (if (& (= last-key  42)         ; 42 = Asterisk
                (= prev-char 40))       ; 40 = open paren
            (progn
                (set "abbrev-mode" 0)
                (insert-string "*"))
            (insert-character last-key)))
)
(defun
    (End-Fuzzy-Comment last-key prev-char
        (setq last-key (last-key-struck))
        (setq prev-char (preceding-char))
        (if (& (= last-key  41)         ; 41 = close paren
                (= prev-char 42))       ; 42 = Asterisk
            (set "abbrev-mode" 1))
        (insert-character last-key))
)
(defun
    (Pascal-Skeleton name type Prompt colno
        (setq Prompt ": Pascal-Skeleton ")
        (setq name (get-tty-string (concat Prompt "name: ")))
        (if (= name "")
            (error-occurred "Aborted."))
        (setq colno (current-column))
        (setq type (get-tty-string (concat Prompt name " Result: ")))
        (if (= type "")
            (progn pos                          ; We have a procedure
                (insert-character 10)(to-col colno)
                (insert-string (concat "PROCEDURE " name ))
                (save-excursion
                    (insert-string ";")
                    (insert-character 10)(to-col colno)
                    (insert-string "BEGIN")
                    (insert-character 10)(to-col colno)
                    (insert-string (concat "END; (* " name " *)"))
                    (insert-character 10)))
            (progn                              ; We have a function
                (insert-character 10)(to-col colno)
                (insert-string (concat "FUNCTION " name))
                (save-excursion
                    (insert-string (concat ": " type ";"))
                    (insert-character 10)(to-col colno)
                    (insert-string "VAR")
                    (insert-character 10)(to-col (+ colno 4))
                    (insert-string (concat "Answer: " type ";"))
                    (insert-character 10)(to-col colno)
                    (insert-string "BEGIN")
                    (insert-character 10)(to-col (+ colno 4))
                    (insert-string (concat name " := Answer;"))
                    (insert-character 10)(to-col colno)
                    (insert-string (concat "END; (* " name " *)"))
                    (insert-character 10))))
    )
)
(save-excursion
    (temp-use-buffer "~pascal")
    (Make-Pascal-Abbrevs)
    (use-syntax-table "Pascal")
    (modify-syntax-table "word" "_")
    (modify-syntax-table "paren" "(" ")")
    (modify-syntax-table "paren" "{" "}")
    (modify-syntax-table "keyword-1,case-fold" "AND")
    (modify-syntax-table "keyword-1,case-fold" "ARRAY")
    (modify-syntax-table "keyword-1,case-fold" "BEGIN")
    (modify-syntax-table "keyword-1,case-fold" "BOOLEAN")
    (modify-syntax-table "keyword-1,case-fold" "BOOLEAN")
    (modify-syntax-table "keyword-1,case-fold" "CAND")
    (modify-syntax-table "keyword-1,case-fold" "CASE")
    (modify-syntax-table "keyword-1,case-fold" "CHR")
    (modify-syntax-table "keyword-1,case-fold" "CONST")
    (modify-syntax-table "keyword-1,case-fold" "COR")
    (modify-syntax-table "keyword-1,case-fold" "DIV")
    (modify-syntax-table "keyword-1,case-fold" "DO")
    (modify-syntax-table "keyword-1,case-fold" "DOWNTO")
    (modify-syntax-table "keyword-1,case-fold" "ELSE")
    (modify-syntax-table "keyword-1,case-fold" "END")
    (modify-syntax-table "keyword-1,case-fold" "EXIT")
    (modify-syntax-table "keyword-1,case-fold" "EXPORTS")
    (modify-syntax-table "keyword-1,case-fold" "FALSE")
    (modify-syntax-table "keyword-1,case-fold" "FILE")
    (modify-syntax-table "keyword-1,case-fold" "FOR")
    (modify-syntax-table "keyword-1,case-fold" "FORWARD")
    (modify-syntax-table "keyword-1,case-fold" "FROM")
    (modify-syntax-table "keyword-1,case-fold" "FUNCTION")
    (modify-syntax-table "keyword-1,case-fold" "FUNCTION")
    (modify-syntax-table "keyword-1,case-fold" "GET")
    (modify-syntax-table "keyword-1,case-fold" "GOTO")
    (modify-syntax-table "keyword-1,case-fold" "IF")
    (modify-syntax-table "keyword-1,case-fold" "IMPORTS")
    (modify-syntax-table "keyword-1,case-fold" "IN")
    (modify-syntax-table "keyword-1,case-fold" "INPUT")
    (modify-syntax-table "keyword-1,case-fold" "INTEGER")
    (modify-syntax-table "keyword-1,case-fold" "LABEL")
    (modify-syntax-table "keyword-1,case-fold" "LONG")
    (modify-syntax-table "keyword-1,case-fold" "MOD")
    (modify-syntax-table "keyword-1,case-fold" "MODULE")
    (modify-syntax-table "keyword-1,case-fold" "NEW")
    (modify-syntax-table "keyword-1,case-fold" "NIL")
    (modify-syntax-table "keyword-1,case-fold" "NOT")
    (modify-syntax-table "keyword-1,case-fold" "OF")
    (modify-syntax-table "keyword-1,case-fold" "OR")
    (modify-syntax-table "keyword-1,case-fold" "ORD")
    (modify-syntax-table "keyword-1,case-fold" "OTHERWISE")
    (modify-syntax-table "keyword-1,case-fold" "OUTPUT")
    (modify-syntax-table "keyword-1,case-fold" "PACKED")
    (modify-syntax-table "keyword-1,case-fold" "PRIVATE")
    (modify-syntax-table "keyword-1,case-fold" "PROCEDURE")
    (modify-syntax-table "keyword-1,case-fold" "PROCEDURE")
    (modify-syntax-table "keyword-1,case-fold" "PROGRAM")
    (modify-syntax-table "keyword-1,case-fold" "PUT")
    (modify-syntax-table "keyword-1,case-fold" "READ")
    (modify-syntax-table "keyword-1,case-fold" "READLN")
    (modify-syntax-table "keyword-1,case-fold" "REAL")
    (modify-syntax-table "keyword-1,case-fold" "RECORD")
    (modify-syntax-table "keyword-1,case-fold" "REPEAT")
    (modify-syntax-table "keyword-1,case-fold" "RESET")
    (modify-syntax-table "keyword-1,case-fold" "REWRITE")
    (modify-syntax-table "keyword-1,case-fold" "SET")
    (modify-syntax-table "keyword-1,case-fold" "STRING")
    (modify-syntax-table "keyword-1,case-fold" "TEXT")
    (modify-syntax-table "keyword-1,case-fold" "THEN")
    (modify-syntax-table "keyword-1,case-fold" "TO")
    (modify-syntax-table "keyword-1,case-fold" "TRUE")
    (modify-syntax-table "keyword-1,case-fold" "TYPE")
    (modify-syntax-table "keyword-1,case-fold" "UNTIL")
    (modify-syntax-table "keyword-1,case-fold" "VAR")
    (modify-syntax-table "keyword-1,case-fold" "WHILE")
    (modify-syntax-table "keyword-1,case-fold" "WITH")
    (modify-syntax-table "keyword-1,case-fold" "WRITE")
    (modify-syntax-table "keyword-1,case-fold" "WRITELN")

    (modify-syntax-table "keyword-1,case-fold" "NATIVE")
    (modify-syntax-table "keyword-1,case-fold" "BIND")

    (modify-syntax-table "keyword-2" ":=")
    (modify-syntax-table "keyword-2" "^")
    (modify-syntax-table "keyword-2" "<")
    (modify-syntax-table "keyword-2" ">")

    (modify-syntax-table "comment" "{" "}")
    (modify-syntax-table "comment" "(*" "*)")
    (modify-syntax-table "string" "'")

    (define-keymap "Pascal-keymap")
    (use-local-map "Pascal-keymap")
    (if (error-occurred (execute-mlisp-file "pascal.key"))
        (Do-Pascal-Bindings)
    )
    (delete-buffer "~pascal")
    (novalue)
)
