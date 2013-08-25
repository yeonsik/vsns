vsns
====

vertical sns with big pie team

2013년 8월 25일, bbugguj 브랜치에 추가된 내용 => Tagging 기능 추가

* gem 'acts-as-taggable-on'을 사용하여 Tagging 기능 추가
* Item model에 tagging 관련 기능 추가 (acts_as_taggable)
* Item 입력 form에서 tag list 입력받을 수 있도록 수정
* Item show.html에 tag 보여주도록 수정. tag에 /tags/:tag 링크 추가
* /tags/:tag 라우트 추가
* ItemsController의 index에 tag로 검색하는 기능 추가
* .gitignore 파일에  big_pie/public/uploads/* 추가
