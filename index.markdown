---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

<link rel="stylesheet" href="https://unpkg.com/purecss@2.0.6/build/pure-min.css" integrity="sha384-Uu6IeWbM+gzNVXJcM9XV3SohHtmWE+3VGi496jvgX1jyvDTXfdK+rfZc8C1Aehk5" crossorigin="anonymous">

<div class='pure-g'>
  {% for game_hash in site.data.games %}
  {% assign game = game_hash[1] %}
      <div class='pure-u-1-4'> 
        <a href="{{ game.url | relative_url}}">
          <img class="pure-img" src="{{site.s3_base_url}}{{game[':directory_name']}}/thumbs/{{game[':thumbnail_photo'] }}">  
          <div>{{game[':title']}}</div>
        </a>
        <div style="font-size: 12px">{{game[':date'] | date: "%b %-d %Y"}}</div>
      </div>
  {% endfor %}
</div>