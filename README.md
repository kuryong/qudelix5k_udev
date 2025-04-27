# qudelix_udev
리눅스에서 큐델릭스 5k 사용하기

Udev의 권한 문제로, 크롬기반 브라우저에 큐델릭스 앱을 설치하고 바로 연결을 시도하면 기기가 앱에 나오지 않습니다.
이를 해결하기 위해 Udev에 규칙을 추가해줍니다.

/etc/udev/rules.d
에 관리자권한으로 들어가서,
99-qudelix.rules
라는 파일을 만들어주고,
udev관련 값을 넣어줍니다.



SUBSYSTEM=="usb", ATTRS{idVendor}=="0a12", MODE="0660", GROUP="plugdev", TAG+="uaccess"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", , GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"



저장하고 터미널에서
sudo service udev restart
udev를 재시작해주거나, 컴퓨터를 재부팅합니다.


________________________________________________

첨부해둔 파일은 이 과정을 쉽게 스크립트화 해둔 Bash 파일입니다.
첫 실행시 해당 디렉터리에 파일을 생성해주고, 재실행시 파일이 있으면 삭제하겠냐고 물어봅니다.
디렉터리의 권한특성상, sudo를 필요로 합니다.
>chmod +x qudelix5k_udev.bash        #실행권한 부여
>sudo ./qudelix5k_udev.bash          #관리자권한으로 실행


참고:
https://forum.qudelix.com/post/linux-udev-rules-for-5k-and-t71-12746175?trail=15
