;; proxyの設定
(setq url-proxy-services '(("no_proxy" . "nikkei-r\\.co\\.jp")
                           ("http" . "172.20.32.105:3128")))
;====================================
;フレーム位置設定(ウィンドウ） 
;====================================
(cond ((eq os-type 'win)
       (setq initial-frame-alist
             (append
              '((top . 0)    ; フレームの Y 位置(ピクセル数)
                (left . 1208)    ; フレームの X 位置(ピクセル数)
                (width . 82)    ; フレーム幅(文字数)
                (height . 62)   ; フレーム高(文字数)
                ) initial-frame-alist))))

;; ipmsgのログ
(find-file "c:/Users/keisuke_okada/Documents/ipmsg.log")
(auto-revert-tail-mode)
(end-of-buffer)
