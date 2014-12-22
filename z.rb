#coding: utf-8

puts "画像を分解します"
system "ffmpeg -i mov.mov -s 1280x720 -b 50000 temp/frame%d.jpg"

puts "画像の枚数をカウントします"
images = 0
Dir.foreach("./temp").each do |image|
  images+=1
end
codes = []
puts "画像の枚数は#{images}枚です"

puts "画像の解析を開始します"
count = 0
images.times do |i|
	begin
		code = `zbarimg -q ./temp/frame#{i}.jpg`
		code = code.split(":")
		codes << code[1]
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