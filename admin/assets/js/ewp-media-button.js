(function() {
  jQuery.noConflict();

  (function($) {
    var EWPManager, ewpM;
    EWPManager = (function() {
      function EWPManager(baseUrl, callback) {
        this.dialog = $(".ewp_dialog");
        this.dialog.dialog({
          autoOpen: false,
          width: 500,
          height: 500,
          close: (function(_this) {
            return function(event, ui) {
              return _this.validate();
            };
          })(this)
        });
        this.view_type = $(ewp_type);
        this.eui = $(ewp_in_eui);
        this.euwi = $(ewp_in_euwi);
        this.ci = $(ewp_in_ci);
        this.ti = $(ewp_in_ti);
        this.ei = $(ewp_in_ei);
        this.iw = $(ewp_in_with);
        this.ih = $(ewp_in_height);
        this.btm = $(ewp_btm_apply);
        this.img = $(ewp_img_preview);
        this.codesection = $(ewp_preview_shortcode_box);
        this.basehost = baseUrl != null ? baseUrl : "http://vagrant.local/content/plugins/endomondowp";
        this.shortcode = "";
        $(".ewp_section_body").hide();
        $(".ewp_section_control").click((function(_this) {
          return function() {
            return $(".ewp_section_body").show();
          };
        })(this));
        this.view_type.change((function(_this) {
          return function() {
            return _this.validate();
          };
        })(this));
        this.eui.change((function(_this) {
          return function(e) {
            return _this.validate();
          };
        })(this));
        this.euwi.change((function(_this) {
          return function(e) {
            return _this.validate();
          };
        })(this));
        this.ci.change((function(_this) {
          return function(e) {
            return _this.validate();
          };
        })(this));
        this.ti.change((function(_this) {
          return function(e) {
            return _this.validate();
          };
        })(this));
        this.ei.change((function(_this) {
          return function(e) {
            return _this.validate();
          };
        })(this));
        this.iw.change((function(_this) {
          return function(e) {
            return _this.validate();
          };
        })(this));
        this.ih.change((function(_this) {
          return function(e) {
            return _this.validate();
          };
        })(this));
        this.btm.on("click", (function(_this) {
          return function() {
            _this.validate();
            if (_this.shortcode != null) {
              if (typeof callback === "function") {
                callback(_this.shortcode);
              }
            }
            return _this.close();
          };
        })(this));
      }

      EWPManager.prototype._resetView = function() {
        this.eui.hide();
        this.euwi.hide();
        this.ci.hide();
        this.ti.hide();
        this.ei.hide();
        this.btm.hide();
        if (this.img.attr('src') !== this.basehost + '/images/logo.png') {
          this.img.attr('src', this.basehost + '/images/logo.png');
        }
        this.img.show();
        return this.view_type.val('last-workout');
      };

      EWPManager.prototype._lastWorkout = function() {
        this.eui.show();
        this.euwi.hide();
        this.ei.hide();
        this.ci.hide();
        this.ti.hide();
        if (this.img.attr('src') !== this.basehost + '/images/last-workout_p.png') {
          this.img.attr('src', this.basehost + '/images/last-workout_p.png');
        }
        this.img.show();
      };

      EWPManager.prototype._oneWorkout = function() {
        this.eui.hide();
        this.euwi.show();
        this.ei.hide();
        this.ci.hide();
        this.ti.hide();
        if (this.img.attr('src') !== this.basehost + '/images/last-workout_p.png') {
          this.img.attr('src', this.basehost + '/images/last-workout_p.png');
        }
        this.img.show();
      };

      EWPManager.prototype._workoutList = function() {
        this.eui.show();
        this.euwi.hide();
        this.ei.hide();
        this.ci.hide();
        this.ti.hide();
        if (this.img.attr('src') !== this.basehost + '/images/workout-list_p.png') {
          this.img.attr('src', this.basehost + '/images/workout-list_p.png');
        }
        this.img.show();
      };

      EWPManager.prototype._challenge = function() {
        this.euwi.hide();
        this.eui.show();
        this.ei.hide();
        this.ci.show();
        this.ti.hide();
        this.img.show();
        if (this.img.attr('src') !== this.basehost + '/images/challenge_p.png') {
          this.img.attr('src', this.basehost + '/images/challenge_p.png');
        }
      };

      EWPManager.prototype._team = function() {
        this.euwi.hide();
        this.eui.hide();
        this.ei.hide();
        this.ci.hide();
        this.ti.show();
        this.img.show();
        if (this.img.attr('src') !== this.basehost + '/images/team_p.png') {
          this.img.attr('src', this.basehost + '/images/team_p.png');
        }
      };

      EWPManager.prototype._event = function() {
        this.euwi.hide();
        this.eui.hide();
        this.ei.show();
        this.ci.hide();
        this.ti.hide();
        this.img.show();
        if (this.img.attr('src') !== this.basehost + '/images/event_p.png') {
          return this.img.attr('src', this.basehost + '/images/event_p.png');
        }
      };

      EWPManager.prototype.open = function() {
        this.validate();
        return this.dialog.dialog("open");
      };

      EWPManager.prototype.close = function() {
        this._resetView();
        return this.dialog.dialog("close");
      };

      EWPManager.prototype.validate = function() {
        var size, vci, vei, veui, veuwi, vti;
        veui = this.eui.val();
        veuwi = this.euwi.val();
        vei = this.ei.val();
        vci = this.ci.val();
        vti = this.ti.val();
        size = '';
        if (!!this.iw.val()) {
          size = ' width="' + this.iw.val() + '"';
        }
        if (!!this.ih.val()) {
          size += ' height="' + this.ih.val() + '"';
        }
        this.shortcode = null;
        switch (this.view_type.val()) {
          case 'last-workout':
            this._lastWorkout();
            if (veui !== "") {
              this.shortcode = "[endomondowp type='last-workout' user='" + veui + "' " + size + " ]";
            }
            break;
          case 'workout':
            this._oneWorkout();
            if (veuwi !== "") {
              this.shortcode = "[endomondowp type='workout' workout_id='" + veuwi + "' " + size + " ]";
            }
            break;
          case 'workout-list':
            this._workoutList();
            if (veui !== "") {
              this.shortcode = "[endomondowp type='workout-list' user='" + veui + "' " + size + " ]";
            }
            break;
          case 'challenge':
            this._challenge();
            if (veui !== "" && vci !== "") {
              this.shortcode = "[endomondowp type='challenge' user='" + veui + "' challenge_id='" + vci + "' " + size + " ]";
            }
            break;
          case 'team':
            this._team();
            if (vti !== "") {
              this.shortcode = "[endomondowp type='team' team_id='" + vti + "' " + size + " ]";
            }
            break;
          case 'event':
            this._event();
            if (vei !== "") {
              this.shortcode = "[endomondowp type='event' event_id='" + vei + "' " + size + " ]";
            }
            break;
          default:
            this._resetView();
            this.shortcode = null;
        }
        this.codesection.html(this.shortcode);
        if (this.shortcode != null) {
          return this.btm.show();
        } else {
          return this.btm.hide();
        }
      };

      return EWPManager;

    })();
    ewpM = new EWPManager(EWP_DATA.ewpurl, function(code) {
      tinyMCE.execCommand('mceInsertContent', false, code);
    });
    return $('.ewp_fast_tag').on('click', function() {
      return ewpM.open();
    });
  })(jQuery);

}).call(this);
