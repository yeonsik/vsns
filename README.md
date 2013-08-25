vsns
====

: vertical sns with big pie team

#### 2013년 8월 25일, hschoi 브랜치에 추가된 내용 => Summernote 위지위크 에디터 추가함.

1. item form의 description 내용을 입력하는 창에 summernote 위지위그 에디터를 붙였습니다. 이를 위해 `summernote-rails` 라는 젬을 추가했습니다. 참고로 카카오의 홍영택님이 만드신 summernote 에디터를 rails에서 쉽게 사용할 수 있도록 제가 만든 젬입니다만, 시험적으로 사용해 봤습니다. 그런데로 괜찮습니다. 
2. summernote-rails 젬을 사용하니 turbolinks와의 문제가 발생하여 페이지가 보여질 때 에디터가 보이지 않게 되어 juqery-turbolinks 라는 젬을 추가하여 해결하였습니다. 이에 대해서는 Gemfile에 코멘트 추가해 놓았습니다.
3. summernote-rails 젬과의 충돌 때문에 flatui-rails 젬을 제거하였습니다.
4. item form의 file upload를 이준헌님이 만들어 놓으신 것을 참고하여 simple_form_bootstrap_file_input.rb 파일을 config/initializers 디렉토리에 추가하여 이쁘게 보이도록 했습니다. 감사드립니다. 
5. item photo 입력을 로컬머신의 시스템 파일 뿐만 아니라 이미지 URL을 입력해도 업로드가 가능하도록 했습니다. 이를 우해서 item.rb 모델 클래스에 attr_accessor :remote_photo_url 을 지정해 주었구요. items_controller.rb 파일의 item_params의 permit 옵션에 :remote_photo_url 항목을 추가해 주었습니다.
6. 그리고 items 테이블의 description 필드의 데이터 속성을 string 에서 text 로 변경하였습니다. 


#### 2013년 8월 25일, bbugguj 브랜치에 추가된 내용 => Tagging 기능 추가

* gem 'acts-as-taggable-on'을 사용하여 Tagging 기능 추가
* Item model에 tagging 관련 기능 추가 (acts_as_taggable)
* Item 입력 form에서 tag list 입력받을 수 있도록 수정
* Item show.html에 tag 보여주도록 수정. tag에 /tags/:tag 링크 추가
* /tags/:tag 라우트 추가
* ItemsController의 index에 tag로 검색하는 기능 추가
* .gitignore 파일에  big_pie/public/uploads/* 추가

#### 2013년 8월 25일, hschoi 브랜치에 추가된 내용

1. items 컨트롤러의 index와 show 액션 뷰 템플릿 파일을 리팩토링하였습니다. index view 에서는 _item.html.erb 이라는 partial template 파일을 만들어서 각 item 데이터를 보여 주는 부분을 별도의 파일로 추출하였습니다. 결과적으로 index.html.erb 파일에는 <%= render @items %> 이 한줄로 간단하게 전체 item 포스트를 보여 주게 됩니다. 
2. show action view 에서는 _show_item.html.erb 이라는 partial template 파일을 새로 만들어서 하나의 item 데이터를 조금 이쁘게 보이도록 하였습니다. 물론 전체적으로는 responsive design을 유지하면서 말이죠. 따라서 show action view template 파일에는 <%= render 'show_item', item: @item %>와 같이 간단하게 리팩토링되는 것이죠. 
3. _item_html.erb partial template 파일에서 추가한 기능은 `actions`라는 div 태그내에 세가지 action 링크를 추가하였습니다: `Show`, `Edit`, `Destroy`. 이 `actions` div 태그는 디폴트 상태에서는 display:none 으로 되어 있지만, div.hover 시에 display:inline으로 보이게 하였습니다. 따라서 마우스를 하나의 post에 가져가면 post 좌측하단에 세개의 액션 버튼들이 보이게 됩니다.  

#### 2013년 8월 24일, hschoi 브랜치에 추가된 내용

1. 전체 레이아웃을 가로 2단으로 구성하였고, 약간의 리팩토링을 수행하였습니다. 
2. file upload시 한글파일명일 경우 한글이 밑줄로 표시되는 것을 한글이 제대로 표시되도록 하였습니다. (config/initializers/carrierwave.rb 파일을 추가했습니다.)
3. devise 젬의 devise:views 를 생성했습니다. 그래서 app/views/devise/ 디렉토리의 뷰템플릿 파일들을 가지고 수정할 수 있게 되었습니다. 
4. 그리고 follow 기능을 추가하기 위해서 users_controller.rb 파일을 추가했습니다. 여기에는 followings, followers, follow, unfollow 액션을 정의했습니다. 
5. User 모델에는 avatar 속성을 추가해서 개인 프로필 사진을 올리 수 있게 했습니다. 사진이 없는 경우 디폴트 이미지(profile_default.png)가 보이도록 했습니다. 그리고 Relationship 이라는 모델을 만들어 User 모델과의 관계설정을 했습니다. 또한, User 모델에는 following?, follow!, unfollow! 메소드를 정의했습니다. 
6. relationships_controller.rb 파일은 현재로서는 딱히 필요가 없습니다. 

