function Image(img)
  if img.classes:find('contribution',1) then
    local f = io.open("./kallipos-notes/" .. img.src, 'r')
    local doc = pandoc.read(f:read('*a'))
    f:close()
    local contribution = pandoc.utils.stringify(doc.meta.contribution) or "Contribution has not been set"
    local student = pandoc.utils.stringify(doc.meta.student) or "Student has not been set"
    local id = pandoc.utils.stringify(doc.meta.id) or "ID has not been set"
    local line = "............................................................................................."
    line = line .. line
    line = "\n\n" .. line .. "\n\n"
    local text = line .. student .. " (" .. id .. ")" .. line .. " \n\n _" .. contribution .. "_ \n\n"
    text = text .. line
    return pandoc.RawInline('markdown', text )
  end
end