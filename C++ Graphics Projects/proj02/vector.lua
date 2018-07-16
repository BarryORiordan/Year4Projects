module(..., package.seeall)

function substractVector(e, at)
  d = {}
  d[1] = at[1] - e[1]
  d[2] = at[2] - e[2]
  d[3] = at[3] - e[3]
  return d
end

function dotProduct(vect1, vect2)
  sum = (vect1)[1] * (vect2)[1] + (vect1)[2] * (vect2)[2] + (vect1)[3] * (vect2)[3];
  return sum          
end

function scalarMultiplication(beta, d)
  sum = {}
  sum[1] = d[1] * beta
  sum[2] = d[2] * beta
  sum[3] = d[3] * beta
  return sum
end

function subtraction(ugen, sub)
  sum = {}
  sum[1] = ugen[1] - sub[1]
  sum[2] = ugen[2] - sub[2]
  sum[3] = ugen[3] - sub[3]
  return sum
end

function normal(vector)
  sum = vector[1] * vector[1] + vector[2] * vector[2] + vector[3] * vector[3]
  sqSum = math.sqrt(sum)
    result = {}
    result[1] = vector[1] / sqSum
    result[2] = vector[2] / sqSum
    result[3] = vector[3] / sqSum
  return result
end

function crossProduct(v1, v2)
  vect = {}
  vect[1] = ((v1)[2] * (v2)[3] - (v1)[3] * (v2)[2]);
  vect[2] = ((v1)[3] * (v2)[1] - (v1)[1] * (v2)[3]);
  vect[3] = ((v1)[1] * (v2)[2] - (v1)[2] * (v2)[1]);
  return vect
end