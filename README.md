vsns
====

: vertical sns with big pie team

#### 2013년 8월 27일, hschoi 브랜치에 추가된 내용 

* 젬 추가 : slimbox2-rails v2.05.2 (https://github.com/rorlab/slimbox2-rails)
* 이 젬은 이미지 파일을 lightbox 로 볼 수 있게 해 줍니다. 그리고 특정 페이지의 링크 중에 rel 속성이 'light-xxx' 와 같이 동일한 경우가 여러개 있는 경우에는 lightbox에서 좌우 화살표나 마우스 클릭으로 이미지 스크롤하여 볼 수 있습니다. v2.05.2에서는 이미지 원본이 스크린 크기보다 큰 경우 화면의 0.8 배 크기로 자동으로 줄여 보여 주어 더 좋아졌습니다. 
* [주의] 레일스 4에서는 vendor/assets/images 디렉토리에 위치하는 이미지 파일들이 precompile되지 않는 문제점을 발견했습니다. 이를 위한 해결책은 config/production.rb 파일에 아래와 같이 코드를 추가해 줍니다. 즉, precompile 할 때 이미지 파일을 포함하라는 말인거죠.

```
# Precompile vendor/assets/images with Sprockets
config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
```

* likeable이라는 polymorphic association을 이용하여 좋아요 기능을 구현하였습니다. 이를 위해서 like.rb 모델 클래스를 작성하였고 이것은 모델 제너레이터를 이용하였습니다. 

```
$ rails g model Like likeable:references{polymorphic} user:references
  invoke  active_record
  create    db/migrate/20130827022256_create_likes.rb
  create    app/models/like.rb
  invoke    test_unit
  create      test/models/like_test.rb
  create      test/fixtures/likes.yml
```

이 `Like` 모델은 `User` 모델과 `Item` 모델을 연결하는 Join 모델로서 Like 모델은 어떤 모델(likeable:polymorphic)과도 `belongs_to` 로 연결할 수 있게 했습니다. 

```
class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :user
end
```
또한 `items` 데이블에는 `likes_count:integer` 필드를 하나 추가합니다. 이것은 `counter_cache`에 사용하기 위한 필드로서 정수 `0`으로 초기화해 줍니다. 아래는 마이그레이션 클래스의 내용입니다. 

```
class AddLikesCountToItems < ActiveRecord::Migration
  def change
    add_column :items, :likes_count, :integer, default: 0
  end
end

```
User 모델 클래스에는 `like!`, `dislike!`, `liking?` 메소드를 추가했고, `users_controller.rb` 에는 `like`, `dislike` 액션을 추가해 주었습니다. 

in user.rb

```
def like!(item)
  likes.create!( likeable: item)
end

def dislike!(item)
  likes.find_by(likeable: item).destroy!
end

def liking?(item)
  if item.nil?
    false
  else
    likes.find_by(likeable: item).present?
  end
end
```

in users_controller.rb

```
def like 
  @user = User.find(params[:id])
  @item = Item.find(params[:item_id])
  @user.like! @item

  respond_to do |format|
    format.js
  end

end

def dislike
  @user = User.find(params[:id])
  @item = Item.find(params[:item_id])
  @user.dislike! @item

  respond_to do |format|
    format.js
  end
end
```

in routes.rb

```
get 'users/:id/like/:item_id' => 'users#like', as: :like_item
get 'users/:id/dislike/:item_id' => 'users#dislike', as: :dislike_item
```

in views/users/like.js.erb

```
$('#like_<%= @item.id%>').html("<%=j render('items/like_status', item: @item) %>");
```

in views/users/dislike.js.erb

```
$('#like_<%= @item.id%>').html("<%=j render('items/like_status', item: @item) %>");
```

Like상태를 view 템플릿에 표시할 때는 아래와 같이 erb 코드를 작성했습니다. 

```
<%= item.likers.size %>
<%= link_to_unless( current_user.liking?(item), "Like", like_item_path(current_user.id, item.id), class: 'dislike_state', remote: true) do %>
  <%= link_to "Liked", dislike_item_path(current_user.id, item.id),  remote: true %>
<% end if user_signed_in? %>
```

상세한 것은 소스를 보시기 바랍니다.

#### 2013년 8월 26일(#2), hschoi 브랜치에 추가된 내용

##### Carrierwave젬의 저장소로 aws 를 사용하기

* 이를 위한 젬 추가 : carrierwave-aws (Gemfile에 추가하고 bundle install)

* config/initializers/carrierwave.rb 파일을 생성한 후 아래와 같이 carrierwave 설정추가하기 (환경변수는 aws 본인계정에서 관련정보를 얻을 수 있슴)

```
CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = ENV['S3_BUCKET_NAME']
  config.aws_acl    = :public_read
  config.asset_host = 'http://[bucket_name].s3-website-ap-northeast-1.amazonaws.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
end
```
heroku에서 환경변수를 지정하는 방법이 따로 있군요. 
참고(https://devcenter.heroku.com/articles/s3)

```
$ heroku config:set AWS_ACCESS_KEY_ID=xxx AWS_SECRET_ACCESS_KEY=yyy
```

bucket name 환경변수는 다음과 같이 지정합니다. bucket name 생성하는 방법은 https://console.aws.amazon.com/s3/home 참조하세요. (bucket은 아마존 S3 저장소임) 

```
$ heroku config:set S3_BUCKET_NAME=appname-assets
```

#### User account 기능기능 추가

* 사용자 계정정보를 변경시 프로필 사진을 삭제할 수 있도록 remove 체크박스를 추가하였습니다. 본인의 프로필 사진을 업로드했다가 삭제하고 싶을 때 체크하면 됩니다. 프로필 사진을 변경하고자 할 때는 다시 파일업로드하면 됩니다. 

* [주의사항] Devise 젬을 Rails 4에서 사용할 때는 strong parameters에 대한 부분을 추가해 주어야 합니다. 이에 대한 참고는 https://github.com/plataformatec/devise#strong-parameters 입니다. 

```
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise with strong parameters
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:avatar, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:avatar, :email, :password, :password_confirmation, :current_password, :remove_avatar) }
  end
end
```

#### 2013년 8월 26일(#1), hschoi 브랜치에 추가된 내용 => 배포 시물레이션 목적으로 heroku에 배포

###### Heroku에 배포하기 위해서 작업한 내용을 요약해 둡니다.

* Gemfile에 아래의 젬을 추가 합니다. 

```
group :production do
  gem 'pg'
  gem 'rails_12factor'
end
```

그리고, bundle install 합니다.  

* config/environments/production.rb 파일을 열어 아래와 같이 수정해 줍니다. 

```
config.serve_static_assets = true
```


* 다음으로는 assets을 사전 컴파일작업합니다. 

```
$ RAILS_ENV=production rake assets:precompile
```

지금까지 작업한 내용을 git 저장소에 commit 합니다

##### 이제부터는 heroku에 실제로 배포하기 위한 단계입니다. 

* `cd vsns/bigpie` 로 이동한 다음에 `git init` 명령으로 `bigpie` 디렉토리에 대한 `git` 환경을 초기화 줍니다. 

```
vsns/bigpie $ git init
vsns/bigpie $ git add .
vsns/bigpie $ git commit -m 'initial commit for heroku deployment'
```

* CLI에서 아래와 같은 명령을 실행하여, heroku에 웹서버와 git 저장소를 동시에 생성합니다. 

```
vsns/bigpie $ heroku create
Creating vast-crag-4195... done, stack is cedar
http://vast-crag-4195.herokuapp.com/ | git@heroku.com:vast-crag-4195.git
```

* 이제 heroku 라는 원격 저장소를 등록해 줍니다. 

```
vsns/bigpie $ git remote add heroku git@heroku.com:vast-crag-4195.git
```

* 다음으로 heroku master 브랜치로 현재의 로컬 저장소의 브랜치를 git push 합니다. 

```
vsns/bigpie $ git push heroku master
```

heroku로 배포가 완료되면 아래와 같이 migration 작업을 합니다. 

```
vsns/bigpie $ heroku run rake db:schema:dump
```

이제 브라우저의 주소입력창에 `http://vast-crag-4195.herokuapp.com/` 을 입력하고 접속합니다. 지금까지의 설치과정에서 별문제가 없었다면 웹페이지가 제대로 보여야 합니다. 


#### 2013년 8월 25일(#4), hschoi 브랜치에 추가된 내용 => 본인의 계정정보를 수정할 수 있게 함.

1. item form에 업로드된 photo 가 있는 경우 이미지를 표시하고 이미지를 삭제할 수 있는 checkbox를 추가하였습니다. 삭제 checkbox를 체크한 후 submit 하면 이제부터는 이미지가 삭제됩니다. 
2. item index 페이지에서도 각 포스트마다 tag 리스트를 보이게 했습니다. 
3. followers와 followings 리스트를 볼 수 있도록 링크를 연결하였습니다. 
4. navbar의 로그인 정보를 오른쪽으로 배열했습니다. 
5. 그리고 로그인 상태에서는 현재 로그인한 사용자의 이메일 주소가 navbar에 표시되도록 하였습니다. 
6. 또한 이메일 메뉴의 하위 메뉴를 두어 본인의 계정 정보를 수정할 수 있게 하였습니다. 
7. will_paginate 젬 추가하였습니다. 

#### 2013년 8월 25일(#3), hschoi 브랜치에 추가된 내용 => Summernote 위지위크 에디터 추가함.

1. item form의 description 내용을 입력하는 창에 summernote 위지위그 에디터를 붙였습니다. 이를 위해 `summernote-rails` 라는 젬을 추가했습니다. 참고로 카카오의 홍영택님이 만드신 summernote 에디터를 rails에서 쉽게 사용할 수 있도록 제가 만든 젬입니다만, 시험적으로 사용해 봤습니다. 그런데로 괜찮습니다. 
2. summernote-rails 젬을 사용하니 turbolinks와의 문제가 발생하여 페이지가 보여질 때 에디터가 보이지 않게 되어 juqery-turbolinks 라는 젬을 추가하여 해결하였습니다. 이에 대해서는 Gemfile에 코멘트 추가해 놓았습니다.
3. summernote-rails 젬과의 충돌 때문에 flatui-rails 젬을 제거하였습니다.
4. item form의 file upload를 이준헌님이 만들어 놓으신 것을 참고하여 simple_form_bootstrap_file_input.rb 파일을 config/initializers 디렉토리에 추가하여 이쁘게 보이도록 했습니다. 감사드립니다. 
5. item photo 입력을 로컬머신의 시스템 파일 뿐만 아니라 이미지 URL을 입력해도 업로드가 가능하도록 했습니다. 이를 우해서 item.rb 모델 클래스에 attr_accessor :remote_photo_url 을 지정해 주었구요. items_controller.rb 파일의 item_params의 permit 옵션에 :remote_photo_url 항목을 추가해 주었습니다.
6. 그리고 items 테이블의 description 필드의 데이터 속성을 string 에서 text 로 변경하였습니다. 
7. items 보여지는 순서를 updated_at 날짜를 DESC로 지정했습니다. 이제 최근 갱신글이 가장 위로 보이게 됩니다. 


#### 2013년 8월 25일(#2), bbugguj 브랜치에 추가된 내용 => Tagging 기능 추가

* gem 'acts-as-taggable-on'을 사용하여 Tagging 기능 추가
* Item model에 tagging 관련 기능 추가 (acts_as_taggable)
* Item 입력 form에서 tag list 입력받을 수 있도록 수정
* Item show.html에 tag 보여주도록 수정. tag에 /tags/:tag 링크 추가
* /tags/:tag 라우트 추가
* ItemsController의 index에 tag로 검색하는 기능 추가
* .gitignore 파일에  big_pie/public/uploads/* 추가

#### 2013년 8월 25일(#1), hschoi 브랜치에 추가된 내용

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

