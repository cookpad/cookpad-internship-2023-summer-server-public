namespace :ridgepole do
  desc 'Show difference between schema definition and actual schema'
  task :'dry-run' do
    sh 'ridgepole', '--config', 'config/database.yml',
      '--env', ENV.fetch('RAILS_ENV', 'development'), '--apply', '--dry-run', '--file', 'db/Schemafile', '--drop-table'
  end

  desc 'Apply schema definition'
  task :apply do
    env = ENV.fetch('RAILS_ENV', 'development')

    if env == 'development'
      %w[development test].each do |e|
        sh 'ridgepole', '--config', 'config/database.yml',
          '--env', e, '--apply', '--file', 'db/Schemafile', '--drop-table'
      end
    else
      sh 'ridgepole', '--config', 'config/database.yml',
        '--env', env, '--apply', '--file', 'db/Schemafile', '--drop-table'
    end
  end

  desc 'Merge schema definition'
  task :merge do
    sh 'ridgepole', '--config', 'config/database.yml',
      '--env', ENV.fetch('RAILS_ENV', 'development'), '--merge', '--file', 'db/Schemafile'
  end
end
