function ReadFileAsOneString(filename)
    return StringTableToConcatString(ReadFile(filename))
end

function ReadFile(filename)
    local lines = {}
    local file = playdate.file.open(filename, playdate.file.kFileRead)
    local line = file:readline()
    while line do
        table.insert(lines, line)
        line = file:readline()
    end
    file:close()
    return lines
end

function StringTableToConcatString(table)
    local output = ""
    for i = 1, #table do
        output = output .. table[i]
    end
    return output
end
