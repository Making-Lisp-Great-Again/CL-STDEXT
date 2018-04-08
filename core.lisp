;;;; -*- coding:utf-8 -*-

(in-package :cl-user)

(defpackage :cl-stdext
  (:use :cl)
  (:shadow :let)
  (:export :let
           :bind
           :aif
           :rif
           :->
           :id
           )
  )

(in-package :cl-stdext)

(defun id (x)
  "Return the argument itself."
  x)

(defmacro lm (sym &body body)
  "A shorthand for lambda with only one argument."
  `(lambda (,sym) ,@body))

;; Thanks to Leo Song Wei
(defmacro let (bindings &body body)
  "Allows LET to be able to deal with multiple values naturally."
  (cl:let* ((bind (car bindings))
            (varlst (butlast bind))
            (vals (car (last bind)))
            (leftover (cdr bindings)))
           (if leftover
             `(multiple-value-bind ,varlst ,vals (cl-stdext:let ,leftover ,@body))
             `(multiple-value-bind ,varlst ,vals ,@body))))

(defmacro bind (sym val &body body)
  "Create a single bind, equivalent to (let ((sym val)) body)."
  `(cl:let ((,sym ,val)) ,@body))

(defmacro aif (val then &body body)
  "If the given value is true, return (then val), otherwise the body is evaluated and returned."
  `(if ,val
     ,`(funcall ,then ,val)
     ,`(progn ,@body)))

(defmacro rif (val &body body)
  "If the given value is true, return it, otherwise the body is evaluated and returned."
  `(aif ,val #'id ,@body))

(defmacro -> (val &body body)
  "Thread-first, as you have seen in Clojure."
  (cl:let ((f (car body))
           (leftover (cdr body)))
          (if f
            `(-> ,`(funcall ,f ,val) ,@leftover)
            val)))
