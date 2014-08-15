module.exports = (grunt) ->
    "use strict"
    
    grunt.initConfig

        # Metadata
        pkg: grunt.file.readJSON 'package.json'
        copyright: "Copyright <%= grunt.template.today('yyyy') %>"
        banner: """/**********************************************************************************
                    * <%= pkg.name %> v<%= pkg.version %> (<%= pkg.homepage %>)
                    * <%= copyright %> <%= pkg.author.name %>
                    * Licensed under <%= _.pluck(pkg.licenses, 'url').join(', ') %>
                    **********************************************************************************/

                """
        source: ['src/code/*.coffee', 'src/code/extensions/*.coffee']

        # Task configuration
        clean: 
            build: ['build/']
            dist: ['dist/']               
            test: ['test/']        
        coffee: 
            options:
                join: true
                sourceMap: true
            build:
                src: '<%= source %>'
                dest: 'build/Content/Scripts/<%= pkg.name %>.js'
            test:
                files: 
                    'test/<%= pkg.name %>.js' : '<%= source %>'
                    'test/unit/tests.js' : ['src/test/unit/*.coffee']
        copy: 
            dist:
                src: '<%= coffee.build.dest %>'
                dest: 'dist/<%= pkg.name %>.js'
            test:
                expand: true
                cwd: 'require/'
                src: '**'
                dest: 'test/require'
        nugetpack:
            dist:
                src: 'build/Package.nuspec'
                dest: 'dist/'
        qunit:
            options:
                inject: 'require/test/phantom.js'
            unit:
                src: 'test/index.html'
        template:
            options:
                data:
                    author: '<%= pkg.author.name %>'
                    company: 'kodefuguru'
                    copyright: '<%= copyright %>'
                    description: '<%= pkg.description %>'
                    icon: '<%= pkg.homepage %>/logo'
                    id: '<%= pkg.name %>'
                    language: 'en-US'
                    neutralLanguage: 'en'
                    licenseUrl: "<%= _.pluck(pkg.licenses, 'url')[0] %>"
                    projectUrl: '<%= pkg.homepage %>'
                    requireLicenseAcceptance: 'false'
                    tags: "<%= pkg.keywords.join(' ') %>"
                    title: '<%= pkg.name %>'
                    version: '<%= pkg.version %>'
                    knockout:
                        version: '3.1.0'
            nuspec:
                src: 'src/templates/Package.nuspec'
                dest: 'build/Package.nuspec'
            readme:
                src: 'src/templates/readme.md'
                dest: 'readme.md'
            test:
                src: 'src/templates/test.html'
                dest: 'test/index.html'
        usebanner:
            build:
                options:
                    banner: '<%= banner %>'
                files: 
                    src: [ '<%= coffee.build.dest %>' ]
        watch: 
            src: 
                files: '<%= copy.src.src %>'
                tasks: ['build']

    grunt.loadNpmTasks 'grunt-banner'
    grunt.loadNpmTasks 'grunt-nuget'
    grunt.loadNpmTasks 'grunt-template'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-qunit'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.registerTask 'test', ['clean:test', 'coffee:test', 'template:test', 'copy:test', 'qunit']
    grunt.registerTask 'build', ['clean:build', 'coffee:build', 'usebanner:build', 'template:nuspec', 'template:readme']
    grunt.registerTask 'dist', ['clean:dist', 'nugetpack', 'copy:dist']
    grunt.registerTask 'default', ['build', 'test', 'dist']
 