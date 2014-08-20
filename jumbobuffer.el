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
;; `read-from-minibuffer' but ignores all arguments besides PROMPT.
;;
;; To finish input, type `C-c C-c'.

;;; Code:


(defvar jumbobuffer--prompt)
(defvar jumbobuffer--ret)

(define-derived-mode jumbobuffer-mode text-mode "jumbobuffer-mode"
  "Mode for editing the jumbobuffer"
  (setq header-line-format prompt)
  (force-mode-line-update))

(define-key jumbobuffer-mode-map
  (kbd "C-c C-c") 'jumbobuffer--finish)

(defun jumbobuffer--finish ()
  (interactive)
  (setq jumbobuffer--ret (buffer-substring-no-properties 1 (point-max)))
  (erase-buffer)
  (bury-buffer)
  (delete-window)
  (throw 'exit nil))

(defun read-from-jumbobuffer (prompt &optional initial-contents keymap read hist default-value inherit-input-method)
  (select-window (split-window-vertically -6))
  (switch-to-buffer (get-buffer-create "*jumbobuffer*"))
  (setq jumbobuffer--prompt prompt)
  (jumbobuffer-mode)
  (recursive-edit)
  jumbobuffer--ret)

(provide 'jumbobuffer)
