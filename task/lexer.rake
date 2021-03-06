rule '.rb' => '.rl' do |task|
  sh "ragel -F1 -R #{task.source} -o #{task.name}"

  puts "Applying patch http://git.io/ow6e1A to #{task.name}"

  # Patches the lexer based on http://git.io/ow6e1A.
  input  = File.read(task.source)
  output = File.read(task.name)
  getkey = input.match(/getkey\s+(.+);/)[1]

  output = output.gsub(getkey, '_wide')
  output = output.gsub('_trans = if', "_wide = #{getkey}\n  _trans = if")

  File.open(task.name, 'w') do |handle|
    handle.write(output)
  end
end

rule '.c' => ['.rl', 'ext/ragel/base_lexer.rl'] do |task|
  sh "ragel -I ext/ragel -C -G2 #{task.source} -o #{task.name}"
end

rule '.java' => ['.rl', 'ext/ragel/base_lexer.rl'] do |task|
  sh "ragel -I ext/ragel -J #{task.source} -o #{task.name}"
end

desc 'Generates the lexers'
multitask :lexer => [
  'ext/c/lexer.c',
  'ext/java/org/liboga/xml/Lexer.java',
  'lib/oga/xpath/lexer.rb',
  'lib/oga/css/lexer.rb'
]
