# English Daily Reps

매일 15분 초급 영어 연습 앱: 단어 카드(간격 반복), 받아쓰기, 문장 만들기, 따라 말하기(발음 채점·녹음 비교), 기초 문법.

- **아이폰:** GitHub Pages 주소를 Safari로 열고 공유 → 홈 화면에 추가
- **Windows PC:** `install.bat`을 **한 번만** 실행 → `F:\Programs\EnglishDailyReps`에 실행용 페이지(`launch.html`)와 아이콘,
  바탕화면 / 시작 메뉴 바로가기 생성. 바로가기는 온라인 앱을 열기 때문에 **업데이트는 자동** (다시 설치할 필요 없음).
  처음 열 때 예전 '내 컴퓨터 파일' 버전의 학습 기록을 한 번 넘겨받음. 제거는 `F:\Programs\EnglishDailyReps\uninstall.bat`

## 업데이트하는 법
`app.src.html` 수정 → `bash build.sh` → `sw.js`의 `VERSION` 올리기 → 커밋·푸시.
1~2분 뒤 GitHub Pages에 반영되고, 아이폰·PC 모두 다음에 앱을 열 때 새 버전이 됩니다.

## 음성 파일
`audio/*.mp3`는 [Kokoro](https://github.com/hexgrad/kokoro) (Apache-2.0) AI 음성으로 만든 파일입니다.
문장을 추가하면 `tools/gen_audio.py`로 새 문장 음성만 추가 생성할 수 있어요 (kokoro-onnx 필요).
녹음 파일이 없는 문장은 기기 음성으로 자동 대체됩니다.

## 수정하는 법
`app.src.html`을 고친 뒤 `bash build.sh`로 `index.html`을 다시 만들고 커밋·푸시하세요.
캐시 갱신을 위해 `sw.js`의 `VERSION`도 올려 주세요.
