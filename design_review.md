# View設計に関するレビューと改善提案

## 概要
ユーザーからの「viewファイルの設計でナンセンスな部分があったら教えて下さい」という要望に基づき、現状のコードベースに見られる設計上の問題点と改善案をまとめました。

## 1. インラインJavaScriptの記述 (重大)
### 該当ファイル
`app/views/shared/_member_form.html.erb`

### 問題点
Viewファイル（ERB）の末尾に `<script>` タグで直接JavaScriptが記述されています。
- **メンテナンス性の低下**: HTMLとロジックが混在し、読みづらく、修正しにくい。
- **再利用性の欠如**: このロジックを他の場所で使い回すことが難しい。
- **CSP (Content Security Policy) 違反**: インラインスクリプトはセキュリティリスクとなり、CSPの設定によっては動作しなくなる可能性があります。
- **Turbolinks/Turboの挙動**: Railsで標準的に使われるTurbolinksやTurbo Drive環境下では、ページ遷移時に`DOMContentLoaded`イベントが発火しない場合があり、正しく動作しない可能性があります。

### 改善案
JavaScriptコードを `app/javascript` 配下の別ファイル（Stimulusコントローラーなど）に移動し、HTMLからは `data-controller` などの属性を通じて呼び出すようにするべきです。

```javascript
// app/javascript/controllers/toggle_controller.js (例)
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  connect() {
    this.toggle()
  }

  toggle() {
    if (this.element.checked) {
      this.contentTarget.style.display = "block"
    } else {
      this.contentTarget.style.display = "none"
    }
  }
}
```

## 2. 複雑なロジックのViewへの混入
### 該当ファイル
`app/views/shared/_member_form.html.erb`

### 問題点
スケジュールテーブルの生成部分に複雑なRubyコードが含まれています。
```erb
<% (0..23).each do |hour| %>
  <% time_str = "#{hour}:00" %>
  <tr>
    <th><%= time_str %></th>
    <% days.each do |day| %>
      <td
        <% is_checked = @member.free_dates.any? { |fd| fd.day == day && fd.free_hour.hour == hour } %>
        <%= check_box_tag "member[free_candidates][]", "#{day}:#{hour}", is_checked %>
      </td>
    <% end %>
  </tr>
<% end %>
```
- **可読性の低下**: Viewが「表示」の責務を超えて「データの計算・加工」を行っています。
- **N+1問題の温床**: `@member.free_dates` の呼び出し方によっては、ループの回数分だけDBクエリが発行される可能性があります（メモリ上で処理されているとしても、計算量は多いです）。

### 改善案
- **Helperへの切り出し**: テーブル生成ロジックをHelperメソッドに移動する。
- **ViewModel / Presenterパターンの導入**: 複雑な表示ロジックを持つオブジェクトを作成し、Viewではそれを呼び出すだけにする。
- **コレクションの最適化**: `is_checked` の判定を毎回 `any?` で回すのではなく、あらかじめハッシュやSetなどの高速に検索できるデータ構造に変換しておく。

## 3. CSSクラスの欠如とスタイル指定
### 該当ファイル
`app/views/shared/_member_form.html.erb`

### 問題点
`<div id="special_member_fields" style="<%= @member.special_member? ? '' : 'display: none;' %>">` のようにインラインスタイルで `display: none` を制御しています。
これはJavaScriptによる制御と密結合しており、スタイル変更を難しくします。

### 改善案
CSSクラス（例: `.is-hidden`）の付け外しで表示制御を行うように変更するべきです。

## 4. パーシャルの粒度
### 該当ファイル
`app/views/shared/_member_form.html.erb`

### 問題点
このパーシャルは非常に大きく、多くの責務（基本情報、特別会員情報、スケジュール）を持っています。

### 改善案
`_basic_info_fields.html.erb`, `_special_member_fields.html.erb`, `_schedule_table.html.erb` のように、機能ごとにさらにパーシャルを分割することで、見通しが良くなり再利用性も高まります。
