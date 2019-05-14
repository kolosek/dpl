module Dpl
  module Providers
    class Anynines < Provider
      description <<~str
        tbd
      str

      opt '--username USER',    'anynines username', required: true
      opt '--password PASS',    'anynines password', required: true
      opt '--organization ORG', 'anynines target organization', required: true
      opt '--space SPACE',      'anynines target space', required: true
      opt '--app_name APP',     'Application name'
      opt '--manifest FILE',    'Path to the manifest'

      API = 'https://api.aws.ie.a9s.eu'

      cmds install: 'test $(uname) = "Linux" && rel="linux64-binary" || rel="macosx64"; wget "https://cli.run.pivotal.io/stable?release=${rel}&source=github" -qO cf.tgz && tar -zxvf cf.tgz && rm cf.tgz',
           api:     './cf api %{url}',
           login:   './cf login -u %{username} -p %{password} -o %{organization} -s %{space}',
           push:    './cf push %{args}',
           logout:  './cf logout'

      errs push: 'Failed to push app'

      def install
        shell :install
      end

      def login
        shell :api
        shell :login
      end

      def deploy
        shell :push , assert: true
      end

      def finish
        shell :logout
      end

      private

        def url
          API
        end

        def args
          args = []
          args << quote(app_name)  if app_name?
          args << "-f #{manifest}" if manifest?
          args.join(' ')
        end
    end
  end
end
