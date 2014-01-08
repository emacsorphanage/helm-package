;;; helm-package.el --- Listing ELPA packages with helm interface

;; Copyright (C) 2012 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/emacs-helm-package
;; Package-Requires: ((helm "1.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(eval-when-compile
  (require 'cl))

(require 'helm)
(require 'package)

(defun helm-c-package-installed-packages (pred)
  (let ((copyed (copy-sequence package-archive-contents)))
    (loop with sorted = (sort copyed (lambda (a b)
                                       (string< (car a) (car b))))
          with regexp = "\\s-*\\[source:[^\]]+\\]\\s-*"
          for candidate in sorted
          for package = (symbol-name (car candidate))
          for name = (if (> (length package) 30)
                         (concat (substring package 0 27) "...")
                       package)
          for desc = (replace-regexp-in-string regexp ""
                                               (aref (cdr candidate) 2))
          when (funcall pred (car candidate))
          collect
          (cons (format "%-30s| %s"
                        name
                        (truncate-string-to-width desc (- (frame-width) 32)))
                package))))

(defun helm-c-package-install (candidate)
  (loop for package in (helm-marked-candidates)
        do
        (package-install (intern package))))

(defun helm-c-package-initialize ()
  (unless package--initialized
    (package-initialize t)))

(defvar helm-c-package-available-source
  '((name . "Available Packageshelm available packages")
    (init . helm-c-package-initialize)
    (candidates . (lambda ()
                    (helm-c-package-installed-packages
                     (lambda (e) (not (assoc e package-alist))))))
    (candidate-number-limit . 9999)
    (action . helm-c-package-install)
    (volatile)))

(defvar helm-c-package-installed-source
  '((name . "Installed Packages")
    (init . helm-c-package-initialize)
    (candidates . (lambda ()
                    (helm-c-package-installed-packages
                     (lambda (e) (assoc e package-alist)))))
    (candidate-number-limit . 9999)
    (action . helm-c-package-install)
    (volatile)))

;;;###autoload
(defun helm-package (arg)
  (interactive "P")
  (when current-prefix-arg
    (package-refresh-contents))
  (let ((buf (get-buffer-create "*helm-package*")))
    (helm :sources '(helm-c-package-available-source helm-c-package-installed-source)
          :buffer buf)))

(provide 'helm-package)

;;; helm-package.el ends here
