;; proxy�̐ݒ�
(cond ((eq hostname "DT0928")
       (setq url-proxy-services '(("no_proxy" . "nikkei-r\\.co\\.jp")
                           ("http" . "172.20.32.105:3128")))))
;====================================
;�t���[���ʒu�ݒ�(�E�B���h�E�j 
;====================================
(cond ((eq os-type 'win)
       (setq initial-frame-alist
             (append
              '((top . 0)    ; �t���[���� Y �ʒu(�s�N�Z����)
                (left . 745)    ; �t���[���� X �ʒu(�s�N�Z����)
                (width . 82)    ; �t���[����(������)
                (height . 52)   ; �t���[����(������)
                ) initial-frame-alist))))
