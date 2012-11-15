;; proxyの設定
(cond ((eq hostname "DT0928")
       (setq url-proxy-services '(("no_proxy" . "nikkei-r\\.co\\.jp")
                           ("http" . "172.20.32.105:3128")))))
;====================================
;フレーム位置設定(ウィンドウ） 
;====================================
(cond ((eq os-type 'win)
       (setq initial-frame-alist
             (append
              '((top . 0)    ; フレームの Y 位置(ピクセル数)
                (left . 745)    ; フレームの X 位置(ピクセル数)
                (width . 82)    ; フレーム幅(文字数)
                (height . 52)   ; フレーム高(文字数)
                ) initial-frame-alist))))
