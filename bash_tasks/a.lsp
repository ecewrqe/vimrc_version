#!/usr/bin/emacs --script

(defun test-fmt()
  (message "HELLO")
)
(test-fmt)

(defun fib (n)
  "Return the nth Fibonacci number."
  (if (< n 2)
    n
    (+ (fib (- n 1))
        (fib (- n 2))
    )
  )
)
(print (length '(a b c d)))