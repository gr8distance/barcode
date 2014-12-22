#coding: utf-8

require "parallel"

puts "画像を分解します"
system "ffmpeg -i mov.mov -s 1280x720 -b 50000 temp/frame%d.jpg"

puts "画像の枚数をカウントします"
images = []
i = 1
Dir.foreach("./temp").each do
  images << "./temp/frame#{i}.jpg"
	i+=1
end

locker = Mutex.new
codes = []
puts "画像の枚数は#{images.length}枚です"
puts "画像の解析を開始します"
count = 0

Parallel.each(images,in_threads: 4) do |i|
	begin
		code = `zbarimg -q #{i}`
		locker.synchronize do
			code = code.split(":")
			codes << code[1]
		end
	rescue => e
		puts e
	end
   print "=>"
  if (count % 100) == 0
    puts count
  end
  count+=1
end
puts "解析完了"


codes.uniq!
show_codes = []
codes.each do |code|
  unless code.nil?
    show_codes << code.split("\n")[0]
  end
end
show_codes.select!{|code| /^49*/ =~ code}


show_codes.uniq!
show_codes.each do |code|
  puts code
end
