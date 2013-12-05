;; OS CHECK
(defvar os-type nil)
(cond ((string-match "apple-darwin" system-configuration) ;; Mac
       (setq os-type 'mac))
      ((string-match "linux" system-configuration)        ;; Linux
       (setq os-type 'linux))
      ((string-match "freebsd" system-configuration)      ;; FreeBSD
       (setq os-type 'bsd))
      ((string-match "mingw" system-configuration)        ;; Windows
       (setq os-type 'win)))

;; ホスト名
(setq hostname (system-name))

;; C-hでバックスペース
(global-set-key "\C-h" 'backward-delete-char)
;; C-xhでヘルプ
(global-set-key "\C-xh" 'help-command)
;; C-zでundo
(global-set-key "\C-z" 'undo)
;; C-\でundo
(global-set-key "\C-\\" 'undo)
;; かんな風に
(global-set-key "\C-o" 'toggle-input-method)
; 対応するかっこをハイライト
(show-paren-mode t)
; 画面外の場合は中身に色を付ける
(setq show-paren-style 'mixed)

;;; メニューバーを消す
(menu-bar-mode -1)
;;; ツールバーを消す
(tool-bar-mode -1)

;; パッケージ
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; Perl デバッガの設定
(autoload 'perl-debug "perl-debug" nil t)
(autoload 'perl-debug-lint "perl-debug" nil t)

(defalias 'perl-mode 'cperl-mode)

;; C-c compile
(add-hook 'cperl-mode-hook
          '(lambda ()
             (make-local-variable 'compile-command)
             (setq compile-command
                   (concat "perl " (buffer-file-name)))
             (cperl-define-key "\C-c\C-c" 'compile)
;             (cperl-define-key "\C-h" 'backward-delete-char)
             (define-key cperl-mode-map (kbd "C-h") 'delete-backward-char)
             (local-unset-key "\C-h")
             (cperl-define-key "\C-c\C-x" 'match-paren)
             ))

(setq auto-mode-alist
      (append 
       '(("\\.\\(pl\\|pm\\|cgi\\|t\\)$" . cperl-mode)
         ("\\.\\(html\\|htm\\|tt\\)$" . html-mode)
         ("\\.\\(wsf\\)$" . xml-mode)
         )
       auto-mode-alist))


;; match-paren
(global-set-key "\C-c\C-x" 'match-paren)
(defun match-paren(arg)
  (interactive "p")
  (cond
   ((looking-at "[[({]")
    (forward-sexp)
    (backward-char))
   ((looking-at "[])}]")
    (forward-char)
    (backward-sexp))
   ;; Cのコメントもいっちゃうよ
   ((or (looking-at "/\\*")
        (and (looking-at "\\*")
             (string= (buffer-substring (1- (point)) (point)) "/")))
    (re-search-forward "\\*/")
    (backward-char))
   ((or (looking-at "\\*/")
        (and (looking-at "/")
             (string= (buffer-substring (1- (point)) (point)) "*")))
    (re-search-backward "/\\*"))
   (t
    (message "括弧じゃないよ"))))

;; tag-jump
(global-set-key "\C-c\C-j" 'tag-jump)
(defun tag-jump(arg)
  (interactive "p")
  (let (filename line-no)
    (save-excursion
      (let* (
             ;; 現在のカーソル位置取得
             (po (point))
             ;; 行頭の位置取得
             (line-beg
              (progn
                (beginning-of-line)
                (point)))
             ;; 行末の位置取得
             (line-end
              (progn
                (end-of-line)
                (point)))
             ;; ファイル名の開始位置取得
             (file-beg
              (max 
               (or (and (goto-char po)
                        (re-search-backward "[\" ]" t)
                        (point))
                   line-beg)
               line-beg))
             ;; ファイル名の終了位置の取得
             (file-end
              (min
               (or (and (goto-char file-beg)
                        (and (looking-at "[A-Za-z]:")
                             (forward-char 2))
                        (re-search-forward "[:\# ()]" t)
                        (point))
                   line-end)
               line-end))
             ;; 行番号の開始位置の取得
             (line-beg
              (when (re-search-forward "[0-9]" t)
                (point)))
             ;; 行番号の終了位置の取得
             (line-end
              (when (re-search-forward "[^0-9]" t)
                (point))))
        ;; ファイル名の取得
        (setq filename
              (buffer-substring file-beg file-end)
              ;; 行番号の取得
              line-no
              (parse-integer
               (when (and line-beg line-end)
                 (buffer-substring
                  line-beg line-end))))))
    ;; ファイルのオープン
    (cond
     ((file-readable-p filename)
      (find-file-other-window filename)
      ;; 指定行への移動
      (cond
       (line-no
        (goto-line line-no)
        (message (format nil "ファイル~aの~a行目を表示します" filename line-no)))
       (t
        (message (format nil "ファイル~aを表示します" filename)))))
     (t
      ;; ファイルが読めない場合エラーにする
      (message (format nil "ファイル~aが読み込めません" filename))))
    ))


(cond 
 ((not (string< mule-version "6.0"))
  ;; encode-translation-table の設定
  (coding-system-put 'euc-jp :encode-translation-table
             (get 'japanese-ucs-cp932-to-jis-map 'translation-table))
  (coding-system-put 'iso-2022-jp :encode-translation-table
             (get 'japanese-ucs-cp932-to-jis-map 'translation-table))
  (coding-system-put 'cp932 :encode-translation-table
             (get 'japanese-ucs-jis-to-cp932-map 'translation-table))
  ;; charset と coding-system の優先度設定
  (set-charset-priority 'ascii 'japanese-jisx0208 'latin-jisx0201
            'katakana-jisx0201 'iso-8859-1 'cp1252 'unicode)
  (set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932)
  ;; PuTTY 用の terminal-coding-system の設定
  (apply 'define-coding-system 'utf-8-for-putty
     "UTF-8 (translate jis to cp932)"
     :encode-translation-table 
     (get 'japanese-ucs-jis-to-cp932-map 'translation-table)
     (coding-system-plist 'utf-8))
  (set-terminal-coding-system 'utf-8-for-putty)
  ;; East Asian Ambiguous
  (defun set-east-asian-ambiguous-width (width)
    (while (char-table-parent char-width-table)
      (setq char-width-table (char-table-parent char-width-table)))
    (let ((table (make-char-table nil)))
      (dolist (range 
           '(#x00A1 #x00A4 (#x00A7 . #x00A8) #x00AA (#x00AD . #x00AE)
            (#x00B0 . #x00B4) (#x00B6 . #x00BA) (#x00BC . #x00BF)
            #x00C6 #x00D0 (#x00D7 . #x00D8) (#x00DE . #x00E1) #x00E6
            (#x00E8 . #x00EA) (#x00EC . #x00ED) #x00F0 
            (#x00F2 . #x00F3) (#x00F7 . #x00FA) #x00FC #x00FE
            #x0101 #x0111 #x0113 #x011B (#x0126 . #x0127) #x012B
            (#x0131 . #x0133) #x0138 (#x013F . #x0142) #x0144
            (#x0148 . #x014B) #x014D (#x0152 . #x0153)
            (#x0166 . #x0167) #x016B #x01CE #x01D0 #x01D2 #x01D4
            #x01D6 #x01D8 #x01DA #x01DC #x0251 #x0261 #x02C4 #x02C7
            (#x02C9 . #x02CB) #x02CD #x02D0 (#x02D8 . #x02DB) #x02DD
            #x02DF (#x0300 . #x036F) (#x0391 . #x03A9)
            (#x03B1 . #x03C1) (#x03C3 . #x03C9) #x0401 
            (#x0410 . #x044F) #x0451 #x2010 (#x2013 . #x2016)
            (#x2018 . #x2019) (#x201C . #x201D) (#x2020 . #x2022)
            (#x2024 . #x2027) #x2030 (#x2032 . #x2033) #x2035 #x203B
            #x203E #x2074 #x207F (#x2081 . #x2084) #x20AC #x2103
            #x2105 #x2109 #x2113 #x2116 (#x2121 . #x2122) #x2126
            #x212B (#x2153 . #x2154) (#x215B . #x215E) 
            (#x2160 . #x216B) (#x2170 . #x2179) (#x2190 . #x2199)
            (#x21B8 . #x21B9) #x21D2 #x21D4 #x21E7 #x2200
            (#x2202 . #x2203) (#x2207 . #x2208) #x220B #x220F #x2211
            #x2215 #x221A (#x221D . #x2220) #x2223 #x2225
            (#x2227 . #x222C) #x222E (#x2234 . #x2237)
            (#x223C . #x223D) #x2248 #x224C #x2252 (#x2260 . #x2261)
            (#x2264 . #x2267) (#x226A . #x226B) (#x226E . #x226F)
            (#x2282 . #x2283) (#x2286 . #x2287) #x2295 #x2299 #x22A5
            #x22BF #x2312 (#x2460 . #x24E9) (#x24EB . #x254B)
            (#x2550 . #x2573) (#x2580 . #x258F) (#x2592 . #x2595) 
            (#x25A0 . #x25A1) (#x25A3 . #x25A9) (#x25B2 . #x25B3)
            (#x25B6 . #x25B7) (#x25BC . #x25BD) (#x25C0 . #x25C1)
            (#x25C6 . #x25C8) #x25CB (#x25CE . #x25D1) 
            (#x25E2 . #x25E5) #x25EF (#x2605 . #x2606) #x2609
            (#x260E . #x260F) (#x2614 . #x2615) #x261C #x261E #x2640
            #x2642 (#x2660 . #x2661) (#x2663 . #x2665) 
            (#x2667 . #x266A) (#x266C . #x266D) #x266F #x273D
            (#x2776 . #x277F) (#xE000 . #xF8FF) (#xFE00 . #xFE0F) 
            #xFFFD
            ))
    (set-char-table-range table range width))
      (optimize-char-table table)
      (set-char-table-parent table char-width-table)
      (setq char-width-table table)))
  (set-east-asian-ambiguous-width 2)
  ;; 機種依存文字
;;  (require 'cp5022x)
  ))
;; emacs-w3m
(eval-after-load "w3m"
  '(when (coding-system-p 'cp51932)
     (add-to-list 'w3m-compatible-encoding-alist '(euc-jp . cp51932))))
;; Gnus
(eval-after-load "mm-util"
  '(when (coding-system-p 'cp50220)
     (add-to-list 'mm-charset-override-alist '(iso-2022-jp . cp50220))))
;; SEMI (cf. http://d.hatena.ne.jp/kiwanami/20091103/1257243524)
(eval-after-load "mcs-20"
  '(when (coding-system-p 'cp50220)
     (add-to-list 'mime-charset-coding-system-alist 
          '(iso-2022-jp . cp50220))))

;;; タブ4
(setq-default tab-width 4)
(setq default-tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                      64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))

;====================================
;;全角スペースとかに色を付ける
;====================================
(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
(defface my-face-b-1 '((t (:background "dark turquoise"))) nil)
(defface my-face-b-2 '((t (:background "cyan"))) nil)
(defface my-face-b-2 '((t (:background "SeaGreen"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
            (font-lock-add-keywords
                 major-mode
                    '(
                           ("　" 0 my-face-b-1 append)
                           ("\t" 0 my-face-b-2 append)
                           ("[ ]+$" 0 my-face-u-1 append)
          )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
                             (if font-lock-mode
                               nil
                               (font-lock-mode t))))
;; emacsclientを使えるようにする
(server-start)

;;; grep-findでackを使う
(setq grep-find-command "ack --nocolor --nogroup ")

;;; perl-modeでタブをスペースにする
(add-hook 'cperl-mode-hook
          '(lambda ()
             (setq indent-tabs-mode nil
                   cperl-hairy t
                   cperl-indent-level 4
                   ;; cperl-comment-column 40
                   ;; cperl-brace-imaginary-offset 0
                   ;; cperl-brace-offset 0
                   ;; cperl-label-offset -2
                   ;; cperl-min-label-indent 1
                   cperl-continued-statement-offset 4
                   ;; cperl-continued-brace-offset 0
                   cperl-close-paren-offset -4
                   ;; cperl-indent-wrt-brace t
                   cperl-indent-parens-as-block t
                   )))

;;; てか、いつもスペースでいいじゃん
(setq-default
 tab-width 4
 indent-tabs-mode nil)

(put 'narrow-to-region 'disabled nil)

;;; svnでバックアップを作成しない
(setq backup-enable-predicate
      (lambda (path)
             "バックアップ作成するかチェック"
             (and (normal-backup-enable-predicate path)
                  (not (string-match "svn-commit\\..*tmp$" path)))))


;;; auto-complate
(require 'auto-complete-config)
(ac-config-default)

;;; 起動時の画面はいらない
(setq inhibit-startup-message t)

;;; mmm-mode
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class nil "\\.wsf" 'xml-js2)
(mmm-add-classes
 '((xml-js2
    :submode javascript-mode
    :front "<script language=\"JScript\">.*\n"
    :back "]]></script>")))
;;; migemo
;;(load "migemo.el")

;;;; tree-undo
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;;; popup-kill-ring
(require 'popup)
(require 'pos-tip)
(require 'popup-kill-ring)
(global-set-key "\M-y" 'popup-kill-ring) ; M-yに割り当ての場合

;; 個別設定読み込み
(let
    ((file-name (concat "~/.emacs.d/"
                        (car (split-string hostname "\\.")) ".el")))
     (cond ((file-readable-p file-name)
            (load file-name))))
