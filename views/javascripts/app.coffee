class @HackDay extends Backbone.Model
  urlRoot: '/hackdays'

class @Project extends Backbone.Model
  urlRoot: '/projects'

  toJSON: ->
    project: @attributes

class @Projects extends Backbone.Collection
  model: Project
  url: '/projects'

class @Vote extends Backbone.Model
  urlRoot: '/votes'

class @ProjectListView extends Backbone.View

  render: ->
    @$el.html('')
    _(@collection.models).each (model) =>
      @$el.append new ProjectView(model: model).render().el
    @

class @ProjectView extends Backbone.View
  
  className: 'project'

  events:
    'click a' : 'vote'

  render: ->
    gravatar = "http://www.gravatar.com/avatar/#{hex_md5 @model.get('email')}.jpg?s=150x150"
    @$el.html JST['project'](project: @model, gravatar: gravatar)
    @delegateEvents()
    @

  vote: (e) ->
    category = $(e.currentTarget).data('vote')
    vote = new Vote project_id: @model.id, category: category
    @model.get('votes')[category] += 1
    @render()
    vote.save()

$ ->
  projects = new Projects
  projectList = new ProjectListView collection: projects
  projects.on 'reset', -> $('.content').html projectList.render().el
  projects.fetch(reset: true)

  $('.create-hackday').on 'click', ->
    hackday = new HackDay
    hackday.save {},
      success: -> projects.fetch(reset: true)

  $('.create-project').on 'click', ->
    project = new Project
      name: $('input[name=name]').val()
      email: $('input[name=email]').val()
      creator: $('input[name=creator]').val()
    projects.add(project)
    $('form input').val('')
    project.save {},
      success: -> projectList.render()
