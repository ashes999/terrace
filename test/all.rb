exclusions = ['test_config.rb', 'all.rb']

tests = Dir.glob('**/*.rb').select { |f|
	# Ignore this file, and our test config file
	next if f == $0 || exclusions.include?(f)
	f = f[0, f.rindex('.rb')]
	require_relative "#{f}"
}
