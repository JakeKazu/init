;;更新日 2016/05/09

;;;;;;;;;;色についてのセクション;;;;;;;;;;
;;基本的な文字, 背景など
(set-background-color "black") ;背景色
(set-foreground-color "white")  ;文字色

;; 透明度を変更するコマンド M-x set-alpha
;; http://qiita.com/marcy@github/items/ba0d018a03381a964f24
(defun set-alpha (alpha-num)
  "set frame parameter 'alpha"
  (interactive "nAlpha: ")
  (set-frame-parameter nil 'alpha (cons alpha-num '(85))))

;;タブと全角スペース、行末の半角スペースの可視化
(defface my-face-b-1 '((t (:background "NavajoWhite4"))) nil) ; 全角スペース
(defface my-face-b-2 '((t (:background "gray10"))) nil) ; タブ
(defface my-face-u-1 '((t (:background "SteelBlue" :underline t))) nil) ; 行末空白
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
(font-lock-add-keywords
 major-mode
 '(("\t" 0 my-face-b-2 append)
 ("　" 0 my-face-b-1 append)
 ("[ \t]+$" 0 my-face-u-1 append)
 )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
;;;;;;;;;;色のセクションおわり;;;;;;;;;;

;;yes/no を y/n に
(fset 'yes-or-no-p 'y-or-n-p)

;;時計
(setq display-time-string-forms
      '((format "%s/%s/%s(%s) %s:%s "
		year month day dayname 24-hours minutes)
	load
	(if mail " Mail" "")))
(display-time)
(setq display-time-kawakami-form t)
(setq display-time-24hr-format t)

;;Emacs24のパッケージ管理機能 M-x package-list-packages
(require 'package)
(add-to-list 'package-archives '("melpa"."http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade"."http://marmalade-repo.org/packages/"))
(package-initialize)

;;evil emacsをvimのごとく使う
(require 'evil)
(evil-mode 1)
(setcdr evil-insert-state-map nil) ;;insertモード中はevilはロック
(define-key evil-insert-state-map [escape] 'evil-normal-state);;ロック中でもescは有効

;;git-gutter 差分表示
(global-git-gutter-mode t)

;;org-mode
;; org-modeの初期化
(require 'org-install)
;; キーバインドの設定
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cr" 'org-remember)
;; 拡張子がorgのファイルを開いた時，自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; org-modeでの強調表示を可能にする
(add-hook 'org-mode-hook 'turn-on-font-lock)
;; 見出しの余分な*を消す
(setq org-hide-leading-stars t)
;; org-default-notes-fileのディレクトリ
(setq org-directory "~/org/")
;; org-default-notes-fileのファイル名
(setq org-default-notes-file "notes.org")

;;自動補完 auto-complete
;必須
(require 'auto-complete-config)
(ac-config-default)
;その他
(setq ac-use-menu-map t)

;;;;;;文法チェック flymake;;;;;
(require 'flymake)
;ハイライト色
(require 'fringe-helper)

(set-face-background 'flymake-errline nil)    ;既存のフェイスを無効にする
(set-face-foreground 'flymake-errline nil)
(set-face-background 'flymake-warnline nil)
(set-face-foreground 'flymake-warnline nil)

(make-face 'my-flymake-warning-face)
(set-face-foreground 'my-flymake-warning-face "yellow")
(set-face-background 'my-flymake-warning-face "black")
(setq my-flymake-warning-face 'my-flymake-warning-face)

(defvar flymake-fringe-overlays nil)
(make-variable-buffer-local 'flymake-fringe-overlays)

(defadvice flymake-make-overlay (after add-to-fringe first
                                       (beg end tooltip-text face mouse-face)
                                       activate compile)
  (push (fringe-helper-insert-region
           beg end
           (fringe-lib-load (if (eq face 'flymake-errline)
                                fringe-lib-exclamation-mark
                              fringe-lib-question-mark))
           'left-fringe 'my-flymake-warning-face)
           ;; 'left-fringe 'font-lock-warning-face)
        flymake-fringe-overlays))

(defadvice flymake-delete-own-overlays (after remove-from-fringe activate
                                              compile)
  (mapc 'fringe-helper-remove flymake-fringe-overlays)
  (setq flymake-fringe-overlays nil))

;ruby有効（今はできていない）

;c/c++有効
(defun flymake-cc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))

(push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
(add-hook 'c++-mode-hook
          '(lambda()
             (flymake-mode t)
             (flymake-cursor-mode t)
             (setq flymake-check-was-interrupted t)
             (local-set-key "\C-c\C-v" 'flymake-start-syntax-check)
             (local-set-key "\C-c\C-p" 'flymake-goto-prev-error)
             (local-set-key "\C-c\C-n" 'flymake-goto-next-error)
          )
)

;java
(defun my-java-flymake-init ()
  (list "javac" (list (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-with-folder-structure))))
(add-to-list 'flymake-allowed-file-name-masks '("\\.java$" my-java-flymake-init flymake-simple-cleanup))
(add-hook 'java-mode-hook 'flymake-mode-on)

;ミニバッファにエラー文表示（カーソルをかざす）
(defun flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help (message "%s" help)))))
(add-hook 'post-command-hook 'flymake-show-help)

;;;;;;文法チェック flymake おわり;;;;;

;;{とうつと}, "とうつと"のように対応する文字を自動入力
(electric-pair-mode t)
(add-to-list 'electric-pair-pairs '(?| . ?|))
(add-to-list 'electric-layout-rules '(?{ . after)) ;{の後に改行を挿入}

;;ファイルのフルパスをタイトルバーに表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))


;;括弧の中を強調表示
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face "#4123AA") ;括弧の範囲色

;;深さレベル括弧色分け
; rainbow-delimiters を使うための設定
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
; 括弧の色を強調する設定
(require 'cl-lib)
(require 'color)
(defun rainbow-delimiters-using-stronger-colors ()
  (interactive)
  (cl-loop
   for index from 1 to rainbow-delimiters-max-face-count
   do
   (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
    (cl-callf color-saturate-name (face-foreground face) 30))))
(add-hook 'emacs-startup-hook 'rainbow-delimiters-using-stronger-colors)

;;;;;;;;;;各種機能;;;;;;;;;;
(setq inhibit-startup-screen t) ;スタートメニュー非表示
;;(scroll-bar-mode 0)
(setq kill-whole-line t) ;C-kで行全体を削除
(setq delete-auto-save-files t) ;終了時にオートセーブファイルを消す
(global-linum-mode) ;;; 行の表示(バッファー)
(line-number-mode t) ;行の表示(モードライン)
(column-number-mode t) ;何文字目かを表示(モードライン)
(scroll-bar-mode 0) ;スクロールバーを消す
(icomplete-mode t) ;バッファー移動時にミニウィンドウに候補を表示
(set-frame-parameter nil 'alpha 85)

;;browse-kill-ring
(require 'browse-kill-ring)
(define-key ctl-x-map "\C-y" 'browse-kill-ring)

;;C-x,C-c,C-v
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(display-time-mode t)
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
