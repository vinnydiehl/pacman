SCENES = %w[game].freeze

%w[inputs pacman].each { |f| require "app/pacman/#{f}.rb" }

%w[scenes render].each { |dir| SCENES.each { |f| require "app/pacman/#{dir}/#{f}.rb" } }

def tick(args)
  args.state.game ||= PacMan.new(args)
  args.state.game.tick
end
