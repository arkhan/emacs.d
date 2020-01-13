;;; init.el --- Emacs Configuration -*- lexical-binding: t -*-
;;; Commentary:
;; This config start here

(defvar cfg--file-name-handler-alist file-name-handler-alist)
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      file-name-handler-alist nil)

(defvar conf:cache-dir (concat user-emacs-directory "cache/"))
(unless (file-exists-p conf:cache-dir)
  (make-directory conf:cache-dir))

(setq nsm-settings-file (concat conf:cache-dir "network-security.data"))
(setq network-security-level 'high)

(setq straight-repository-branch "develop"
      straight-base-dir conf:cache-dir
      straight-check-for-modifications '(check-on-save-find-when-checking))
      ;;straight-vc-git-default-clone-depth 100)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" conf:cache-dir))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(require 'straight-x)

;; Removes in-build version from the `load-path'
(when-let (orglib (locate-library "org" nil load-path))
   (setq-default load-path (delete (substring (file-name-directory orglib) 0 -1)
                                   load-path)))
(straight-use-package
 '(org-plus-contrib
   :repo "https://code.orgmode.org/bzg/org-mode.git"
   :local-repo "org"
   :files (:defaults "contrib/lisp/*.el")
   :includes (org)))

(straight-use-package 'literate-elisp)
(require 'literate-elisp)
(literate-elisp-load (expand-file-name "README.org" user-emacs-directory))

;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216
                  gc-cons-percentage 0.1
                  file-name-handler-alist cfg--file-name-handler-alist)))
(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
