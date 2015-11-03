;;; jumbobuffer.el --- jumbo-size minibuffer

;; Copyright (C) 2014, Mitchel Humpherys

;; Author: Mitchel Humpherys <mitch.special@gmail.com>
;; Keywords: tools, convenience
;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; jumbobuffer provides a function (`read-from-jumbobuffer') for reading
;; multi-line input from a temporary buffer at the bottom of the current
;; window. It's like the minibuffer, but jumbo.

;;; Installation:

;; Put this file on your load-path and do:
;;
;;     (require 'jumbobuffer)

;;; Usage:

;; The main function provided by this package is
;; `read-from-jumbobuffer'. It has the same call signature as
;; `read-from-minibuffer' but ignores all arguments besides `PROMPT' and
;; `INITIAL-CONTENTS'.
;;
;; To finish input, type `C-c C-c`.

;;; Code:


(defvar jumbobuffer--prompt nil)
(defvar jumbobuffer--ret nil)
(defvar jumbobuffer--initial nil)

(define-derived-mode jumbobuffer-mode text-mode "jumbobuffer-mode"
  "Mode for editing the jumbobuffer"
  (setq header-line-format (format "%s -- [C-c C-c to finish]" prompt))
  (force-mode-line-update)
  (erase-buffer)
  (when jumbobuffer--initial
    (insert jumbobuffer--initial)))

(define-key jumbobuffer-mode-map
  (kbd "C-c C-c") 'jumbobuffer--finish)

(defun jumbobuffer--finish ()
  (interactive)
  (setq jumbobuffer--ret (buffer-substring-no-properties 1 (point-max)))
  (bury-buffer)
  (delete-window)
  (throw 'exit nil))

;;;###autoload
(defun read-from-jumbobuffer (prompt &optional initial-contents keymap
                                     read hist default-value
                                     inherit-input-method)
  "Like `read-from-minibuffer', but with multi-line input"
  (select-window (split-window-vertically -6))
  (switch-to-buffer (get-buffer-create "*jumbobuffer*"))
  (setq jumbobuffer--prompt prompt)
  (setq jumbobuffer--initial initial-contents)
  (jumbobuffer-mode)
  (recursive-edit)
  jumbobuffer--ret)

(provide 'jumbobuffer)
