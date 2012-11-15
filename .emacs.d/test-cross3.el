;; proxyの設定
(setq url-proxy-services '(("no_proxy" . "nikkei-r\\.co\\.jp")
                           ("http" . "proxy.nikkei-r.co.jp:8080")))

;====================================
;フレーム位置設定(ウィンドウ） 
;====================================
(setq initial-frame-alist
      (append
       '((top . 30)    ; フレームの Y 位置(ピクセル数)
         (left . 820)    ; フレームの X 位置(ピクセル数)
         (width . 82)    ; フレーム幅(文字数)
         (height . 64)   ; フレーム高(文字数)
         ) initial-frame-alist))

;; for DB
(setq
 sql-user
 "postgres"
 sql-database
 "crosstest3db"
 sql-server
 "test-cross3.nikkei-r.local"
 )

;; 日記ファイルのオープン
(defun okada-start()
  (let ((today-string (format-time-string "%Y/%m/%d"))
	(data-file "~/okada.txt"))
    (find-file data-file)
    (beginning-of-buffer)
    (cond
     ((looking-at today-string)
      (when (looking-at "[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9] 作業時間 [0-9][0-9]:[0-9][0-9]-[0-9][0-9]:[0-9][0-9]")
	(end-of-line)
	(backward-delete-char-untabify 5))
      )
     (t
      (insert today-string)
      (insert " 作業時間 ")
      (insert (format-time-string "%H:%M-\n"))))))

(defun okada-end()
  (let ((data-file "~/okada.txt"))
    (find-file data-file)
    (beginning-of-buffer)
    (when (looking-at "[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9] 作業時間 [0-9][0-9]:[0-9][0-9]-")
      (end-of-line)
      (insert (format-time-string "%H:%M"))
      (save-buffer)
      ))
  t)

;; 日記起動
(add-hook 'kill-emacs-query-functions
          'okada-end)
(okada-start)

