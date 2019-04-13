## [데일리투두](<https://itunes.apple.com/kr/app/%EB%8D%B0%EC%9D%BC%EB%A6%AC%ED%88%AC%EB%91%90/id1457175437?mt=8>)

> 버전 1.0 (2019.03.27)

#### 매일 쓰는 투두리스트

매일 투두리스트를 작성하는 습관을 들이세요!

데일리투두는 오늘과 내일의 할 일만을 작성합니다.

오늘 할 일에 집중하고 완수 했다면 체크해 주세요!

매일 할 일을 잊지 않고 기록해두는 습관을 만들 수 있습니다.

데일리투두는 할 일을 완수할 수 있도록 도움을 줍니다!

시간 설정을 하시면 그 시간을 잊지 않도록 알림을 드려요.

장소 설정을 하시면 그 장소를 지나치지 않도록 알림을 드려요.

오늘 할 일을 위젯으로 한층 더 편리하게 확인할 수 있습니다.

지난 일들의 기록을 되돌아보고 의욕을 키우세요!

달력 형태로 지난 일들의 완수 여부를 한 눈에 볼 수 있어요.

데일리투두를 활용해서 할 일을 쉽게 관리하세요!

----

#### 주요 기능

1. 오늘과 내일의 할일 작성 및 이전 기록 열람
2. 시간 및 위치 기반 알림
3. 취침시간 설정을 통해 매일 할일을 관리하도록 알림
4. 오늘의 할일을 관리할 수 있는 위젯 제공

---

#### 관련 기술 및 라이브러리

* `Swift4`, `Xcode9`
* `UserNotifications`: 할일 작성 시 시간과 장소 기반으로 알림을 설정할 수 있습니다. 취침시간 설정 시 설정한 시간에 매일 알림을 받을 수 있습니다.
* `CoreData`: Task 엔터티를 가지는 코어데이터를 사용해 데이터를 관리하였습니다. 코어데이터스택 클래스를 따로 만들어서 메인 앱과 위젯 간의 데이터를 공유할 수 있게 하였습니다.
* `CoreLocation`: 할일 작성 시 장소 기반으로 알림을 설정하면 설정한 장소의 반경 100미터 이내 진입 시 알림을 받을 수 있습니다. 앱이 백그라운드 상태에 있을 때도 알림을 받을 수 있게 하였습니다.
* `Today Extensions`: 위젯에서 오늘의 할일 리스트를 확인 할 수 있습니다. 또한 위젯에서 수행 여부를 체크하거나 알림을 끄고 켤 수 있습니다.
* `DaumMap SDK`, `Kakao HTTP API`: 장소 검색 기능을 위해 카카오 SDK를 활용하였습니다. 
* `FSCalendar`: 지나온 날들의 투두리스트 기록을 달력 형태로 제공하기 위해 사용하였습니다. 리스트 열람 및 수행율 여부를 확인 할 수 있습니다.

---

#### 스크린샷

<img src="https://github.com/leehyeongrak/DailyTODO/blob/master/Screenshots/1.png" width="300"> <img src="https://github.com/leehyeongrak/DailyTODO/blob/master/Screenshots/2.png" width="300">
<img src="https://github.com/leehyeongrak/DailyTODO/blob/master/Screenshots/3.png" width="300"> <img src="https://github.com/leehyeongrak/DailyTODO/blob/master/Screenshots/4.png" width="300">
<img src="https://github.com/leehyeongrak/DailyTODO/blob/master/Screenshots/5.png" width="300"> <img src="https://github.com/leehyeongrak/DailyTODO/blob/master/Screenshots/6.png" width="300">
