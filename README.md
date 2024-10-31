# PublicWeather

[초단기예보 API](https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15084084)를 사용해서 지역의 앞으로 6시간의 날씨를 보여주는 앱

<img width="373" alt="image" src="https://github.com/user-attachments/assets/4087fbd6-0dd8-4023-b72b-3163fb83bd1d">

실행방법: 네트워크를 연결한 후 Fetch Weather 버튼 탭
### 기능
* 30분마다 정보 업데이트
* 위치는 영등포구(58, 26)로 고정되어 있음
* 네트워크 미연결 시 로컬에 저장된 정보를 불러옴(현재는 6시간 중 1시간만 보임)
  * 예시
  <img width="375" alt="image" src="https://github.com/user-attachments/assets/59487fbf-22da-4ba3-8722-d6ad4290dd52">

### 기술스택
* Swift, SwiftUI
* 네트워크 Request 처리 async-await
* 데이터 바인딩 Combine
* 로컬 데이터 저장 Core Data
  
### 아키텍처
* MVVM


