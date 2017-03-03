/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // Metadata.
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
    // Task configuration.
    pot: {
      options:{
        text_domain: 'endomondowp', //Your text domain. Produces my-text-domain.pot
        dest: 'languages/', //directory to place the pot file
        keywords: [ //WordPress localisation functions
          '__:1',
          '_e:1',
          '_x:1,2c',
          'esc_html__:1',
          'esc_html_e:1',
          'esc_html_x:1,2c',
          'esc_attr__:1',
          'esc_attr_e:1',
          'esc_attr_x:1,2c',
          '_ex:1,2c',
          '_n:1,2',
          '_nx:1,2,4c',
          '_n_noop:1,2',
          '_nx_noop:1,2,3c'
        ]
      },
      files:{
        src:  [ '**/*.php' ], //Parse all php files
        expand: true
      }
    },
    less: {                              // Task
      debug: {                            // Target
        options: {                       // Target options
          style: 'expanded'
        },
        files: {                         // Dictionary of files
          'admin/assets/css/ewp-media-button.css': 'admin/assets/css/ewp-media-button.less'       // 'destination': 'source'
        }
      },
      dist: {                            // Target
        options: {                       // Target options
          style: 'compressed'
        },
        files: {                         // Dictionary of files
          'admin/assets/css/ewp-media-button.min.css': 'admin/assets/css/ewp-media-button.less'       // 'destination': 'source'
        }
      }
    },
    cssmin: {
      target: {
        files: [{
          expand: true,
          cwd: 'admin/assets/css',
          src: ['*.css', '!*.min.css'],
          dest: 'admin/assets/css',
          ext: '.min.css'
        }]
      }
    },
    coffee: {
      compile: {
        files: {
          'admin/assets/js/ewp-media-button.js': 'admin/assets/js/ewp-media-button.coffee'
        }
      }
    },
    concat: {
      options: {
        banner: '<%= banner %>',
        stripBanners: true
      }
    },
    replace: {
      readme: {
        options: {
          patterns: [
            {
              match: /(Stable tag: \d+\.\d+\.\d+)/,
              replacement: 'Stable tag: <%= pkg.version %>'
            }
          ]
        },
        files: [
          {expand: true, flatten: true, src: ['readme.txt'], dest: './'}
        ]
      },
      vercode: {
        options: {
          patterns: [
            {
              match: /(Version: \d+\.\d+\.\d+)/,
              replacement: 'Version: <%= pkg.version %>'
            }
          ]
        },
        files: [
          {expand: true, flatten: true, src: ['endomondowp.php'], dest: './'}
        ]
      },
      vercode2: {
        options: {
          patterns: [
            {
              match: /('SVT_VER', '\d+\.\d+\.\d+')/,
              replacement: '\'SVT_VER\', \'<%= pkg.version %>\''
            }
          ]
        },
        files: [
          {expand: true, flatten: true, src: ['endomondowp.php'], dest: './'}
        ]
      }
    },
    uglify: {
      options: {
        banner: '<%= banner %>'
      },
      dist: {
        src: 'admin/assets/js/ewp-media-button.js',
        dest: 'admin/assets/js/ewp-media-button.min.js'
      }
    },
    watch: {
      sass:{
        files: [
          'admin/assets/css/ewp-media-button.less'
        ],
        tasks: ['less']
      },
      coffee:{
        files: ['admin/assets/js/**/*.coffee'],
        tasks: ['coffee','uglify']
      },
      sync: {
        files: [
          '**',
          '!node_modules/**/*',
          '!.sass-cache',
          '!.git*',
          '!**/*.scss',
          '!.idea'
        ],
        tasks: 'sync'
      }
    },
    sync: {
      hotdeploy: {
        files: [
          {
            cwd: '.',
            src: [
              '**',
              '!node_modules/**/*',
              '!.sass-cache',
              '!.git*',
              '!**/*.scss',
              '!.idea'
            ],
            dest: '<%= pkg.sandbox.dir %>'
          }
        ],
        verbose: true,
        pretend: false,
        updateAndDelete: true
      }
    },
    browserSync: {
      dev: {
        bsFiles: {
          src: [
            '<%= pkg.sandbox.dir %>/**/*'
          ]
        },
        options: {
          watchTask: true,
          debugInfo: true,
          logConnections: true,
          https:true,
          notify: true,
          proxy: "localhost",
          ghostMode: {
            scroll: true,
            links: true,
            forms: true
          }
        }
      }
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-replace');
  grunt.loadNpmTasks('grunt-pot');
  grunt.loadNpmTasks('grunt-sync');
  grunt.loadNpmTasks('grunt-browser-sync');
  grunt.loadNpmTasks('grunt-contrib-less');

  grunt.loadNpmTasks('grunt-contrib-cssmin');




  // Default task.
  grunt.registerTask('default', ['build']);
  grunt.registerTask('finalize', ['replace', 'build']);
  grunt.registerTask('dev', ['build', 'sync', 'browserSync', 'watch']);
  grunt.registerTask('build', ['less', 'cssmin', 'coffee', 'concat', 'uglify', 'replace']);

};
