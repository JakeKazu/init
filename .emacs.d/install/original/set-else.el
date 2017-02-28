(provide 'set-else)

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

;; タブの無効化
(setq-default indent-tabs-mode nil)

;; キーボード入力の文字コード
(set-keyboard-coding-system 'utf-8-unix)
;; サブプロセスのデフォルト文字コード
(setq default-process-coding-system '(undecided-dos . utf-8-unix))
;; 環境依存文字 文字化け対応
(set-charset-priority 'ascii 'japanese-jisx0208 'latin-jisx0201
                      'katakana-jisx0201 'iso-8859-1 'cp1252 'unicode)
(set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932)

;; フォントサイズ調整
(global-set-key (kbd "C-<wheel-up>")   '(lambda() (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C-=")            '(lambda() (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C-<wheel-down>") '(lambda() (interactive) (text-scale-decrease 1)))
(global-set-key (kbd "C--")            '(lambda() (interactive) (text-scale-decrease 1)))
;; フォントサイズ リセット
(global-set-key (kbd "M-0") '(lambda() (interactive) (text-scale-set 0)))

;; フルスクリーン化
(global-set-key (kbd "<M-return>") 'toggle-frame-fullscreen)

;;その他
(setq inhibit-startup-screen t) ;スタートメニュー非表示
(setq kill-whole-line t) ;C-kで行全体を削除
(setq delete-auto-save-files t) ;終了時にオートセーブファイルを消す
(global-linum-mode) ;;; 行の表示(バッファー)
(column-number-mode t) ;何文字目かを表示(モードライン)
(line-number-mode t) ;行の表示(モードライン)
(scroll-bar-mode 0) ;スクロールバーを消す
(icomplete-mode t) ;バッファー移動時にミニウィンドウに候補を表示
(set-frame-parameter nil 'alpha 85)



;;browse-kill-ring
(require 'browse-kill-ring)
(define-key ctl-x-map "\C-y" 'browse-kill-ring)
