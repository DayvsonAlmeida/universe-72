require 'class'

math.randomseed(os.time())

local function matrix_base(m, rows, columns)
  m.rows = rows
  m.columns = columns
  m.data = {}
  for i=1, m.rows do
    m.data[i] = {}
    for j=1, m.columns do
      m.data[i][j] = math.random()
      -- m.data[i][j] = math.random(0,10)
    end
  end
end

Matrix = Class(matrix_base)

---------------------------------- Operações -----------------------------------
function escalarMultiply(A, alpha)
  out = Matrix(A.rows, A.columns)
  for i=1, A.rows do
    for j=1, A.columns do
      out.data[i][j] = alpha * A:at(i,j)
    end
  end
  return out
end


function add(A, B)
  out = Matrix(A.rows, A.columns)
  for i=1, A.rows do
    for j=1, A.columns do
      out.data[i][j] = A:at(i,j) + B:at(i,j)
    end
  end
  return out
end


function subtract(A, B)
  out = Matrix(A.rows, A.columns)
  for i=1, A.rows do
    for j=1, A.columns do
      out.data[i][j] = A:at(i,j) - B:at(i,j)
    end
  end
  return out
end


function multiply(A, B)
  out = Matrix(A.rows, B.columns)
  for i=1, out.rows do
    for j=1, out.columns do
      out.data[i][j] = 0
    end
  end

  for i=1, A.rows do
    for j=1, B.columns do
      for k=1, A.columns do
        out.data[i][j] = out:at(i,j) + (A:at(i,k) * B:at(k,j))
      end
    end
  end

  return out
end


function transpose(A)
  out = Matrix(A.columns, A.rows)
  for i=1, A.rows do
    for j=1, A.columns do
      out.data[j][i] = A:at(i,j)
    end
  end
  return out
end

function hadamard(A, B)
  out = Matrix(A.rows, A.columns)
  for i=1, A.rows do
    for j=1, A.columns do
      out.data[i][j] = A:at(i,j) * B:at(i,j)
    end
  end

  return out
end

----------------------------------- Diversos -----------------------------------
function Matrix:at(i,j)
  return self.data[i][j]
end

function apply(A, fun)
  out = Matrix(A.rows, A.columns)
  for i=1, A.rows do
    for j=1, A.columns do
      out.data[i][j] = fun(A.data[i][j])
    end
  end
  return out
end

function Matrix:print()
  for i=1, self.rows do
    for j=1, self.columns do
      io.write("[",string.format("%.4f",self.data[i][j]),"] ")
    end
    print()
  end
end


function arrayToMatrix(x)
  len = #x
  out = Matrix(len, 1)
  for i=1, len do
    out.data[i][1] = x[i]
  end

  return out
end


function matrixToArray(A)
  out = {}
  for i=1, A.rows do
    for j=1, A.columns do
      table.insert(out, A:at(i,j))
    end
  end

  return out
end
