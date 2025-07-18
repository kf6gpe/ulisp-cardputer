;;; Minimal uLisp-compatible hexadecimal conversion functions

;;; Helper function to get hex digit character (0-15 -> '0'-'9','A'-'F')
(defun hex-digit (n)
  (if (< n 10)
      (+ n 48)    ; ASCII '0' to '9'
      (+ n 55)))  ; ASCII 'A' to 'F' (55 = 65 - 10)

;;; Function to convert decimal integer to hexadecimal string
(defun decimal-to-hex (n)
  (if (= n 0)
      '(48)  ; Return list containing ASCII '0'
      (if (< n 0)
          (cons 45 (decimal-to-hex (- n)))  ; 45 is ASCII '-'
          (if (< n 16)
              (list (hex-digit n))
              (append (decimal-to-hex (/ n 16))
                     (list (hex-digit (mod n 16))))))))

;;; Helper function to convert hex character code to digit value
(defun hex-char-to-digit (code)
  (cond ((and (>= code 48) (<= code 57))   ; '0' to '9'
         (- code 48))
        ((and (>= code 65) (<= code 70))   ; 'A' to 'F'
         (+ (- code 65) 10))
        ((and (>= code 97) (<= code 102))  ; 'a' to 'f'
         (+ (- code 97) 10))
        (t nil)))

;;; Function to convert hexadecimal string (as list of ASCII codes) to decimal
(defun hex-to-decimal (hex-codes)
  (let ((value 0)
        (codes hex-codes)
        (sign 1))
    ;; Check for negative sign
    (when (and codes (= (first codes) 45))  ; 45 is ASCII '-'
      (setf sign -1)
      (setf codes (rest codes)))
    ;; Process each character code
    (dolist (code codes)
      (let ((digit (hex-char-to-digit code)))
        (if digit
            (setf value (+ (* value 16) digit))
            (return nil))))  ; Return nil for invalid input
    (* sign value)))

;;; Convenience functions for string input/output (if your uLisp supports them)
;;; Convert string to list of character codes
(defun string-to-codes (str)
  (if str
      (mapcar (lambda (c) (char-code c)) (coerce str 'list))
      nil))

;;; Convert list of character codes to string
(defun codes-to-string (codes)
  (if codes
      (coerce (mapcar (lambda (code) (code-char code)) codes) 'string)
      ""))

;;; Wrapper functions that work with strings (if supported)
(defun dec-to-hex-string (n)
  (codes-to-string (decimal-to-hex n)))

(defun hex-string-to-dec (hex-str)
  (hex-to-decimal (string-to-codes hex-str)))

;;; Test examples for core functions:
;;; (decimal-to-hex 255)   ; Should return (70 70) which is "FF"
;;; (hex-to-decimal '(70 70))  ; Should return 255
;;; 
;;; If string functions work:
;;; (dec-to-hex-string 255)    ; Should return "FF" 
;;; (hex-string-to-dec "FF")   ; Should return 255