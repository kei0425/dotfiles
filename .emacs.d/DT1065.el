;; proxy�̐ݒ�
(setq url-proxy-services '(("no_proxy" . "nikkei-r\\.co\\.jp")
                           ("http" . "172.20.32.105:3128")))
;====================================
;�t���[���ʒu�ݒ�(�E�B���h�E�j 
;====================================
(cond ((eq os-type 'win)
       (setq initial-frame-alist
             (append
              '((top . 0)    ; �t���[���� Y �ʒu(�s�N�Z����)
                (left . 1208)    ; �t���[���� X �ʒu(�s�N�Z����)
                (width . 82)    ; �t���[����(������)
                (height . 62)   ; �t���[����(������)
                ) initial-frame-alist))))

;; ipmsg�̃��O
(find-file "c:/Users/keisuke_okada/Documents/ipmsg.log")
(auto-revert-tail-mode)
(end-of-buffer)
