qs = require 'querystring'
Backbone = require 'backbone'
Params = require '../../components/commercial_filter/models/params.coffee'
Filter = require '../../components/commercial_filter/models/filter.coffee'
UrlHandler = require '../../components/commercial_filter/url_handler.coffee'
PaginatorView = require '../../components/commercial_filter/filters/paginator/paginator_view.coffee'
MediumFilterView = require '../../components/commercial_filter/filters/medium/medium_filter_view.coffee'
PriceFilterView = require '../../components/commercial_filter/filters/price/price_filter_view.coffee'
SizeFilterView = require '../../components/commercial_filter/filters/size/size_filter_view.coffee'
ArtworkColumnsView = require '../../components/artwork_columns/view.coffee'
sd = require('sharify').data

module.exports.init = ->
  # Set initial params from the url params
  params = new Params qs.parse(location.search.replace(/^\?/, ''))
  filter = new Filter params: params

  # Main Artworks view
  artworkView = new ArtworkColumnsView
    collection: filter.artworks
    el: $('.cf-artworks')
    allowDuplicates: true
    numberOfColumns: 3

  filter.artworks.on 'reset', -> artworkView.render()
  filter.on 'change:loading', -> $('.cf-artworks').attr 'data-loading', filter.get('loading')

  # Sidebar
  mediumsView = new MediumFilterView
    el: $('.cf-sidebar__mediums')
    params: params
    aggregations: filter.aggregations

  priceView = new PriceFilterView
    el: $('.cf-sidebar__price')
    params: params

  widthView = new SizeFilterView
    el: $('.cf-sidebar__size__width')
    attr: 'width'
    params: params

  heightView = new SizeFilterView
    el: $('.cf-sidebar__size__height')
    attr: 'height'
    params: params

  # bottom
  paginatorView = new PaginatorView
    el: $('.cf-pagination')
    params: params
    filter: filter

  # Update url when routes change
  urlHandler = new UrlHandler
    params: params

  Backbone.history.start pushState: true

  # Trigger one change just to render filters
  params.trigger 'change'
