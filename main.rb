print "処理したいテキストファイルのファイルパスを入力してください。\n(何も入力せずEnterでこのプログラムと同じ位置に存在するtext.txtを読み込みます。)\n>"
filename = gets.chomp!

if filename == '' then
  filename = "./text.txt"
else
  filename.rstrip!
end

paragraph = ""

open(filename, 'r') do |file|
  paragraph = file.read
end

paragraphAr = paragraph.split("\n")

size = paragraphAr.size
i = 1

result = ['<p>']
paragraphAr.each { |line|
  puts "#{i} / #{size}"
  lineAr = line.split(//)
  lineRe = []
  rubyFlag = false
  emptyLine = false
  gomaFlagS = 0
  gomaFlagE = 0
  bbFlagS = 0
  bbFlagE = 0
  if line == "" then
    result.pop
    lineRe.push("</p>\n<p>&nbsp;</p>\n<p>")
    emptyLine = true
  else
    lineAr.each { |s|
      if (s == "｜") then
        if bbFlagS < 1 then
          bbFlagS += 1
        elsif bbFlagS == 1 then
          bbFlagS += 1
          lineRe.push('<span class="bb">')
          p bbFlagS
        elsif bbFlagS ==2 && bbFlagE < 1 then
          bbFlagE += 1
        elsif bbFlagE == 1 then
          lineRe.push('</span>')
          bbFlagS = 0
          bbFlagE = 0
        end
      elsif ( s == '《') then
        if rubyFlag then
          lineRe.push('</rb><rp>（</rp><rt>')
        elsif gomaFlagS < 1 then
          gomaFlagS += 1
        elsif gomaFlagS == 1 then
          gomaFlagS += 1
          lineRe.push('<span class="goma">')
        end
      elsif ( s == '》') then
        if rubyFlag then
          lineRe.push('</rt><rp>）</rp></ruby>')
          rubyFlag = false
        elsif gomaFlagS == 2 && gomaFlagE < 1 then
          gomaFlagE += 1
        elsif gomaFlagE == 1 then
          lineRe.push('</span>')
          gomaFlagS = 0
          gomaFlagE = 0
        else
          lineRe.push('》')
          gomaFlagS = 0
          gomaFlagE = 0
        end
      elsif s == '—' then
        lineRe.push('―')
      else
        if gomaFlagS == 1 then
          lineRe.push('《')
          gomaFlagS = 0
        end
        if bbFlagS == 1 then
          lineRe.push('<ruby><rb>')
          rubyFlag = true
          bbFlagS = 0
        end
        if bbFlagS == 2 then
          lineRe.push('―')
        else
          lineRe.push(s)
        end
      end
      p "bbFlagS : #{bbFlagS} lineRe : #{lineRe}"
    }
  end
  if gomaFlagE == 1 then
    lineRe.push('》')
    gomaFlagE = 0
  elsif gomaFlagS == 1 then
    lineRe.push('《')
    gomaFlagS = 0
  end
  result.push(lineRe.join(''))
  if emptyLine then
    emptyLine = false
  else
    result.push("<br />\n")
  end
  i = i + 1
}
result.pop
result.push('</p>')

last_result = result.join('')

puts(last_result)

open('./result.txt', 'w') do |file|
  file.write(last_result)
end
