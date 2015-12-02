class Semaphore
	attr_reader :crystal
	attr_writer :p, :crystal

	def initialize(n)
		@crystal = Array.new(n){0}
		@n = n
		@my_semaphore = Mutex.new
	end

	def run
		i = 0
		5.times do |k|
			random = rand()
			delta = 0
			

			if random < @p && i > 0
				delta = -1
			elsif i < (@n - 1)
				delta = 1
			end
			@my_semaphore.synchronize  do
				@crystal[i] -= 1
				@crystal[i + delta] += 1
			end
			i += delta
		end
	end
end
m = 10
item = Semaphore.new m
item.p = 0.5
item.crystal[0] = 10
threads = []

m.times do |i|
	threads << Thread.new do
		item.run
	end
end

threads.map { |t| t.join }

p item.crystal