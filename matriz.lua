utl = require("utils")
Imaginario = require("imaginario")

local Matriz = {}
Matriz.mt = {__index = Matriz}

function Matriz.new( arr )
    local this = setmetatable({}, Matriz.mt)

    this.clsname = "Matriz"
    this.arr = arr
    this.i = #arr
    this.j = #arr[1]

    return this
end
function Matriz.mt.__tostring(m)
    local str = ""
    for i = 1, m.i, 1 do
        str = str .. "| "
        for j = 1, m.j, 1 do
            -- elem = m.arr[i][j] == 0 and 0 or 1
            elem = m.arr[i][j]
            str = str .. tostring(elem) .. ", "
        end
        str = str .. "|\n"
    end
    return str .. ""
end

function Matriz.mt.__eq (m1, m2)
    if m1.i ~= m2.i or m1.j ~= m2.j then return false end
    for i=1, m1.i do
        for j=1, m1.j do
            if m1.arr[i][j] ~= m2.arr[i][j] then return false end
        end
    end
    return true
end

-- MATRICES NOTABLES
function Matriz.ESCALAR(lenij, n)
    local escalar = {}
    for i=1, lenij do
        escalar[i] = {}
        for j=1, lenij do
            if i == j then elem = n
            else elem = 0 end
            escalar[i][j] = elem
        end
    end
    return Matriz.new(escalar)
end

function Matriz.IDENTIDAD(lenij)
    return Matriz.ESCALAR(lenij, 1)
end

function Matriz.NULA(leni, lenj)
    if leni == nil then return nil end
    local lenj = lenj or leni

    local nula = {}
    for i=1, leni do
        nula[i] = {}
        for j=1, lenj do
            nula[i][j] = 0
        end
    end
    return Matriz.new(nula)
end

-- MATRICES DERIVADAS
function Matriz.getTraza( m )
    -- TODO
end

function Matriz.getTraspuesta( m )
    local tras = {}
    for j=1, m.j do
        tras[j] = {}
        for i=1, m.i do
            -- elem = m.arr[i][j] == 0 and 0 or 1
            elem = m.arr[i][j]
            tras[j][i] = elem
        end
    end
    return Matriz.new(tras)
end


-- OPERACIONES ENTRE MATRICES
function Matriz.mt.__add (m1, m2)
    if type(m1) == "number" or type(m2) == "number" then
        error("Can't sum matriz with number")
    elseif m1.i ~= m2.i or m1.j ~= m2.j then
        error("Can't sum, array dimensions don't match")
    end

    local new_t = {}

    -- find the value of the sum of two arrays
    for i = 1, m1.i, 1 do
        new_t[i] = {}

        for j = 1, m1.j, 1 do
            -- new_t[i][j] = elem == 0 and 0 or 1
            elem = m1.arr[i][j] + m2.arr[i][j]
            new_t[i][j] = elem
        end
    end

    return Matriz.new(new_t)
end
function Matriz.mt.__sub (m1, m2)
    if type(m1) == "number" or type(m2) == "number" then
        error("Can't sum matriz with number")
    elseif m1.i ~= m2.i or m1.j ~= m2.j then
        error("Can't sum, array dimensions don't match")
    end

    local new_t = {}

    -- find the value of the sum of two arrays
    for i = 1, m1.i, 1 do
        new_t[i] = {}

        for j = 1, m1.j, 1 do
            -- new_t[i][j] = elem <= 0 and 0 or 1
            elem = m1.arr[i][j] - m2.arr[i][j]
            new_t[i][j] = elem
        end
    end

    return Matriz.new(new_t)
end

function Matriz.mt.__mul (m1, m2) -- parameters have to be 'number' or 'Matriz'
    local new_t = {}

    is1num = type(m1) == "number" 
    is2num = type(m2) == "number"
    if is1num or is2num then
        local k = is1num and m1 or m2
        local m = is2num and m1 or m2
        for i=1, #m.arr do
            new_t[i] = {}
            for j=1, #m.arr[1] do
                new_t[i][j] = m.arr[i][j] * k 
            end
        end
        return Matriz.new(new_t)
    elseif m1.j ~= m2.i then
        error("Can't multiply, array dimensions don't match")
    end

    local ntimes = m1.j  -- m2.i
    -- find the value of the product of two arrays
    for i = 1, m1.i, 1 do
        new_t[i] = {}

        for j = 1, m2.j, 1 do
            elem = 0
            for n = 1, ntimes, 1 do
                elem = elem + m1.arr[i][n] * m2.arr[n][j]
            end
            -- new_t[i][j] = elem == 0 and 0 or 1
            new_t[i][j] = elem
        end
    end

    return Matriz.new(new_t)

end

function Matriz.mt.__pow (m, n)
    if m.i ~= m.j then
        error("Can't elevate, array dimensions don't match")
    elseif n < 1 then
        error("Can't elevate, index has to be >= 1")
    end
    local new_m = 1
    for i=1, n do
        new_m = new_m * m
    end
    return new_m
end

--- PROPIEDADES DE UN CONJUNTO
function Matriz.esSimetrica( m )
    if m.i ~= m.j then
        return false
    end

    local count = 1
    for i = 2, m.i, 1 do
        for j = 1, count, 1 do
            _ij = m.arr[i][j] == 0 and 0 or 1
            _ji = m.arr[j][i] == 0 and 0 or 1

            if _ij ~= _ji then
                return false
            end
        end
        count = count + 1
    end

    return true
end

--- CERRADURA
-- function Matriz.cerrReflexiva( m )
--     return m + Matriz.IDENTIDAD(m.i)
-- end
-- function Matriz.cerrSimetrica( m )
--     return m + Matriz.getTraspuesta( m )
-- end
-- function Matriz.cerrTransitiva( m )
--     return m + m * m 
-- end

return Matriz