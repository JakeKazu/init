;;更新日 2016/12/25

;;Emacs24のパッケージ管理機能 M-x package-list-packages
(require 'package)
(add-to-list 'package-archives '("melpa"."http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade"."http://marmalade-repo.org/packages/"))
(package-initialize)
;;load-path
(add-to-list 'load-path "~/.emacs.d/install")
(add-to-list 'load-path "~/.emacs.d/install/original")
(add-to-list 'load-path "~/.emacs.d/install/mode-line")

;;use-package
(require 'use-package)

;;パッケージごとの起動時間チェック
;(require 'set-initchart)

;; gnuplot-mode
(require 'gnuplot-mode)
;; specify the gnuplot executable (if other than /usr/bin/gnuplot)
(setq gnuplot-program "/sw/bin/gnuplot")
;; automatically open files ending with .gp or .gnuplot in gnuplot mode
(setq auto-mode-alist
(append '(("\\.\\(gp\\|gnuplot\\)$" . gnuplot-mode)) auto-mode-alist))

;;色についてのセクション
(require 'set-color)

;;evil emacsをvimのごとく使う
(require 'set-evil)

;;helm
(require 'set-helm)

;;tabbar
(require 'set-tabbar)

;;minimap M-x minimap-mode
(require 'minimap)

;;git-gutter 差分表示
(require 'git-gutter-fringe)
(require 'fringe-helper)
(require 'smartrep)
(global-git-gutter-mode t)
(smartrep-define-key
    global-map  "C-x" '(("p" . 'git-gutter:previous-hunk)
                        ("n" . 'git-gutter:next-hunk)))

;;magit -emacsでgitを使う-
;(require 'magit)

;;web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist
'(("php"    . "\\.phtml\\'")
  ("blade"  . "\\.blade\\.")))

;;Latex
;;yatex
(require 'yatex)
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
        ("\\.ltx$" . yatex-mode)
        ("\\.sty$" . yatex-mode)) auto-mode-alist))
;; set YaTeX coding system
(setq YaTeX-kanji-code 4) ; UTF-8 の設定
(add-hook 'yatex-mode-hook
      '(lambda ()
         (setq YaTeX-use-AMS-LaTeX t) ; align で数式モードになる
         (setq YaTeX-use-hilit19 nil
           YateX-use-font-lock t)
         ; (setq tex-command "em-latexmk.sh") ; typeset command
         (setq dvi2-command "evince") ; preview command
         ;(setq tex-pdfview-command "xdg-open")
 )) ; preview command

;;自動補完
;(require 'set-auto-compelte)
(require 'set-company)

;;文法チェック
(require 'set-flycheck)
(require 'set-flymake)

;;ruby設定
(require 'set-ruby)


;;go設定
(require 'set-go)

;;括弧の設定
(require 'set-brackets)

;;;;;;;;;;各種機能;;;;;;;;;;
;;他の環境で使用するとmozcの設定でエラー出る可能性あり
(require 'set-else)

;;C-x,C-c,C-v
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-display-errors-function (function flycheck-pos-tip-error-messages))
 '(package-selected-packages
   (quote
    (flycheck-mypy yatex web-mode twittering-mode smartrep ruby-test-mode ruby-electric ruby-block rubocop robe rainbow-mode rainbow-delimiters python-mode pyflakes projectile magit helm git-gutter-fringe git-gutter-fringe+ flymake-ruby flymake-python-pyflakes flymake flycheck-pos-tip flycheck-irony flx evil enh-ruby-mode elpy company-jedi company-irony company-inf-ruby browse-kill-ring auto-complete))))
