<img src = "<%= gravatar %>" width = "150" height = "150" />
<a class="btn btn-danger" data-vote="awesome">
  <i class="icon-thumbs-up"></i>
  Awesome! (<%= project.get('votes').awesome %>)
</a>
<a class="btn btn-danger" data-vote="useful">
  <i class="icon-thumbs-up"></i>
  Useful! (<%= project.get('votes').useful %>)
</a>
<a class="btn btn-danger" data-vote="nocode">
  <i class="icon-thumbs-up"></i>
  No Codez! (<%= project.get('votes').nocode %>)
</a>
<h4><%= project.get('name') %></h4>
<p><%= project.get('creator') %></p>
