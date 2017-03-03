jQuery.noConflict()
(($) ->
  class EWPManager

    constructor: (baseUrl, callback) ->
      @dialog = $(".ewp_dialog")
      @dialog.dialog
        autoOpen: false
        width: 500
        height: 500
        close: (event, ui) =>
          @validate()


      @view_type = $(ewp_type)
      @eui = $(ewp_in_eui)
      @euwi = $(ewp_in_euwi)
      @ci = $(ewp_in_ci)
      @ti = $(ewp_in_ti)
      @ei = $(ewp_in_ei)
      @iw = $(ewp_in_with)
      @ih = $(ewp_in_height)
      @btm = $(ewp_btm_apply)
      @img = $(ewp_img_preview)

      @codesection = $(ewp_preview_shortcode_box)

      @basehost = if baseUrl? then baseUrl else "http://vagrant.local/content/plugins/endomondowp" ;

      @shortcode = "";

      $(".ewp_section_body").hide()
      $(".ewp_section_control").click =>
        $(".ewp_section_body").show()


      @view_type.change =>
        @validate()

      @eui.change (e) =>
        @validate()

      @euwi.change (e) =>
        @validate()

      @ci.change (e) =>
        @validate()

      @ti.change (e) =>
        @validate()

      @ei.change (e) =>
        @validate()

      @iw.change (e) =>
        @validate()

      @ih.change (e) =>
        @validate()


      @btm.on "click", =>
        @validate()
        callback? @shortcode if @shortcode?

        @close()

    _resetView: ->
      @eui.hide()
      @euwi.hide()
      @ci.hide()
      @ti.hide()
      @ei.hide()
      @btm.hide()
      @img.attr 'src', @basehost + '/images/logo.png' if @img.attr('src') != @basehost + '/images/logo.png'
      @img.show()
      @view_type.val 'last-workout'

    _lastWorkout: ->
#size.show();
      @eui.show()
      @euwi.hide()
      @ei.hide()
      @ci.hide()
      @ti.hide()
      @img.attr 'src', @basehost + '/images/last-workout_p.png' if @img.attr('src') != @basehost + '/images/last-workout_p.png'
      @img.show()
      return

    _oneWorkout: ->
#size.show();
      @eui.hide()
      @euwi.show()
      @ei.hide()
      @ci.hide()
      @ti.hide()
      @img.attr 'src', @basehost + '/images/last-workout_p.png' if @img.attr('src') != @basehost + '/images/last-workout_p.png'
      @img.show()
      return

    _workoutList: ->
#size.show();
      @eui.show()
      @euwi.hide()
      @ei.hide()
      @ci.hide()
      @ti.hide()
      @img.attr 'src', @basehost + '/images/workout-list_p.png' if @img.attr('src') != @basehost + '/images/workout-list_p.png'
      @img.show()
      return

    _challenge: ->
      @euwi.hide()
      #size.show();
      @eui.show()
      @ei.hide()
      @ci.show()
      @ti.hide()
      @img.show()
      @img.attr 'src', @basehost + '/images/challenge_p.png' if @img.attr('src') != @basehost + '/images/challenge_p.png'
      return

    _team: ->
      @euwi.hide()
      #size.show();
      @eui.hide()
      @ei.hide()
      @ci.hide()
      @ti.show()
      @img.show()
      @img.attr 'src', @basehost + '/images/team_p.png' if @img.attr('src') != @basehost + '/images/team_p.png'
      return

    _event: ->
      @euwi.hide()
      #size.show();
      @eui.hide()
      @ei.show()
      @ci.hide()
      @ti.hide()
      @img.show()
      @img.attr 'src', @basehost + '/images/event_p.png' if @img.attr('src') != @basehost + '/images/event_p.png'


    open: () ->
      @validate()
      @dialog.dialog("open");

    close: () ->
      @_resetView();
      @dialog.dialog("close");


    validate: () ->
      veui = @eui.val()
      veuwi = @euwi.val()
      vei = @ei.val()
      vci = @ci.val()
      vti = @ti.val()
      size = ''

      if !!@iw.val()
        size = ' width="' + @iw.val() + '"'

      if !!@ih.val()
        size += ' height="' + @ih.val() + '"'

      @shortcode = null

      switch @view_type.val()
        when 'last-workout'
          @_lastWorkout()
          if veui != ""
            @shortcode = "[endomondowp type='last-workout' user='#{veui}' #{size} ]"
        when 'workout'
          @_oneWorkout()
          if veuwi != ""
            @shortcode = "[endomondowp type='workout' workout_id='#{veuwi}' #{size} ]"
        when 'workout-list'
          @_workoutList()
          if veui != ""
            @shortcode = "[endomondowp type='workout-list' user='#{veui}' #{size} ]"
        when 'challenge'
          @_challenge()
          if veui != "" and vci != ""
            @shortcode = "[endomondowp type='challenge' user='#{veui}' challenge_id='#{vci}' #{size} ]"
        when 'team'
          @_team()
          if vti != ""
            @shortcode = "[endomondowp type='team' team_id='#{vti}' #{size} ]"
        when 'event'
          @_event()
          if vei != ""
            @shortcode = "[endomondowp type='event' event_id='#{vei}' #{size} ]"
        else
          @_resetView()
          @shortcode = null

      @codesection.html @shortcode

      if @shortcode? then @btm.show() else @btm.hide()

  ewpM = new EWPManager(EWP_DATA.ewpurl, (code) ->
    tinyMCE.execCommand 'mceInsertContent', false, code
    return
  )

  $('.ewp_fast_tag').on 'click', ->
    ewpM.open()) jQuery


