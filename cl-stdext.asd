(in-package :cl-user)

(defpackage :cl-stdext-asd
  (:use :asdf :cl))

(in-package :cl-stdext-asd)

(defsystem :cl-stdext
           :name "CL-STDEXT"
           :description "A Complementary to the Standard Library of Common Lisp."
           :version "0.0.1"
           :components (
                        (:file "core")
                        )
           )
