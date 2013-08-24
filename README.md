vsns
====
crystal
vertical sns with big pie team

#### 2013년 8월 24일, hschoi 브랜치에 추가된 내용


1. 전체 레이아웃을 가로 2단으로 구성하였고, 약간의 리팩토링을 수행하였습니다. 
2. file upload시 한글파일명일 경우 한글이 밑줄로 표시되는 것을 한글이 제대로 표시되도록 하였습니다. (config/initializers/carrierwave.rb 파일을 추가했습니다.)
3. devise 젬의 devise:views 를 생성했습니다. 그래서 app/views/devise/ 디렉토리의 뷰템플릿 파일들을 가지고 수정할 수 있게 되었습니다. 
4. 그리고 follow 기능을 추가하기 위해서 users_controller.rb 파일을 추가했습니다. 여기에는 followings, followers, follow, unfollow 액션을 정의했습니다. 
5. User 모델에는 avatar 속성을 추가해서 개인 프로필 사진을 올리 수 있게 했습니다. 사진이 없는 경우 디폴트 이미지(profile_default.png)가 보이도록 했습니다. 그리고 Relationship 이라는 모델을 만들어 User 모델과의 관계설정을 했습니다. 또한, User 모델에는 following?, follow!, unfollow! 메소드를 정의했습니다. 
6. relationships_controller.rb 파일은 현재로서는 딱히 필요가 없습니다. 
