printf "処理したいテキストファイルのファイルパスを入力してください。\n(何も入力せずEnterでこのプログラムと同じ位置に存在するtext.txtを読み込みます。)\n>"
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

result = ['<p>']
paragraphAr.each { |line|
  lineAr = line.split(//)
  lineRe = []
  rubyFlag = false
  emptyLine = false
  gomaFlagS = 0
  gomaFlagE = 0
  if line == "" then
    result.pop
    lineRe.push("</p>\n<p>&nbsp;</p>\n<p>")
    emptyLine = true
  else
    lineAr.each { |s|
      if (s == "｜") then
        lineRe.push('<ruby><rb>')
        rubyFlag = true
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
        lineRe.push(s)
      end
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
}
result.pop
result.push('</p>')

last_result = result.join('')

printf(last_result + ("\n"))

open('./result.txt', 'w') do |file|
  file.write(last_result)
end
